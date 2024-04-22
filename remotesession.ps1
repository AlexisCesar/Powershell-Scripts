# Used to run applications in the remote computer, if trying to execute an application in the local session pointing to a remote path, it will try to run locally.
Enter-PSSession -ComputerName SRV01

Exit-PSSession
