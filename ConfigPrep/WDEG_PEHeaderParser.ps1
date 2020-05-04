# GOAL
# To extract interesting information PE files - Headers and Sections (.RELOC) which can be used for creating a host wide Exploit Protection Config
# Sample - https://demo.wd.microsoft.com/Content/ProcessMitigation.xml?
# APPLY Config Set-ProcessMitigation -PolicyFilePath ProcessMitigation.xml

# HOW
# Extract all PE Headers and Sections using TrailOfBits - winchecksec 

# Install winchecksec from here
# Git : https://github.com/trailofbits/winchecksec
# ZIP : https://github.com/trailofbits/winchecksec/releases/download/1.1.1/winchecksec-1.1.1.zip
# Unzip to C:\CPP\winchecksec

# Get Full-Path of all EXE and DLLs
$progfiles = gci -Filter *.exe $env=ProgramFiles -Recurse | select -ExpandProperty FullName
$progfiles86 = gci -Filter *.exe ${env=ProgramFiles(x86)} -Recurse | select -ExpandProperty FullName
$system32EXE= gci -Filter *.exe C=\Windows\System32 -Recurse | select -ExpandProperty FullName

$obj = $system32EXE | foreach {
    $obj = C:\CPP\winchecksec\winchecksec.exe -j $_ | ConvertFrom-Json    
    $authcode = Get-AuthenticodeSignature $_ 
    $output = [ordered]@{
        CertIssuer = $authcode.SignerCertificate.Issuer
        CertIsOsBinary = $authcode.IsOSBinary
        CertSigType = $authcode.SignatureType
        CertStatus = $authcode.Status
        CertStatusMsg = $authcode.StatusMessage
        aslr           = $obj.aslr
        authenticode   = $obj.authenticode   
        cfg            = $obj.cfg            
        dotNET         = $obj.dotNET         
        dynamicBase    = $obj.dynamicBase    
        forceIntegrity = $obj.forceIntegrity 
        gs             = $obj.gs             
        highEntropyVA  = $obj.highEntropyVA  
        isolation      = $obj.isolation      
        nx             = $obj.nx             
        path           = $obj.path           
        rfg            = $obj.rfg            
        safeSEH        = $obj.safeSEH        
        seh            = $obj.seh            
    }
    $res = New-Object PsObject -Property $output
    $res    
}

$obj | Export-Csv -NoTypeInformation WDEG_ConfigPrep_System32.csv
