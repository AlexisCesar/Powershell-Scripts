 
$computers = 1..7 | ForEach-Object { "SRV_0$_" };


$jobScriptBlock = {
    param(
        [String] $computerName
    )

    Write-Host "Installing feature in $computerName"
}


$computers | ForEach-Object { 
    Start-Job -Name "JOB $_" -ScriptBlock $jobScriptBlock -ArgumentList ($_)
}

# Requires RSAT
# To find windows feature name: Get-WindowsFeature -ComputerName nameOfComputer (name property)
# $computers | % { Start-Job { Install-WindowsFeature -Name Web-WebSocket -ComputerName $_ } }

# Get-Job

# (Get-Job)[-1] | Format-List

# $jobReturn = Receive-Job (Get-Job)[-1].Name # Receive-Job removes the value from memory after being read, so it should be
# stored in a variable, or, use it like this:
# Receive-Job ((Get-Job)[-1].Name) -Keep

# it is possible to get all jobs with Receive-Job (Get-Job)

# to clear jobs in session Remove-Job (Get-Job)

<#
also it's possible to use args without a scriptblock declaring params, like this
Start-Job -ArgumentList ($_) -ScriptBlock { Write-Host "Running in $args[0]" }
#>