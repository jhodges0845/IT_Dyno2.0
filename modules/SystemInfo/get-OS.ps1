function get-OS{
    [cmdletbinding()]
    param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{

        write-Verbose "--OS function started."
        $OSInfo = $Null
        $OSInfos = $Null
        $OSInfos = @()

        write-verbose "---Properties : $Property"

        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"
            
           if($Computer -eq $env:Computername){
                    #Try to get Computer System data without credentials#
                write-verbose "----attempting to get computer System data for $Computer."
                $OSInfo = gwmi win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----OSInfo : $OSInfo"
           }else{
                    #Try to get Computer System data with credentials#
                write-verbose "----Trying to get data using Admin credentials"
                $OSInfo = gwmi win32_OperatingSystem -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                write-verbose "----OSInfo : $OSInfo"
           }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $OSInfos += $OSInfo
            write-verbose "----Added stored data to array for computer system for $Computer"
        }#END_FOREACH#
        write-output $OSInfos
    }#END_PROCESS#
}#END_FUNCTION#