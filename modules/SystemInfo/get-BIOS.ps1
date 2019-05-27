function get-BIOS{
    [cmdletbinding()]
    Param(
        [string[]]$ComputerName,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--BIOS function started."
        $BIOS_Info = $Null
        $BIOS_Info = $Null
        $BIOS_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get BIOS data without credentials#
                write-verbose "----attempting to get BIOS data for $Computer."
                $BIOS_Info = gwmi win32_BIOS -ComputerName $Computer -ErrorAction Stop  | select $Property
                write-verbose "----BIOS_Info : $BIOS_Info"
            }else{
                    #Try to get BIOS data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $BIOS_Info = gwmi win32_BIOS -ComputerName $Computer -Credential $Credentials -ErrorAction Stop |  select $Property
                write-verbose "----BIOS_Info : $BIOS_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $BIOS_Infos += $BIOS_Info
            write-verbose "----Added stored data to array for BIOS for $Computer"

        }#END_FOREACH#
        write-output $BIOS_Infos
    }#END_PROCESS#
}#END_FUNCTION#