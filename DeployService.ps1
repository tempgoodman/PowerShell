$dtstring = Get-Date -Format "yyyyMMddhhmmss"
$programsource = "c:\serverstatus\*"
$baskupfoldertemplate = "\\servername\c$\serverstatus\bak_" + $dtstring 
$sourcefoldertemplate = "\\servername\c$\serverstatus" 
$servicename = "ServerStatus"

$servers = @("tapapcnp07")
Set-PSDebug -Trace 0
foreach ($servername in $servers)
{
	$baskupfolder = $baskupfoldertemplate.Replace("servername",$servername)
	$sourcefolder = $sourcefoldertemplate.Replace("servername",$servername)
	New-Item -ItemType directory -Path $baskupfolder 
	write-host "Deploy to "$servername
	write-host "Going to Stop "$servicename" in "$servername
	(get-service -ComputerName $servername -Name $servicename ).Stop()
	write-host "Stopped "$servicename" in server "$servername
	write-host "Backup files....."
	Get-ChildItem -Path $sourcefolder -Filter "*.*" |  Where-Object { ! $_.PSIsContainer }|	
		Sort-Object -Property LastWriteTime | ForEach-Object {
				Copy-Item $_.FullName $baskupfolder
		}
	write-host "Deploy the new version to "$servername"......."
	Copy-Item $programsource  $sourcefolder -Force
	write-host "Going to start "$servicename" in "$servername
	(get-service -ComputerName $servername  -Name ServerStatus ).Start(0)
	write-host "Started "$servicename" in server "$servername
}
