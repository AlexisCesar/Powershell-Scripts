Add-Type -AssemblyName System.Windows.Forms

$private:back = false

while($true) {
	$Pos = [System.Windows.Forms.Cursor]::Position
	$x = ($pos.X % 500) + 20
	$y = ($pos.Y % 500) + 20
	[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
	Start-Sleep -Seconds 10
}
