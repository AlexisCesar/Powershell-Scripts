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

# UI customization
$originalPromptFunction = $function:prompt

<#
Function to override the function that runs when a command is executed in PS.
#>
function prompt {
	$auxErrActionPref = $ErrorActionPreference
	$ErrorActionPreference = "Continue"

	# TODO: Improve this to a less expensive git verficiation, status can take too long on large projects with submodules
	Write-Host ""
	git status > $null
	if($?) {
		LogCurrentGitBranch
	}

	LogCurrentCommandTimeStamp
	
	$ErrorActionPreference = $auxErrActionPref
	EnsureDefaultColors
	&$originalPromptFunction
}
