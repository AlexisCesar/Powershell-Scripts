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
	start ((ls *.sln)[0])
}

function LogCurrentGitBranch() {
	Write-Host "GIT: you are in $(git branch --show-current)" -ForeGroundColor "DarkMagenta" -BackgroundColor $defaultBackgroundColor
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

	$fileNameExpr = "*sln"

	$selectParams = @($propExpr, $conversionExpr)

	Get-ChildItem -Recurse -File |
	Where-Object -Property Name -Like "*sln" |
	Select-Object $selectParams
}

function DisplayMOTD(){
	Write-Host " __  __     ______     __         __         ______           " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "/\ \_\ \   /\  ___\   /\ \       /\ \       /\  __ \          " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "\ \  __ \  \ \  __\   \ \ \____  \ \ \____  \ \ \/\ \         " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host " \ \_\ \_\  \ \_____\  \ \_____\  \ \_____\  \ \_____\        " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "  \/_/\/_/   \/_____/   \/_____/   \/_____/   \/_____/        " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "                                                              " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host " ______     __         ______     __  __     __     ______    " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "/\  __ \   /\ \       /\  ___\   /\_\_\_\   /\ \   /\  ___\   " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "\ \  __ \  \ \ \____  \ \  __\   \/_/\_\/_  \ \ \  \ \___  \  " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host " \ \_\ \_\  \ \_____\  \ \_____\   /\_\/\_\  \ \_\  \/\_____\ " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
	Write-Host "  \/_/\/_/   \/_____/   \/_____/   \/_/\/_/   \/_/   \/_____/ " -ForeGroundColor $startMessageColor -BackgroundColor $defaultBackgroundColor
}

function ClearOverride() {
	Clear-Host
	DisplayMOTD
}

# Messages
ClearOverride

# Aliases
Set-Alias gka gitk
Set-Alias v vim
Set-Alias gs RunGitStatus
Set-Alias dev GoToDevFolder
Set-Alias sln StartVSSolutionInCurrentFolder
Set-Alias ss ShowSolutionsRecursively
Set-Alias clear ClearOverride -Option AllScope

# UI customization
$originalPromptFunction = $function:prompt

<#
Function to override the function that runs when a command is executed in PS.
#>
function prompt {
	$auxErrActionPref = $ErrorActionPreference
	$ErrorActionPreference = "Continue"
	git status | Out-Null
	if($?) {
		Write-Host ""
		LogCurrentGitBranch
		LogCurrentCommandTimeStamp
	} else {
		Write-Host ""
		LogCurrentCommandTimeStamp
	}
	$ErrorActionPreference = $auxErrActionPref
	EnsureDefaultColors
	&$originalPromptFunction
}
