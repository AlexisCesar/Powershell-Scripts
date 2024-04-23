# Used to run applications in the remote computer, if trying to execute an application in the local session pointing to a remote path, it will try to run locally.
Enter-PSSession -ComputerName SRV01 
Exit-PSSession
#only works in interactive ps session, for example, typing the command in the console
# if trying to access a remote ps session within a script, NewPSSession should be used like this
#
$session = New-PSSession -ComputerName SRV01

#running commands in this session:
Invoke-Command -Session $session -ArgumentsList (...) -ScriptBlock { ...$($args[0])... }  #it is possible to add -AsJob flag to run it in parallel

#dispose and remove
$session | Remove-PSSession
