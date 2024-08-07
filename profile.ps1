# TODO: USE PRIVATE VARIABLES // IMPROVE FUNCTIONS TO VERIFY FOLDER AND GIT AND LOG IF NOT EXISTS...

# Preferences
$ErrorActionPreference = "Stop"

# Colors
$defaultBackgroundColor = "Black"
$defaultForegroundColor = "DarkGray"
$startMessageColor = "Yellow"
$Host.UI.RawUI.BackgroundColor=$defaultBackgroundColor
$Host.UI.RawUI.ForegroundColor=$defaultForegroundColor

Set-Location ~

# Functions
function GoToDevFolder() {
	Set-Location "C:/dev"
}

function RunGitStatus() {
	git status
}

function StartVSSolutionInCurrentFolder() {
	Start-Process ((Get-ChildItem *.sln)[0])
}

function LogCurrentPath() {
	# Error indicator
	if($?) {
		$healthStatus = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F493",16));
		$healthColor = "DarkGreen"
	} else {
		$healthColor = "DarkRed"
		$healthStatus = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F494",16));
	}

	$auxErrActionPref = $ErrorActionPreference
	$ErrorActionPreference = "Continue"

	Write-Host ""

    $fullPath = Get-Location
    $fullPathSplited = $fullPath -split "\\"
   
    $colorArray = "DarkYellow", "DarkRed", "DarkCyan", "Green", "DarkBlue"
    $colorCount = 0;
 
    foreach ($item in $fullPathSplited) {
		if($item -match "[a-zA-Z]:") {
			Write-Host -NoNewline " $([System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F30C",16))) $($item) " -BackgroundColor $colorArray[$colorCount] -ForegroundColor White
		} else {
			Write-Host -NoNewline " $($item) " -BackgroundColor $colorArray[$colorCount] -ForegroundColor White
		}
        $colorCount = $colorCount + 1
		if($colorCount -gt 4) {
			$colorCount = 0
		}
        Start-Sleep -Milliseconds 30
    }
   
    $gitName = $(git branch --show-current);
   
    if ($gitName) {
        Write-Host -NoNewline " $([System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F333",16))) $($gitName) " -BackgroundColor Magenta -ForegroundColor White
    }

	Write-Host -NoNewline " $([System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F550",16))) $(Get-Date -Format hh:mm) " -BackgroundColor White -ForegroundColor Black

	$batteryLevel = (Get-WmiObject win32_battery).estimatedChargeRemaining;

	if(-Not $batteryLevel) {
		$batteryLevel = 100
	}

	Write-Host -NoNewline " $([System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F50B",16))) $($batteryLevel)% " -BackgroundColor DarkGray -ForeGroundColor Black

	Write-Host -NoNewline " $($healthStatus) " -BackgroundColor $healthColor

	Write-Host -NoNewline " "
	Write-Host -NoNewline " >>> " -BackgroundColor Red -ForegroundColor White	
	
	$ErrorActionPreference = $auxErrActionPref
	EnsureDefaultColors

	return " "
}

function LogCurrentGitBranch() {
	Write-Host "GIT: you are in $(git branch --show-current)" -ForeGroundColor "Magenta" -BackgroundColor $defaultBackgroundColor
}

function LogCurrentCommandTimeStamp() {
	Write-Host "Executed at $(Get-Date)" -ForeGroundColor "DarkGreen" -BackgroundColor $defaultBackgroundColor
}

function EnsureDefaultColors() {
	$Host.UI.RawUI.BackgroundColor=$defaultBackgroundColor
	$Host.UI.RawUI.ForegroundColor=$defaultForegroundColor
}

function ShowSolutionsRecursively() {
	Write-Host "Searching all .sln files recursively..." -ForegroundColor "DarkYellow" -BackgroundColor $defaultBackgroundColor
	$propExpr = @{
		"Label" = "File Name";
		"Expression" = {$_.Name};
	}

	$conversionExpr = @{}
	$conversionExpr.Add("Label", "File Size")
	$conversionExpr.Add("Expression", { "{0:N4}MB" -f ($_.Length / 1MB) })

	$selectParams = @($propExpr, $conversionExpr)

	Get-ChildItem -Recurse -File |
	Where-Object -Property Name -Like "*sln" |
	Select-Object $selectParams
}

function DisplayMOTD($addDelay = $true) {
	$delay = 0;

	if ($addDelay) {
		$delay = 3;
	}

	$linesToPrint = @(
		"          _.._",
		"        .' .-'`    |",
		"       /  /      - * -",
		"       |  |        |",
		"       \  '.___.;",
		"   .    '._  _.'",
		"  -*-      ````",
		"   ``"
		
	);

	foreach ($line in $linesToPrint) {
		Write-Host $line -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
		Start-Sleep -Milliseconds $delay
	}
}

function ClearOverride() {
	Clear-Host
	DisplayMOTD $false
}

# Messages
Clear-Host
DisplayMOTD

# Aliases
Set-Alias gka gitk
Set-Alias v vim
Set-Alias gs RunGitStatus
Set-Alias dev GoToDevFolder
Set-Alias sln StartVSSolutionInCurrentFolder
Set-Alias ss ShowSolutionsRecursively
Set-Alias clear ClearOverride -Option AllScope

function prompt {
	LogCurrentPath
}
