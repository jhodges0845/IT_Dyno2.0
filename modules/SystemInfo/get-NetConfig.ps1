function get-NetConfig{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--NetConfig function started."
        $NetConfig_Info = $Null
        $NetConfig_Info = $Null
        $NetConfig_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get NetworkConfig data without credentials#
                write-verbose "----attempting to get NetworkConfig data for $Computer."
                $NetConfig_Info = gwmi win32_NetworkAdapterConfiguration -ComputerName $Computer -ErrorAction Stop | ?{$_.MACAddress -ne $Null} | select $Property
                write-verbose "----NetConfig_Info : $NetConfig_Info"
            }else{
                    #Try to get NetworkConfig data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $NetConfig_Info = gwmi win32_NetworkAdapterConfiguration -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | ?{$_.MACAddress -ne $Null} | select $Property
                write-verbose "----NetConfig_Info : $NetConfig_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $NetConfig_Infos += $NetConfig_Info
            write-verbose "----Added stored data to array for NetworkConfig for $Computer"

        }#END_FOREACH#
        write-output $NetConfig_Infos
    }#END_PROCESS#
}#END_FUNCTION#