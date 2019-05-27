function get-Graphics{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--Graphics function started."
        $Graphics_Info = $Null
        $Graphics_Info = $Null
        $Graphics_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get Graphics data without credentials#
                write-verbose "----attempting to get Graphics data for $Computer."
                $Graphics_Info = gwmi Win32_VideoController -ComputerName $Computer -ErrorAction Stop |  select $Property
                write-verbose "----Graphics_Info : $Graphics_Info"
            }else{
                    #Try to get Graphics data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $Graphics_Info = gwmi win32_VideoController -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----Graphics_Info : $Graphics_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $Graphics_Infos += $Graphics_Info
            write-verbose "----Added stored data to array for Graphics for $Computer"

        }#END_FOREACH#
        write-output $Graphics_Infos
    }#END_PROCESS#
}#END_FUNCTION#