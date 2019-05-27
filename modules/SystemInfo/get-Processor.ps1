function get-Processor{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--Processor function started."
        $Processor_Info = $Null
        $Processor_Info = $Null
        $Processor_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get Processor data without credentials#
                write-verbose "----attempting to get Processor data for $Computer."
                $Processor_Info = gwmi win32_Processor -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----Processor_Info : $Processor_Info"
            }else{
                    #Try to get Processor data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $Processor_Info = gwmi win32_Processor -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----Processor_Info : $Processor_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $Processor_Infos += $Processor_Info
            write-verbose "----Added stored data to array for Processor for $Computer"

        }#END_FOREACH#
        write-output $Processor_Infos
    }#END_PROCESS#
}#END_FUNCTION#