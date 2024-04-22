# create a virtual drive to map a location in PS, useful to make paths shorter

New-PSDrive -Name SRV01_SOMEFOLDER -Root \\srv01\c$\someFolder -PSProvider FileSystem

Get-PSDrive
