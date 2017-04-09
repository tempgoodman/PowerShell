for ( $i = 0; $i -lt $args.count; $i++ ) {
    if ($args[ $i ] -eq "-s"){ $strSource=$args[ $i+1 ]}
    if ($args[ $i ] -eq "-d"){ $strDestination=$args[ $i+1 ]}
}
$time = Get-Date -format g
Write-Host $time Start script `r
Write-Host $time Source = $strSource `r
Write-Host $time Destination = $strDestination `r


	Get-ChildItem -Path $strSource -Filter "*.*" | 	
	Sort-Object -Property LastWriteTime | ForEach-Object {
        $SQLServer = "TAPDBCNP05.tollgroup.local"
        $SQLDBName = "TGF_iNTEGRATION"
        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = "Server=$SQLServer;Database=$SQLDBName;Integrated Security=True;User ID=tgf_bim;Password="
        $SqlCmd = New-object System.Data.SqlClient.SqlCommand
        $SqlCmd.CommandText = "select top 1 * from TGF_THIRD_PARTY_EVENTS where insert_Date > getdate() - 12 and input_file_name = '"+$_.FullName +"'";
        $SqlCmd.Connection = $SqlConnection
        $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
        $SqlAdapter.SelectCommand = $SqlCmd
        $DataSet = New-Object System.Data.DataSet
        $SqlAdapter.Fill($DataSet)
        $SqlConnertion.Close()

        if ($DataSet.Tables[0].Rows.Count -eq 0 )
        {      
        	Move-Item $_.FullName $strDestination
            $time = Get-Date -format g
            write-host $_.FullName 
        }
	}


$time = Get-Date -format g 
Write-Host $time Script Finished `r
Write-Host ------------------------------------------- `r
