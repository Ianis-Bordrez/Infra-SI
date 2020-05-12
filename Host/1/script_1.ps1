function Get-HostName {
    # This function get the hostname.
    hostname
}
function Get-MainIP {
    # This function get the public IP.
    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
}
function Get-OSName {
    # This function get the OS Name
    (Get-WmiObject Win32_OperatingSystem).Caption
# (Get-ComputerInfo).WindowsProductName
}
function Get-OSVersion {
    # This function get the OS Version
    (Get-ComputerInfo).windowsversion
}
function Get-UpTime2 {
    (Get-WmiObject win32_operatingsystem).lastbootuptime
}
function Get-Uptime {
    # This function get the uptime
   $os = Get-WmiObject win32_operatingsystem
   $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
   $Display = "" + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes" 
   Write-Output $Display
}
function Get-FreeRam {
    # This function get the free RAM
    [math]::Round((Get-WmiObject win32_operatingsystem).FreePhysicalMemory / 1000000, 2)
}
function Get-UsedRam {
    # This function get the used RAM
    $os = Get-WmiObject Win32_OperatingSystem
    $usedRAM = [math]::Round(($os.TotalVisibleMemorySize-$os.FreePhysicalMemory) / 1000000, 2)
    Write-Output $usedRAM
}
function Get-VolumeDisk {
    # This function get all volume disk and list their letter, name, size and free space.
    $os =  Get-WmiObject Win32_logicaldisk
    foreach($i in $os){
        $letter = $i.DeviceID
        $name = $i.VolumeName
        $size = [math]::Round($i.Size/1000000000,2)
        $freeSpace = [math]::Round($i.FreeSpace/1000000000,2)
        Write-Output "Disk $letter, name : $name, size : $size Gb, freespace : $freespace Gb"
    }
}
function Get-Users {
    # This function get all user name.
    (Get-LocalUser).Name
}

function Get-PingTimestamp {
    # This function get the average response time to google
    $pingServer = Test-Connection -count 5 8.8.8.8
    $avg = ($pingServer | Measure-Object ResponseTime -average -maximum)
    $calc = [math]::Round($avg.average, 2)
    Write-Output "Average response time to google : $calc ms"
}

function Measure-DownloadSpeed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a URL to download.")]
        [string] $Url
        ,
        [Parameter(Mandatory = $true, HelpMessage = "Please enter a target path to download to.")]
        [string] $Path
    )
}

"name : $(Get-HostName)"
"Main IP : $(Get-MainIP)"
"OS : $(Get-OSName), Version $(Get-OSVersion)"
"Uptime : $(Get-Uptime)"
"Free RAM : $(Get-FreeRam) Gb"
"Used RAM : $(Get-UsedRam) Gb"
$(Get-VolumeDisk)
"Users : $(Get-Users)"
$(Get-PingTimestamp)
