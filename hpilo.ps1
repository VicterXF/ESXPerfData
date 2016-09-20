
function Get-ILOxml
{
param($ilo_ip, [switch]$RAW)
   [XML]$ILOxml = (new-object System.Net.WebClient).DownloadString("http://$($iLO_IP)/xmldata?item=ALL")
    if (!$ILOxml) {return $FALSE}
    
    if ($RAW) {return $ILOxml}
    
    $ilo = "" | select ilo_ver,ilo_fw,serial,model,SBSN,ilo_hw,ilo_SSO,BBLK
    $ilo.ilo_ver = $ILOxml.RIMP.MP.PN
    $ilo.ilo_fw = $ILOxml.RIMP.MP.FWRI
       $ilo.serial = $ILOxml.RIMP.MP.SN
    $ilo.ilo_SSO = $ILOxml.RIMP.MP.SSO
    $ilo.BBLK = $ILOxml.RIMP.MP.BBLK
    $ilo.model = $ILOxml.RIMP.HSI.SPN
    $ilo.SBSN = $ILOxml.RIMP.HSI.SBSN
        
       switch ($ILOxml.RIMP.MP.PN) {
              "Integrated Lights-Out 3 (iLO 3)" { $ilo.ilo_hw = "iLO 3" }
              "Integrated Lights-Out 2 (iLO 2)" { $ilo.ilo_hw = "iLO 2" }
              "Integrated Lights-Out (iLO)" { $ilo.ilo_hw = "iLO 1" }
              "BladeSystem c7000 Onboard Administrator" { $ilo.ilo_hw = "c7000 OA" }
              "BladeSystem c3000 Onboard Administrator" { $ilo.ilo_hw = "c3000 OA" }
              default {$ilo.ilo_hw = $ILOxml.RIMP.MP.PN}
        }
    
    return $ilo
} 

$iloinfo= Get-ILOxml("10.35.240.171")
write-host "$iloinfo.ilo_hw  $ilo.ilo_ver $ilo.serial $ilo.model"