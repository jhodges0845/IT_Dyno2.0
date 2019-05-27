function get-MB{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--MB function started."
        $MB_Info = $Null
        $MB_Info = $Null
        $MB_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get MB data without credentials#
                write-verbose "----attempting to get MB data for $Computer."
                $MB_Info = gwmi win32_BaseBoard -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----MB_Info : $MB_Info"
            }else{
                    #Try to get MB data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $MB_Info = gwmi win32_BaseBoard -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----MB_Info : $MB_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $MB_Infos += $MB_Info
            write-verbose "----Added stored data to array for MB for $Computer"

        }#END_FOREACH#
        write-output $MB_Infos
    }#END_PROCESS#
}#END_FUNCTION#