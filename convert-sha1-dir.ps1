# Directory where all files will be converted to SHA1
param($directory)

$defaultErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Stop"

. ./convert-sha.ps1

Get-ChildItem $directory -File | ForEach-Object { ConvertTo-SHA1($_.FullName) }

$ErrorActionPreference = $defaultErrorActionPreference;

