function get-NetAdapter{
    [cmdletbinding()]
    Param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{
        write-Verbose "--NetAdapter function started."
        $NetAdapter_Info = $Null
        $NetAdapter_Infos = $Null
        $NetAdapter_Infos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"

            if($Computer -eq $env:Computername){
                    #Try to get NetworkAdapter data without credentials#
                write-verbose "----attempting to get NetworkAdapter data for $Computer."
                $NetAdapter_Info = gwmi win32_NetworkAdapter -ComputerName $Computer -ErrorAction Stop | ?{$_.PhysicalAdapter -eq "True"} | select $Property
                write-verbose "----NetAdapter_Info : $NetAdapter_Info"
           }else{
                    #Try to get NetworkAdapter data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $NetAdapter_Info = gwmi win32_NetworkAdapter -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | ?{$_.PhysicalAdapter -eq "True"} | select $Property
                write-verbose "----NetAdapter_Info : $NetAdapter_Info"
           }#END_IF/ELSE#

           write-verbose "----storing data into object for $Computer"
            $NetAdapter_Infos += $NetAdapter_Info
            write-verbose "----Added stored data to array for NetworkAdapter for $Computer"
        }#END_FOREACH#
        write-output $NetAdapter_Infos
    }#END_PROCESS#
}#END_FUNCTION#