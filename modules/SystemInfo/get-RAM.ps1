function get-RAM{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--RAM function started."
        $RAM_Info = $Null
        $RAM_Info = $Null
        $RAM_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get RAM data without credentials#
                write-verbose "----attempting to get RAM data for $Computer."
                $RAM_Info = gwmi win32_PhysicalMemory -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----RAM_Info : $RAM_Info"
            }else{
                    #Try to get RAM data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $RAM_Info = gwmi win32_PhysicalMemory -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----RAM_Info : $RAM_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $RAM_Infos += $RAM_Info
            write-verbose "----Added stored data to array for RAM for $Computer"

        }#END_FOREACH#
        write-output $RAM_Infos
    }#END_PROCESS#
}#END_FUNCTION#