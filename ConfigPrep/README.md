# GOAL
To extract interesting information PE files - Headers and Sections (.RELOC) which can be used for creating a host wide Exploit Protection Config
- Sample - https://demo.wd.microsoft.com/Content/ProcessMitigation.xml?
- APPLY Config Set-ProcessMitigation -PolicyFilePath ProcessMitigation.xml

# HOW
- Extract all PE Headers and Sections using TrailOfBits - winchecksec 
- Unzip to C:\CPP\winchecksec
   
# Dependency
- winchecksec from here
    - Git : https://github.com/trailofbits/winchecksec
    - ZIP : https://github.com/trailofbits/winchecksec/releases/download/1.1.1/winchecksec-1.1.1.zip

# Interesting observations
- Tests ran on my Lenovo laptop, so there should be a few interesting driver results
- Output from Get-AuthenticodeSignature and WinCheckSec\authenticode value mismatch
- All files with CFG True has NX and ASLR true (EXPECTED)
  - None of them are using DotNet framework ()
  - Significant number of them have forceIntegrity FALSE
- `mmc.exe` and `regsvr32.exe`
  - TRUE - ASLR, CFG, DynamicBase,Isolation, NX, SEH
  - FALSE - ForceIntegrity, highEntropyVA, RFG, SafeSEH (Unexpected)

# Non MSFT Signed binary in System32

```
CertIssuer	CertIsOsBinary	CertSigType	CertStatus	CertStatusMsg	aslr	authenticode	cfg	dotNET	dynamicBase	forceIntegrity	gs	highEntropyVA	isolation	nx	path	rfg	safeSEH	seh
CN=DigiCert Assured ID Code Signing CA-1, OU=www.digicert.com, O=DigiCert Inc, C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\DbxSvc.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\dns-sd.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\java.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\javaw.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\javaws.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	FALSE	C:\Windows\System32\TPHDEXLG64.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	FALSE	TRUE	FALSE	FALSE	FALSE	FALSE	FALSE	FALSE	TRUE	FALSE	C:\Windows\System32\TpShCTL.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	FALSE	TRUE	FALSE	FALSE	FALSE	FALSE	FALSE	FALSE	TRUE	FALSE	C:\Windows\System32\TpShEvUI.exe	FALSE	FALSE	TRUE
CN=VeriSign Class 3 Code Signing 2010 CA, OU=Terms of use at https://www.verisign.com/rpa (c)10, OU=VeriSign Trust Network, O="VeriSign, Inc.", C=US	FALSE	Authenticode	Valid	Signature verified.	FALSE	TRUE	FALSE	FALSE	FALSE	FALSE	FALSE	FALSE	TRUE	FALSE	C:\Windows\System32\TpShocks.exe	FALSE	FALSE	TRUE
CN=DigiCert EV Code Signing CA (SHA2), OU=www.digicert.com, O=DigiCert Inc, C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	FALSE	FALSE	TRUE	TRUE	C:\Windows\System32\Macromed\Flash\FlashUtil64_28_0_0_161_pepper.exe	FALSE	FALSE	TRUE
CN=DigiCert EV Code Signing CA (SHA2), OU=www.digicert.com, O=DigiCert Inc, C=US	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	TRUE	TRUE	TRUE	TRUE	C:\Windows\System32\Macromed\Flash\FlashUtil64_32_0_0_363_Plugin.exe	FALSE	FALSE	TRUE
CN=COMODO RSA Extended Validation Code Signing CA, O=COMODO CA Limited, L=Salford, S=Greater Manchester, C=GB	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	TRUE	TRUE	TRUE	TRUE	C:\Windows\System32\Npcap\NpcapHelper.exe	FALSE	FALSE	TRUE
CN=COMODO RSA Extended Validation Code Signing CA, O=COMODO CA Limited, L=Salford, S=Greater Manchester, C=GB	FALSE	Authenticode	Valid	Signature verified.	TRUE	TRUE	FALSE	FALSE	TRUE	FALSE	TRUE	TRUE	TRUE	TRUE	C:\Windows\System32\Npcap\WlanHelper.exe	FALSE	FALSE	TRUE

```
# Powershell
```
CertIssuer	CertIsOsBinary	CertSigType	CertStatus	CertStatusMsg	aslr	authenticode	cfg	dotNET	dynamicBase	forceIntegrity	gs	highEntropyVA	isolation	nx	path	rfg	safeSEH	seh
CN=Microsoft Windows Production PCA 2011, O=Microsoft Corporation, L=Redmond, S=Washington, C=US	TRUE	Catalog	Valid	Signature verified.	TRUE	FALSE	TRUE	FALSE	TRUE	FALSE	TRUE	TRUE	TRUE	TRUE	C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe	FALSE	FALSE	TRUE
CN=Microsoft Windows Production PCA 2011, O=Microsoft Corporation, L=Redmond, S=Washington, C=US	TRUE	Catalog	Valid	Signature verified.	TRUE	FALSE	FALSE	TRUE	TRUE	FALSE	FALSE	TRUE	TRUE	TRUE	C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe	FALSE	FALSE	FALSE

```