 
$computers = 1..7 | % { "COMPUTER_SRV_0$_" };

$computers | % { Start-Job { Write-Host "test in $_" } }

# Requires RSAT
# To find windows feature name: Get-WindowsFeature -ComputerName nameOfComputer (name property)
# $computers | % { Start-Job { Install-WindowsFeature -Name Web-WebSocket -ComputerName $_ } }