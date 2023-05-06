# Make a lookup table by process ID
# $Processes = @{}
# Get-Process -IncludeUserName | ForEach-Object {
#     $Processes[$_.Id] = $_
# }

# Get-NetTCPConnection |
#     Where-Object { $_.State -eq "Established" } |
#     Select-Object RemoteAddress,
#         RemotePort,
#         @{Name="PID";         Expression={ $_.OwningProcess }},
#         @{Name="ProcessName"; Expression={ $Processes[[int]$_.OwningProcess].ProcessName }},
#         @{Name="UserName";    Expression={ $Processes[[int]$_.OwningProcess].UserName }} |
#     Sort-Object -Property ProcessName, UserName |
#     Format-Table -AutoSize

$nets = netstat -ano | select-string Established
foreach($n in $nets){
    # make split easier PLUS make it a string instead of a match object:
    $p = $n -replace ' +',' '
    # make it an array:
    $nar = $p.Split(' ')
    # pick last item:
    $pname = $(Get-Process -id $nar[-1]).ProcessName
    $ppath = $(Get-Process -id $nar[-1]).Path
    # print the modified line with processname instead of PID:
    $n -replace "$($nar[-1])","$($ppath) $($pname)"
}
