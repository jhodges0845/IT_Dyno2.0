function get-CS{
    [cmdletbinding()]
    param(
        [string[]]$Computername,
        $Credential,
        [string[]]$Property
    )PROCESS{

        write-Verbose "--CS function started."
        $CSInfo = $Null
        $CSInfos = $Null
        $CSInfos = @()


        foreach($Computer in $Computername){
            write-Verbose "---Computer : $Computer"
            
           if($Computer -eq $env:Computername){
                    #Try to get Computer System data without credentials#
                write-verbose "----attempting to get computer System data for $Computer."
                $CSInfo = gwmi win32_ComputerSystem -ComputerName $Computer -ErrorAction Stop | select $Property
                write-verbose "----CSInfo : $CSInfo"
           }else{
                try{
                        #Try to get Computer System data with credentials#
                    write-verbose "----Trying to get data using Admin credentials"
                    $CSInfo = gwmi win32_ComputerSystem -ComputerName $Computer -Credential $Credentials -ErrorAction Stop | select $Property
                    write-verbose "----CSInfo : $CSInfo"
                }catch{
                        #Try to get Computer System data with different credentials#
                    write-verbose "----Trying to get data using different Admin credentials"
                    $CSInfo = gwmi win32_ComputerSystem -ComputerName $Computer -Credential (Get-Credential) -ErrorAction Stop | select $Property
                    write-verbose "---- CSInfo : $CSInfo"
                }#END_TRY/CATCH#
           }#END_IF/ELSE#

            write-verbose "----storing data into object for $Computer"
            $CSInfos += $CSInfo
            write-verbose "----Added stored data to array for computer system for $Computer"
        }#END_FOREACH#
        write-output $CSInfos
    }#END_PROCESS#
}#END_FUNCTION#