for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "-s"){ $strSource=$args[ $i+1 ]}
    if ($args[ $i ] -eq "-d"){ $strDestination=$args[ $i+1 ]}
    if ($args[ $i ] -eq "-l"){ $strLimit=$args[ $i+1 ]}
    if ($args[ $i ] -eq "-p"){ $strPut=$args[ $i+1 ]}
}
$time = Get-Date -format g
Write-Host $time Start script `r

Write-Host $time Source = $strSource `r
Write-Host $time Destination = $strDestination `r
Write-Host $time Limit = $strLimit `r
Write-Host $time Put = $strPut `r

$count = ( Get-ChildItem $strSource | Measure-Object ).Count;


$time = Get-Date -format g 

$time = Get-Date -format g 
Write-Host $time Number of file is waiting = $count `r

$count = ( Get-ChildItem $strDestination -Filter "MBLEVENT_*.*"  | Measure-Object ).Count;

$count = $count + ( Get-ChildItem $strDestination -Filter "HBLEVENT_*.*"  | Measure-Object ).Count;

$time = Get-Date -format g 
Write-Host $time Number of file is processing in Listener folder MBLEVENT and HBLEVENT = $count `r

$loopcount = 1
if ($strlimit -gt $count ){
	Get-ChildItem -Path $strSource -Filter "*.*" | 	
	Sort-Object -Property LastWriteTime | ForEach-Object {
		if ( $strPut + 1 -gt $loopcount)	
		{
			Move-Item $_.FullName $strDestination
        		$time = Get-Date -format g
		        Write-Host $time $loopcount copy $_.FullName to $strDestination `r
			$loopcount = $loopcount + 1
		}	
		else
		{return}
	}
}
else
{
$time = Get-Date -format g 
Write-Host $time Server Busy `r
}
$time = Get-Date -format g 
Write-Host $time Script Finished `r
Write-Host ------------------------------------------- `r
