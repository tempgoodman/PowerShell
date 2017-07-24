Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll"

$ftpserver = '168.63.206.59'
$username = 'pong'
$password = '#pong&12*'
$targetDir = 'C:\Lin_bak'
$localDir = '\\192.168.18.68'
$targetDir2 = 'C:\BAK_FOR_THE_CHANGE'
#$Site = 'SA-36'
#$Site = 'saloncasino'
$Site = 'clubs'
#$Site = 'clubsvn'
#$Site = 'clubaua'
#$Site = 'clubgj'
#$Site = 'SalonPremier'
#$Site = 'SalonPremier2' 
#$localDir = '\\192.168.18.68\project'
#$Site = 'clubsoperator'
#$Site = 'sag'
$source = "/Lin/$($Site)/*"



$targetSiteDir = "$($targetDir)\$($Site)"
$target = "$($targetSiteDir)\*"

$targetSiteDir2 = "$($targetDir2)\$($Site)"
$target2 = "$($targetSiteDir2)\*"

			
# Check target directory exists or not
if (-Not (Test-Path $targetDir))
{
    New-Item $targetDir -type directory
    Write-Host "$($targetDir) created."
}

    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = $ftpserver
    UserName = $username
    Password = $password
}

$session = New-Object WinSCP.Session
            
try
{
                
    Write-Host "Try to Login to FTP...."
    # Connect
    $session.Open($sessionOptions)
                
    Write-Host "logged in....."
    #Write-Host $source
    # Write-Host $target
    Write-Host "Start downloading files..."
    # Download files
    $transferResult = $session.GetFiles($source, $target)
    $transferResult2 = $session.GetFiles($source, $target2)
    #Write-Host $transferResult.Transfers[0].FileName
    if ( $transferResult.IsSuccess -and $transferResult2.IsSuccess)
    {
        Write-Host "Download files completed..."
        Write-Host "Remove file from FTP...."
        $RemoveResult  = $session.RemoveFiles($source);
        if ($RemoveResult.IsSuccess)
            {
        Write-Host "Removed...."
        }
        else
        {
        Write-Host "Remove fail..."
        }
    }
}
finally
{
    # Disconnect, clean up
    $session.Dispose()
}
$Now = Get-Date -UFormat "%Y%m%d%H%M%S"
$locallogfilename =  $targetSiteDir+"\"+$Now+"_local.txt"
$logfilename =  $targetSiteDir+"\"+$Now+".txt"


get-childitem $targetSiteDir -recurse |  % {
    $fullfilename =  $_.FullName
    $fullfilename =  $fullfilename  -replace "c:\\Lin_bak\\",""
    Write-output $fullfilename  >> $logfilename
    Write-output $_.FullName  >> $locallogfilename
}

foreach( $obj in $transferResult2.Transfers)
{
    $fullfilename= $obj.FileName -replace "/Lin/" ,"$($targetDir2)\"
    $fulllocalfilename = $obj.FileName -replace "/Lin/" ,"$($localDir)\"
    $fulllocalfilename = $fulllocalfilename -replace "SA-36", "SA36"
    #Write-host $fulllocalfilename
    if (Test-Path $fulllocalfilename )
    {
        #Write-host "File Exisits.."
        Copy-Item $fulllocalfilename -Destination $fullfilename -Force
    }
    #Write-host $fullfilename
}


foreach( $obj in $transferResult2.Transfers)
{
    $fullfilename= $obj.FileName -replace "/Lin/" ,"$($targetDir)\"
    $fulllocalfilename = $obj.FileName -replace "/Lin/" ,"$($localDir)\"
    $fulllocalfilename = $fulllocalfilename -replace "SA-36", "SA36"
    $fulllocalfilename = $fulllocalfilename -replace "clubaua", "clubA"
    #Write-host $fullfilename
    if (Test-Path $fullfilename )
    {
        #Write-host "File Exisits.."
        Copy-Item $fullfilename -Destination $fulllocalfilename -Force
    }
    #Write-host $fulllocalfilename
}

Write-Host "Backup downloaded files..."
            

$targetBackup ="$($targetSiteDir)_$($Now).zip"
            
# Backup files
            
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
sz a -mx=9 $targetBackup $targetSiteDir
Write-Host "Backup completed to $($targetBackup)"


Write-Host "Backup local files..."
            
$targetBackup ="$($targetSiteDir2)_$($Now).zip"
            
# Backup files
            
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
sz a -mx=9 $targetBackup $targetSiteDir2
Write-Host "Backup completed to $($targetBackup)"


Remove-Item $targetSiteDir -recurse
Remove-Item $targetSiteDir2 -recurse