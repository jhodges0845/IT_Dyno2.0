function get-HDD{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--HDD function started."
        $HDD_Info = $Null
        $HDD_Info = $Null
        $HDD_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get HDD data without credentials#
                write-verbose "----attempting to get HDD data for $Computer."
                $HDD_Info = gwmi win32_LogicalDisk -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----HDD_Info : $HDD_Info"
            }else{
                    #Try to get HDD data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $HDD_Info = gwmi win32_LogicalDisk -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----HDD_Info : $HDD_Info"
            }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $HDD_Infos += $HDD_Info
            write-verbose "----Added stored data to array for HDD for $Computer"

        }#END_FOREACH#
        write-output $HDD_Infos
    }#END_PROCESS#
}#END_FUNCTION#