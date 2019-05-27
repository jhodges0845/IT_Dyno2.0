<# INFO
    creator: Jason Hodges
    email: jasonhodges0845@gmail.com
    date created: 5/26/2019

#>
<# NOTES
    - Newer version of IT_Dyno. This version is written cleaner and is more moduler than previous version.
    - Using Bootstrap 4, Jquery 3.4.1

#>

#Gets scripts current directory#
if($PSScriptRoot -ne $Nul){
    $Subpath = $PSScriptRoot
}elseif($MyInvocation.MyCommand.Definition -ne $Null){
    $Subpath = split-path $MyInvocation.MyCommand.Definition -Parent
}else{
    write-error "Script path not found."
}#END_IF/ELSEIF/ELSE#

#### IMPORTS ####
. "$Subpath\modules\console_control.ps1"

$SIpath = "$Subpath\modules\SystemInfo"
. "$SIpath\get-BIOS.ps1"
. "$SIpath\get-CS.ps1"
. "$Sipath\get-Graphics.ps1"
. "$SIpath\get-HDD.ps1"
. "$SIpath\get-MB.ps1"
. "$SIpath\get-NetAdapter.ps1"
. "$SIpath\get-NetConfig.ps1"
. "$SIpath\get-OS.ps1"
. "$SIpath\get-Processor.ps1"
. "$SIpath\get-RAM.ps1"


#### END_IMPORTS ####
#### FUNCTIONS ####

# Create GUI Interface #
function create-GUI{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $font = new-object System.Drawing.Font("Times New Roman",18,[System.Drawing.FontStyle]::Bold)
    $Global:form = New-Object Windows.Forms.Form
    $form.text = "IT Dyno"
    $form.font = $font
    $form.AutoSize = "$True"
    $form.TabIndex = 0
    $form.StartPosition = "CenterScreen"

    $form.Add_Shown({$form.Activate()})
    
    $lblScan = New-Object Windows.Forms.label
    $lblScan.text = "Enter a Computer Name or IP Address to Scan."
    $lblScan.location = New-Object Drawing.Point(25,50)
    $lblScan.Size = New-Object Drawing.Point(550,75)
    $form.controls.add($lblScan)
    
    $txtNode = New-Object Windows.Forms.Textbox
    $txtNode.Location = New-Object Drawing.Point(150,125)
    $txtNode.Size = New-Object Drawing.Point(250,30)
    $txtNode.TabIndex = 1
    $form.controls.add($txtNode)
    
    $btnScan = New-Object Windows.Forms.Button
    $btnScan.text = "Scan Computer"
    $btnScan.visible = $True
    $btnScan.Location = New-Object Drawing.Point(200,275)
    $btnScan.Size = New-Object Drawing.Point(150,75)
    $btnScan.TabIndex = 8
    $form.AcceptButton = $btnScan
    $form.Controls.add($btnScan)
    $btnScan.add_Click({
        $Node = $txtNode.text
        
        #diagonse computer#
        $Object = Dyno-Computer -computername $Node

        #Covert data to web page.#
        $WebPath = "$Subpath\index.html"
        convertTo-WebPage -InputObject $Object -Path $WebPath

        #invoke webpage to open#
        invoke-item $WebPath
        
        $Form.Close()
    })
    
    $form.ShowDialog()
}#END_FUNCTION#

function convertTo-WebPage{
    [cmdletbinding()]
    param(
        $InputObject,
        [string]$Path
    )PROCESS{
        $Name = $InputObject.name
        $Prognosis = "test prognosis"
        $NetConfig = $InputObject.NetConfig

        $Content = "
            <!DOCTYE html>
            <html>
            <head>
                <title>IT Dyno 2.0</title>
                <meta name='viewport' content='width=device-width, initial-scale=1'>
		        <script type='text/javascript' src='WebDev/jquery/jquery-3.4.1.min.js'></script>
		        <link rel='stylesheet' href='WebDev/bs4/css/bootstrap.min.css'>
		        <script type='text/javascript' src='WebDev/bs4/js/bootstrap.min.js'></script>
		        
            </head>
            <body class='text-center'>"
            #Add Entry from form.#
        $Content += "<div class='jumbotron'>
			            <h1> IT_Dyno Diagnostic for $Name</h1>
                    </div>"
            #Add Prognosis#
        $Content += "<div class='row'>
			            <div class='col-sm-12'>
				            <div class='card'>
					            <div class='card-heading bg-primary'>
						            <h3 class='card-title'>
							            Prognosis
						            </h3>
					            </div>
					            <div class='card-body'>
						            <b>$Prognosis</b>
					            </div>
				            </div>
			            </div>
		            </div>"

            #Add Network Information#
        $Content += "
                        <div class='row'>
			                <div class='col-sm-6'>
				                <div class='card'>
					                <div class='card-header bg-primary'>
						                <h4 class='card-title'>
							                Network Information
						                </h4>
					                </div>
					                <div class='card-body'>
                                        <h6>Network Configuration</h6>
						                <table class='table table-responsive table-dark table-striped'>
                                            <thead>
                                                <tr>
                                                    <th>IPAddress</td>
                                                    <th>Default Gateway</th>
                                                    <th>Subnet Mask</th>
                                                    <th>MAC Address</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                    "
        foreach($Config in $NetConfig){
            $Gateway = ""
            $IP = $Config.IPAddress
            $Gateway = $Config.DefaultIPGateway
            $Subnet = $Config.IPSubnet
            $MAC = $Config.MACAddress
            $Content += "
                            <tr>
                                <td>$IP</td>
                                <td>$Gateway</td>
                                <td>$Subnet</td>
                                <td>$MAC</td>
                            </tr>
                        "
        }#END_FOREACH#
        $Content += "
                                            </tbody>
                                        </table>
					                </div>
				                </div>
			                </div>
                    "
        #Add Status Information#
        $Content += "
                        <div class='col-sm-6'>
                            <div class='card'>
                                <div class='card-header bg-primary'>
                                    <h4>Status Check</h4>
                                </div>
                                <div class='card-body'>
                    "
        $Content += "
                                </div>
                            </div>
                        </div>
                    </div>
                    "

        #Add Hardware Information#
        $Content += "
                        <div class='row'>
                            <div class='col-sm-12'>
                                <div class='card'>
                                    <div class='card-header bg-primary'>
                                        <h4>Hardware Information</h4>
                                    </div>
                                    <div class='card-body'>
                    "
        $Content += "
                                    </div>
                                </div>
                            </div>
                        </div>
                    "


        $Content += "
                        
                    </body>
                    </html>"
        set-content $Path $Content -force   
    }#END_PROCESS#
}#END_FUNCTION#

function Dyno-Computer{
    [cmdletbinding()]
    param(
        [string]$Computername
    )PROCESS{
        #get system information#
        $BIOS = get-BIOS -ComputerName $Computename
        $NetConfig = get-NetConfig -Computername $Computername | ?{$_.IPAddress -ne $Null}
        
        #diagnose PC#


        #create object#
        $Properties = @{
            Name = $Computername
            BIOS = $BIOS
            NetConfig = $NetConfig
        }#END_HASHTABLE#
        $Object = new-Object -TypeName PSObject -Property $properties
        write-output $Object
    }#END_PROCESS#
}#END_FUNCTION#

#### END_FUNCTIONS ####
#### MAIN #####

#Hides Poweshell Console# 
 Hide-Console 
 create-GUI



#### END_MAIN ####
