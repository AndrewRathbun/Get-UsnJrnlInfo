<#
	.SYNOPSIS
		Get-UsnJrnlInfo
	
	.DESCRIPTION
		Get-UsnJrnlInfo.ps1 is a simple PowerShell script utilized to parse $UsnJrnl information from extracted $Max file.
		
		[root]\$Extend\$UsnJrnl:$Max
	
	.PARAMETER PathToMaxFile
		Specifies the path to the extracted $Max file.
	
	.EXAMPLE
		PS C:\> .\Get-UsnJrnlInfo.ps1 -PathToMaxFile "G:\C\$Extend\`$Max"
	
	.NOTES
		Author - Martin Willing
	
	.LINK
		https://evild3ad.com/
		
		.UPDATES
		All credit to original author. Originally GPT GPL-3.0 license. The only changes made to this script involve minor spacing changes, updated script parameters, and signing the script.
#>
param
(
	[Parameter(Mandatory = $true,
			   Position = 1,
			   HelpMessage = 'Please specify the full file path to an extracted copy of a $Max file')]
	[string]$PathToMaxFile
)

if (!($PathToMaxFile))
{
    Write-Output "You have to specify the path to the extracted `$Max file:"
    Write-Output ".\Get-UsnJrnlInfo.ps1 [[-PathToMaxFile] <string>]"
    Exit
}

Function Get-UsnJrnlInfo
{
    # Check if File exists
    if (Test-Path "$PathToMaxFile")
    {
        # Check if it is a File
        if ((Get-Item $PathToMaxFile) -is [System.IO.FileInfo])
        {
            # Check for fixed size of 32 Bytes (Logical Size)
            $Bytes = (Get-Item -Path "$PathToMaxFile").Length
            if ($Bytes -eq "32")
            {
                # Reading The Bytes Of A File Into A Byte Array
                $ByteArray = [System.IO.File]::ReadAllBytes("$PathToMaxFile")

                # Convert Byte Array To Hex
                $ByteContentOfMax = [System.BitConverter]::ToString($ByteArray).Replace("-", " ")
                Write-Output "[Info] Content: $ByteContentOfMax"

                Function Get-FileSize() {
                Param ([long]$Length)
                If ($Length -gt 1TB) {[string]::Format("{0:0.00} TB", $Length / 1TB)}
                ElseIf ($Length -gt 1GB) {[string]::Format("{0:0.00} GB", $Length / 1GB)}
                ElseIf ($Length -gt 1MB) {[string]::Format("{0:0.00} MB", $Length / 1MB)}
                ElseIf ($Length -gt 1KB) {[string]::Format("{0:0.00} KB", $Length / 1KB)}
                ElseIf ($Length -gt 0) {[string]::Format("{0:0.00} Bytes", $Length)}
                Else {""}
                }

                # MaximumSize (Converts Byte Array Into A 64-Bit Unsigned Integer)
                $ByteSize = [Bitconverter]::ToUInt64($ByteArray[0 .. 8], 0)
                $MaximumSize = Get-FileSize($ByteSize)
                Write-Output "[Info] Maximum USN Size: $MaximumSize ( $ByteSize Bytes )"

                # Allocation Delta (Converts Byte Array Into A 64-Bit Unsigned Integer)
                $ByteSize = [Bitconverter]::ToUInt64($ByteArray[8 .. 16], 0)
                $AllocationDelta = Get-FileSize($ByteSize)
                Write-Output "[Info] Allocation Size: $AllocationDelta ( $ByteSize Bytes )"

                # USN ID (Converts Byte Array Into A 64-Bit Unsigned Integer)
                $UsnIdDec = [Bitconverter]::ToUInt64($ByteArray[16 .. 24], 0)
                $UsnIdHex = "0x{0:x}" -f 132634203089494385
                Write-Output "[Info] USN ID (Decimal): $UsnIdDec"
                Write-Output "[Info] USN ID (Hex): $UsnIdHex"

                # Lowest Valid USN (Converts Byte Array Into 64-Bit Integer)
                $LowestUsn = [Bitconverter]::ToInt64($ByteArray[24 .. 32], 0)
                Write-Output "[Info] Lowest Valid USN: $LowestUsn"
            }
            else
            {
                Write-Output "[Error] The size of the provided file does not match the fixed size of the `$Max file."
            }
        }
    }
    else
    {
        Write-Output "[Error] The provided file does not exist."
    }
}

Get-UsnJrnlInfo

# SIG # Begin signature block
# MIIviwYJKoZIhvcNAQcCoIIvfDCCL3gCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDcEsfISVkg7d1D
# irgrHXZkmMWWioDkiEkSLLXD0Dib2aCCKJAwggQyMIIDGqADAgECAgEBMA0GCSqG
# SIb3DQEBBQUAMHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNo
# ZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1p
# dGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXMwHhcNMDQwMTAx
# MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwS
# R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFD
# b21vZG8gQ0EgTGltaXRlZDEhMB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZp
# Y2VzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvkCd9G7h6naHHE1F
# RI6+RsiDBp3BKv4YH47kAvrzq11QihYxC5oG0MVwIs1JLVRjzLZuaEYLU+rLTCTA
# vHJO6vEVrvRUmhIKw3qyM2Di2olV8yJY897cz++DhqKMlE+faPKYkEaEJ8d2v+PM
# NSyLXgdkZYLASLCokflhn3YgUKiRx2a163hiA1bwihoT6jGjHqCZ/Tj29icyWG8H
# 9Wu4+xQrr7eqzNZjX3OM2gWZqDioyxd4NlGs6Z70eDqNzw/ZQuKYDKsvnw4B3u+f
# mUnxLd+sdE0bmLVHxeUp0fmQGMdinL6DxyZ7Poolx8DdneY1aBAgnY/Y3tLDhJwN
# XugvyQIDAQABo4HAMIG9MB0GA1UdDgQWBBSgEQojPpbxB+zirynvgqV/0DCktDAO
# BgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zB7BgNVHR8EdDByMDigNqA0
# hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9BQUFDZXJ0aWZpY2F0ZVNlcnZpY2Vz
# LmNybDA2oDSgMoYwaHR0cDovL2NybC5jb21vZG8ubmV0L0FBQUNlcnRpZmljYXRl
# U2VydmljZXMuY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQAIVvwC8Jvo/6T61nvGRIDO
# T8TF9gBYzKa2vBRJaAR26ObuXewCD2DWjVAYTyZOAePmsKXuv7x0VEG//fwSuMdP
# WvSJYAV/YLcFSvP28cK/xLl0hrYtfWvM0vNG3S/G4GrDwzQDLH2W3VrCDqcKmcEF
# i6sML/NcOs9sN1UJh95TQGxY7/y2q2VuBPYb3DzgWhXGntnxWUgwIWUDbOzpIXPs
# mwOh4DetoBUYj/q6As6nLKkQEyzU5QgmqyKXYPiQXnTUoppTvfKpaOCibsLXbLGj
# D56/62jnVvKu8uMrODoJgbVrhde+Le0/GreyY+L1YiyC1GoAQVDxOYOflek2lphu
# MIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0BAQwFADB7
# MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
# VQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UE
# AwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAwMFoXDTI4
# MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28gTGlt
# aXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5nIFJvb3Qg
# UjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIEJHQu/xYj
# ApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7fbu2ir29
# BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGrYbNzszwL
# DO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTHqi0Eq8Nq
# 6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv64IplXCN
# /7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2JmRCxrds+
# LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0POM1nqFOI
# +rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXybGWfv1Vb
# HJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyheBe6QTHrn
# xvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXycuu7D1fkK
# dvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7idFT/+IAx1
# yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQYMBaAFKAR
# CiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJwIDaRXBeF
# 5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUEDDAKBggr
# BgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1UdHwQ8MDow
# OKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2Vy
# dmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3SamES4aUa1
# qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+BtlcY2fU
# QBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8ZsBRNraJ
# AlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx2jLsFeSm
# TD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyoXZ3JHFuu
# 2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p1FiAhORF
# e1rYMIIFgzCCA2ugAwIBAgIORea7A4Mzw4VlSOb/RVEwDQYJKoZIhvcNAQEMBQAw
# TDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjYxEzARBgNVBAoTCkds
# b2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wHhcNMTQxMjEwMDAwMDAwWhcN
# MzQxMjEwMDAwMDAwWjBMMSAwHgYDVQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBS
# NjETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMKR2xvYmFsU2lnbjCCAiIw
# DQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJUH6HPKZvnsFMp7PPcNCPG0RQss
# grRIxutbPK6DuEGSMxSkb3/pKszGsIhrxbaJ0cay/xTOURQh7ErdG1rG1ofuTToV
# Bu1kZguSgMpE3nOUTvOniX9PeGMIyBJQbUJmL025eShNUhqKGoC3GYEOfsSKvGRM
# IRxDaNc9PIrFsmbVkJq3MQbFvuJtMgamHvm566qjuL++gmNQ0PAYid/kD3n16qIf
# KtJwLnvnvJO7bVPiSHyMEAc4/2ayd2F+4OqMPKq0pPbzlUoSB239jLKJz9CgYXfI
# WHSw1CM69106yqLbnQneXUQtkPGBzVeS+n68UARjNN9rkxi+azayOeSsJDa38O+2
# HBNXk7besvjihbdzorg1qkXy4J02oW9UivFyVm4uiMVRQkQVlO6jxTiWm05OWgtH
# 8wY2SXcwvHE35absIQh1/OZhFj931dmRl4QKbNQCTXTAFO39OfuD8l4UoQSwC+n+
# 7o/hbguyCLNhZglqsQY6ZZZZwPA1/cnaKI0aEYdwgQqomnUdnjqGBQCe24DWJfnc
# BZ4nWUx2OVvq+aWh2IMP0f/fMBH5hc8zSPXKbWQULHpYT9NLCEnFlWQaYw55PfWz
# jMpYrZxCRXluDocZXFSxZba/jJvcE+kNb7gu3GduyYsRtYQUigAZcIN5kZeR1Bon
# vzceMgfYFGM8KEyvAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
# BTADAQH/MB0GA1UdDgQWBBSubAWjkxPioufi1xzWx/B/yGdToDAfBgNVHSMEGDAW
# gBSubAWjkxPioufi1xzWx/B/yGdToDANBgkqhkiG9w0BAQwFAAOCAgEAgyXt6NH9
# lVLNnsAEoJFp5lzQhN7craJP6Ed41mWYqVuoPId8AorRbrcWc+ZfwFSY1XS+wc3i
# EZGtIxg93eFyRJa0lV7Ae46ZeBZDE1ZXs6KzO7V33EByrKPrmzU+sQghoefEQzd5
# Mr6155wsTLxDKZmOMNOsIeDjHfrYBzN2VAAiKrlNIC5waNrlU/yDXNOd8v9EDERm
# 8tLjvUYAGm0CuiVdjaExUd1URhxN25mW7xocBFymFe944Hn+Xds+qkxV/ZoVqW/h
# pvvfcDDpw+5CRu3CkwWJ+n1jez/QcYF8AOiYrg54NMMl+68KnyBr3TsTjxKM4kEa
# SHpzoHdpx7Zcf4LIHv5YGygrqGytXm3ABdJ7t+uA/iU3/gKbaKxCXcPu9czc8FB1
# 0jZpnOZ7BN9uBmm23goJSFmH63sUYHpkqmlD75HHTOwY3WzvUy2MmeFe8nI+z1TI
# vWfspA9MRf/TuTAjB0yPEL+GltmZWrSZVxykzLsViVO6LAUP5MSeGbEYNNVMnbrt
# 9x+vJJUEeKgDu+6B5dpffItKoZB0JaezPkvILFa9x8jvOOJckvB595yEunQtYQEg
# fn7R8k8HWV+LLUNS60YMlOH1Zkd5d9VUWx+tJDfLRVpOoERIyNiwmcUVhAn21klJ
# wGW45hpxbqCo8YLoRT5s1gLXCmeDBVrJpBAwggYaMIIEAqADAgECAhBiHW0MUgGe
# O5B5FSCJIRwKMA0GCSqGSIb3DQEBDAUAMFYxCzAJBgNVBAYTAkdCMRgwFgYDVQQK
# Ew9TZWN0aWdvIExpbWl0ZWQxLTArBgNVBAMTJFNlY3RpZ28gUHVibGljIENvZGUg
# U2lnbmluZyBSb290IFI0NjAeFw0yMTAzMjIwMDAwMDBaFw0zNjAzMjEyMzU5NTla
# MFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzApBgNV
# BAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYwggGiMA0GCSqG
# SIb3DQEBAQUAA4IBjwAwggGKAoIBgQCbK51T+jU/jmAGQ2rAz/V/9shTUxjIztNs
# fvxYB5UXeWUzCxEeAEZGbEN4QMgCsJLZUKhWThj/yPqy0iSZhXkZ6Pg2A2NVDgFi
# gOMYzB2OKhdqfWGVoYW3haT29PSTahYkwmMv0b/83nbeECbiMXhSOtbam+/36F09
# fy1tsB8je/RV0mIk8XL/tfCK6cPuYHE215wzrK0h1SWHTxPbPuYkRdkP05ZwmRmT
# nAO5/arnY83jeNzhP06ShdnRqtZlV59+8yv+KIhE5ILMqgOZYAENHNX9SJDm+qxp
# 4VqpB3MV/h53yl41aHU5pledi9lCBbH9JeIkNFICiVHNkRmq4TpxtwfvjsUedyz8
# rNyfQJy/aOs5b4s+ac7IH60B+Ja7TVM+EKv1WuTGwcLmoU3FpOFMbmPj8pz44MPZ
# 1f9+YEQIQty/NQd/2yGgW+ufflcZ/ZE9o1M7a5Jnqf2i2/uMSWymR8r2oQBMdlyh
# 2n5HirY4jKnFH/9gRvd+QOfdRrJZb1sCAwEAAaOCAWQwggFgMB8GA1UdIwQYMBaA
# FDLrkpr/NZZILyhAQnAgNpFcF4XmMB0GA1UdDgQWBBQPKssghyi47G9IritUpimq
# F6TNDDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADATBgNVHSUE
# DDAKBggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEsGA1Ud
# HwREMEIwQKA+oDyGOmh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGlnb1B1Ymxp
# Y0NvZGVTaWduaW5nUm9vdFI0Ni5jcmwwewYIKwYBBQUHAQEEbzBtMEYGCCsGAQUF
# BzAChjpodHRwOi8vY3J0LnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2ln
# bmluZ1Jvb3RSNDYucDdjMCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdv
# LmNvbTANBgkqhkiG9w0BAQwFAAOCAgEABv+C4XdjNm57oRUgmxP/BP6YdURhw1aV
# cdGRP4Wh60BAscjW4HL9hcpkOTz5jUug2oeunbYAowbFC2AKK+cMcXIBD0ZdOaWT
# syNyBBsMLHqafvIhrCymlaS98+QpoBCyKppP0OcxYEdU0hpsaqBBIZOtBajjcw5+
# w/KeFvPYfLF/ldYpmlG+vd0xqlqd099iChnyIMvY5HexjO2AmtsbpVn0OhNcWbWD
# RF/3sBp6fWXhz7DcML4iTAWS+MVXeNLj1lJziVKEoroGs9Mlizg0bUMbOalOhOfC
# ipnx8CaLZeVme5yELg09Jlo8BMe80jO37PU8ejfkP9/uPak7VLwELKxAMcJszkye
# iaerlphwoKx1uHRzNyE6bxuSKcutisqmKL5OTunAvtONEoteSiabkPVSZ2z76mKn
# zAfZxCl/3dq3dUNw4rg3sTCggkHSRqTqlLMS7gjrhTqBmzu1L90Y1KWN/Y5JKdGv
# spbOrTfOXyXvmPL6E52z1NZJ6ctuMFBQZH3pwWvqURR8AgQdULUvrxjUYbHHj95E
# jza63zdrEcxWLDX6xWls/GDnVNueKjWUH3fTv1Y8Wdho698YADR7TNx8X8z2Bev6
# SivBBOHY+uqiirZtg0y9ShQoPzmCcn63Syatatvx157YK9hlcPmVoa1oDE5/L9Uo
# 2bC5a4CH2RwwggZZMIIEQaADAgECAg0B7BySQN79LkBdfEd0MA0GCSqGSIb3DQEB
# DAUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9vdCBDQSAtIFI2MRMwEQYDVQQK
# EwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTE4MDYyMDAwMDAw
# MFoXDTM0MTIxMDAwMDAwMFowWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
# bFNpZ24gbnYtc2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENB
# IC0gU0hBMzg0IC0gRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDw
# AuIwI/rgG+GadLOvdYNfqUdSx2E6Y3w5I3ltdPwx5HQSGZb6zidiW64HiifuV6PE
# Ne2zNMeswwzrgGZt0ShKwSy7uXDycq6M95laXXauv0SofEEkjo+6xU//NkGrpy39
# eE5DiP6TGRfZ7jHPvIo7bmrEiPDul/bc8xigS5kcDoenJuGIyaDlmeKe9JxMP11b
# 7Lbv0mXPRQtUPbFUUweLmW64VJmKqDGSO/J6ffwOWN+BauGwbB5lgirUIceU/kKW
# O/ELsX9/RpgOhz16ZevRVqkuvftYPbWF+lOZTVt07XJLog2CNxkM0KvqWsHvD9WZ
# uT/0TzXxnA/TNxNS2SU07Zbv+GfqCL6PSXr/kLHU9ykV1/kNXdaHQx50xHAotIB7
# vSqbu4ThDqxvDbm19m1W/oodCT4kDmcmx/yyDaCUsLKUzHvmZ/6mWLLU2EESwVX9
# bpHFu7FMCEue1EIGbxsY1TbqZK7O/fUF5uJm0A4FIayxEQYjGeT7BTRE6giunUln
# EYuC5a1ahqdm/TMDAd6ZJflxbumcXQJMYDzPAo8B/XLukvGnEt5CEk3sqSbldwKs
# DlcMCdFhniaI/MiyTdtk8EWfusE/VKPYdgKVbGqNyiJc9gwE4yn6S7Ac0zd0hNkd
# Zqs0c48efXxeltY9GbCX6oxQkW2vV4Z+EDcdaxoU3wIDAQABo4IBKTCCASUwDgYD
# VR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFOoWxmnn
# 48tXRTkzpPBAvtDDvWWWMB8GA1UdIwQYMBaAFK5sBaOTE+Ki5+LXHNbH8H/IZ1Og
# MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2Jh
# bHNpZ24uY29tL3Jvb3RyNjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLmds
# b2JhbHNpZ24uY29tL3Jvb3QtcjYuY3JsMEcGA1UdIARAMD4wPAYEVR0gADA0MDIG
# CCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5
# LzANBgkqhkiG9w0BAQwFAAOCAgEAf+KI2VdnK0JfgacJC7rEuygYVtZMv9sbB3DG
# +wsJrQA6YDMfOcYWaxlASSUIHuSb99akDY8elvKGohfeQb9P4byrze7AI4zGhf5L
# FST5GETsH8KkrNCyz+zCVmUdvX/23oLIt59h07VGSJiXAmd6FpVK22LG0LMCzDRI
# RVXd7OlKn14U7XIQcXZw0g+W8+o3V5SRGK/cjZk4GVjCqaF+om4VJuq0+X8q5+dI
# ZGkv0pqhcvb3JEt0Wn1yhjWzAlcfi5z8u6xM3vreU0yD/RKxtklVT3WdrG9KyC5q
# ucqIwxIwTrIIc59eodaZzul9S5YszBZrGM3kWTeGCSziRdayzW6CdaXajR63Wy+I
# Lj198fKRMAWcznt8oMWsr1EG8BHHHTDFUVZg6HyVPSLj1QokUyeXgPpIiScseeI8
# 5Zse46qEgok+wEr1If5iEO0dMPz2zOpIJ3yLdUJ/a8vzpWuVHwRYNAqJ7YJQ5NF7
# qMnmvkiqK1XZjbclIA4bUaDUY6qD6mxyYUrJ+kPExlfFnbY8sIuwuRwx773vFNgU
# QGwgHcIt6AvGjW2MtnHtUiH+PvafnzkarqzSL3ogsfSsqh3iLRSd+pZqHcY8yvPZ
# HL9TTaRHWXyVxENB+SXiLBB+gfkNlKd98rUJ9dhgckBQlSDUQ0S++qCV5yBZtnjG
# pGqqIpswggZoMIIEUKADAgECAhABSJA9woq8p6EZTQwcV7gpMA0GCSqGSIb3DQEB
# CwUAMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEw
# LwYDVQQDEyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIFNIQTM4NCAtIEc0
# MB4XDTIyMDQwNjA3NDE1OFoXDTMzMDUwODA3NDE1OFowYzELMAkGA1UEBhMCQkUx
# GTAXBgNVBAoMEEdsb2JhbFNpZ24gbnYtc2ExOTA3BgNVBAMMMEdsb2JhbHNpZ24g
# VFNBIGZvciBNUyBBdXRoZW50aWNvZGUgQWR2YW5jZWQgLSBHNDCCAaIwDQYJKoZI
# hvcNAQEBBQADggGPADCCAYoCggGBAMLJ3AO2G1D6Kg3onKQh2yinHfWAtRJ0I/5e
# L8MaXZayIBkZUF92IyY1xiHslO+1ojrFkIGbIe8LJ6TjF2Q72pPUVi8811j5bazA
# L5B4I0nA+MGPcBPUa98miFp2e0j34aSm7wsa8yVUD4CeIxISE9Gw9wLjKw3/QD4A
# QkPeGu9M9Iep8p480Abn4mPS60xb3V1YlNPlpTkoqgdediMw/Px/mA3FZW0b1XRF
# OkawohZ13qLCKnB8tna82Ruuul2c9oeVzqqo4rWjsZNuQKWbEIh2Fk40ofye8eEa
# VNHIJFeUdq3Cx+yjo5Z14sYoawIF6Eu5teBSK3gBjCoxLEzoBeVvnw+EJi5obPrL
# TRl8GMH/ahqpy76jdfjpyBiyzN0vQUAgHM+ICxfJsIpDy+Jrk1HxEb5CvPhR8toA
# Ar4IGCgFJ8TcO113KR4Z1EEqZn20UnNcQqWQ043Fo6o3znMBlCQZQkPRlI9Lft3L
# bbwbTnv5qgsiS0mASXAbLU/eNGA+vQIDAQABo4IBnjCCAZowDgYDVR0PAQH/BAQD
# AgeAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMB0GA1UdDgQWBBRba3v0cHQIwQ0q
# yO/xxLlA0krG/TBMBgNVHSAERTBDMEEGCSsGAQQBoDIBHjA0MDIGCCsGAQUFBwIB
# FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAMBgNVHRMB
# Af8EAjAAMIGQBggrBgEFBQcBAQSBgzCBgDA5BggrBgEFBQcwAYYtaHR0cDovL29j
# c3AuZ2xvYmFsc2lnbi5jb20vY2EvZ3N0c2FjYXNoYTM4NGc0MEMGCCsGAQUFBzAC
# hjdodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3RzYWNhc2hh
# Mzg0ZzQuY3J0MB8GA1UdIwQYMBaAFOoWxmnn48tXRTkzpPBAvtDDvWWWMEEGA1Ud
# HwQ6MDgwNqA0oDKGMGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vY2EvZ3N0c2Fj
# YXNoYTM4NGc0LmNybDANBgkqhkiG9w0BAQsFAAOCAgEALms+j3+wsGDZ8Z2E3JW2
# 318NvyRR4xoGqlUEy2HB72Vxrgv9lCRXAMfk9gy8GJV9LxlqYDOmvtAIVVYEtuP+
# HrvlEHZUO6tcIV4qNU1Gy6ZMugRAYGAs29P2nd7KMhAMeLC7VsUHS3C8pw+rcryN
# y+vuwUxr2fqYoXQ+6ajIeXx2d0j9z+PwDcHpw5LgBwwTLz9rfzXZ1bfub3xYwPE/
# DBmyAqNJTJwEw/C0l6fgTWolujQWYmbIeLxpc6pfcqI1WB4m678yFKoSeuv0lmt/
# cqzqpzkIMwE2PmEkfhGdER52IlTjQLsuhgx2nmnSxBw9oguMiAQDVN7pGxf+LCue
# 2dZbIjj8ZECGzRd/4amfub+SQahvJmr0DyiwQJGQL062dlC8TSPZf09rkymnbOfQ
# MD6pkx/CUCs5xbL4TSck0f122L75k/SpVArVdljRPJ7qGugkxPs28S9Z05LD7Mtg
# Uh4cRiUI/37Zk64UlaiGigcuVItzTDcVOFBWh/FPrhyPyaFsLwv8uxxvLb2qtuto
# I/DtlCcUY8us9GeKLIHTFBIYAT+Eeq7sR2A/aFiZyUrCoZkVBcKt3qLv16dVfLyE
# G02Uu45KhUTZgT2qoyVVX6RrzTZsAPn/ct5a7P/JoEGWGkBqhZEcr3VjqMtaM7WU
# M36yjQ9zvof8rzpzH3sg23IwggZ1MIIE3aADAgECAhA1nosluv9RC3xO0e22wmkk
# MA0GCSqGSIb3DQEBDAUAMFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdv
# IExpbWl0ZWQxKzApBgNVBAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBD
# QSBSMzYwHhcNMjIwMTI3MDAwMDAwWhcNMjUwMTI2MjM1OTU5WjBSMQswCQYDVQQG
# EwJVUzERMA8GA1UECAwITWljaGlnYW4xFzAVBgNVBAoMDkFuZHJldyBSYXRoYnVu
# MRcwFQYDVQQDDA5BbmRyZXcgUmF0aGJ1bjCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBALe0CgT89ev6jRIhHdrp9cdPnRoF5AV3wQdWzNG8JiY4dpN1YVwG
# Llw8aBosm0NIRz2/y/kriL+Jdu/FFakJdpB8l/J+mesliYhN+zj9vFviBjrElMAS
# EBS9DXKaUFuqZMGiC6k6yASGfyqF121OkLZ2JImy4a0C43Pd74dbf+/Ae4QHj66o
# tahUBL++7ayba/TJebhRdEq0wFiaxYsZOt18c3LLfAw0fniHfMBZXXJAQhgu1xfg
# pw7OE4N/M5or5VDVQ4ovtSFDVRzRARIF4ibZZqB76Rp5MuI0pMCs74TPN6WdlzGT
# DBu4pTS064iGx5hlP+GB5s/w/YW1BDigFV6yaERsbet9G2lsMmNwZtI6zUuGd9HE
# td5isz/9ENhLcFoaJE7/KK8CL5jt8i9I3Lx+5EOgEwm65eHm45bq63AVKvSHrjis
# uxX89jWTeslKMM/rpw8GMrNBxo9DZvDS4+kCloFKARiwKHJIKpNWUT3T8Kw6Q/ay
# xUt7TKp+cqh0U9YoXLbXIYMpLa5KfOsf21SqfSrhJ+rSEPEBM11uX41T/mQD5sAr
# N9AIPQxp6X7qLckzClylAQgzF2OVHEEi5m2kmb0lvfMOMGQ3BgwQHCRcd65wugzC
# Iipb5KBTq+HJLgRWFwYGraxcfsLkkwBY1ssKPaVpAgMDmlWJo6hDoYR9AgMBAAGj
# ggHDMIIBvzAfBgNVHSMEGDAWgBQPKssghyi47G9IritUpimqF6TNDDAdBgNVHQ4E
# FgQUUwhn1KEy//RT4cMg1UJfMUX5lBcwDgYDVR0PAQH/BAQDAgeAMAwGA1UdEwEB
# /wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwEQYJYIZIAYb4QgEBBAQDAgQQMEoG
# A1UdIARDMEEwNQYMKwYBBAGyMQECAQMCMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8v
# c2VjdGlnby5jb20vQ1BTMAgGBmeBDAEEATBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
# Oi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2
# LmNybDB5BggrBgEFBQcBAQRtMGswRAYIKwYBBQUHMAKGOGh0dHA6Ly9jcnQuc2Vj
# dGlnby5jb20vU2VjdGlnb1B1YmxpY0NvZGVTaWduaW5nQ0FSMzYuY3J0MCMGCCsG
# AQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTAlBgNVHREEHjAcgRphbmRy
# ZXcuZC5yYXRoYnVuQGdtYWlsLmNvbTANBgkqhkiG9w0BAQwFAAOCAYEATPy2wx+J
# fB71i+UCYCOjFFBqrA4kCxsHv3ihLjF4N3g8jb7A156vBangR3BDPQ6lF0YCPwEF
# E9MQzqG7OgkUauX0vfPeuVe8cEadUFlrmb6xCmXsxKdGXObaITeGABz97AzLKxgx
# Rf7xCEKsAzvbuaK3lvb3Me9jtRVn9Q69sBTE5I/IDf2PoG/tO/ibPYXC1KpilBNT
# 0A28xMtQ1ijTS0dnbOyTMaUBCZUrNR/9qY2sOBhvxuvSouWjuEazDLTCs6zsMBQH
# 9vfrLoNlvEXI5YO9Ck19kT9pZ2rGFO7y8ySRmoVpZvHI29Z4bXBtGUGb2g/RRppi
# d5anuRtN+Skr7S1wdrNlhBIYErmCUPH2RPMphN2wmUy6IsDpdTPJkPTmU83q3tpO
# BGwvyTdxhiPIurZMXSDXfUyGB2iiXoyUHP2caVUmsarEb3BgCEf0PT2rO971WCDn
# G0mMgle2Yur4z3eWEsKUoPdFAoiizb7CddijTOsNvxYNf0XEg5Ek1gTSMYIGUTCC
# Bk0CAQEwaDBUMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVk
# MSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2AhA1
# nosluv9RC3xO0e22wmkkMA0GCWCGSAFlAwQCAQUAoEwwGQYJKoZIhvcNAQkDMQwG
# CisGAQQBgjcCAQQwLwYJKoZIhvcNAQkEMSIEIMOev2itdcSm9YaAPykXEbSkyISr
# J9C2Gaj50YyJboERMA0GCSqGSIb3DQEBAQUABIICAABOLtIEwqocn+mP1yJcAikV
# +/Dxm/2bWZE4eMWi25px7UO6ADF6PKf5PVoXlTCKr8AQkp01z9p+Nyq8blbH0wiR
# tPEoiE5YlBjUFN9w5DDlSDczoWdzcuW7gf/ttp3/IA4a14gqxcV6oJgXDGcpE4Qf
# 529zdVCBiRoqLURoLoew5VFUSY9hDDlqc/1heaaYAlIibH1pgmZBV4hJkV3ktk3/
# JZobfp2XH0Bomr9rwHs9bjwM0uuoEEIPdpWiOrOEymLAxv3iY3WKMLhXVzvkxeEh
# +DRgG7sOcgOkGpZsLs4Zc8MozANhwRNA05gq/B5xJXqtapD1UPTe8jOW+0hNBtQ9
# hQgin/ZUeblo+yC/YCz3o69M9vN57dOoNOvBw2MfWwvr68OBba6p8kDy2l46wbpd
# yOWQaTejIXvBp8kMGQ9E+8ZSxyIk6WlBpqClHQc5BhBqKTcZIYgkHuuqsg5962/a
# oBRuWdexRh8JEFbJyf/4bhOmAwdvio+MmNWzUV8n+V9Q6ArdNyUpZpLA9J9td/1Z
# B2PlwdM2jSfQDjwyMaKhsalGkMFfACQIGy90ksAF6/akNXrC45ITgzLxaZ7bcCEj
# 0NI8pVN7hsAdERAh7Ma8HrQGSl1K5TXd/J6dleinX1tP48pVRPf4y4awMVEf0sIx
# Fem1AK3qZsYP77rFAFXpoYIDbDCCA2gGCSqGSIb3DQEJBjGCA1kwggNVAgEBMG8w
# WzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExMTAvBgNV
# BAMTKEdsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gU0hBMzg0IC0gRzQCEAFI
# kD3CirynoRlNDBxXuCkwCwYJYIZIAWUDBAIBoIIBPTAYBgkqhkiG9w0BCQMxCwYJ
# KoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMzA5MDQwMjU0NTlaMCsGCSqGSIb3
# DQEJNDEeMBwwCwYJYIZIAWUDBAIBoQ0GCSqGSIb3DQEBCwUAMC8GCSqGSIb3DQEJ
# BDEiBCDxexhFFYO+R43myrNrj+RaHyNJQT032ZUJ+CHUHrqCkDCBpAYLKoZIhvcN
# AQkQAgwxgZQwgZEwgY4wgYsEFDEDDhdqpFkuqyyLregymfy1WF3PMHMwX6RdMFsx
# CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
# EyhHbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIFNIQTM4NCAtIEc0AhABSJA9
# woq8p6EZTQwcV7gpMA0GCSqGSIb3DQEBCwUABIIBgHzdIkqoJdiAOmNStsKkmCiQ
# cpALroBd/pDUExY+sI8dhpdc9J6tKOjdEn/yEgqlcYQX3B21ZFHEJzQ+4JQ/ha5q
# s48zcdq6sp1mXTyygTncDZD2+cjMbheTtbU625rV/wrvZFTmvVKGNgyodUbQa8xj
# lSaXONWiRSniTFT201X2zzdeTXdqmUfbqGtJraBrDrltXmZuN9AwOlSF7LdmiEkA
# gqblPy1jwirJchaBnrLB4dW3wmF8BFk67dUmMgc3l51HKeiJyT9R/OYIDwpcfQy+
# DI2/AKzAwbTfspcrI4TNHV06faG5NEnaybO7KuzxpiXewQjdK9+T4TQswIJchWVV
# QirxExfVvwssmeGHicwsLySQZ1sXWm4wffDL6zHIicNNshUXi04zRWsO/r3INVBl
# jSC7NtA6bnmnyXWyuBf4JqurDoB2GMfMYSPBit2yAI8l7+fhjUotjAASk5kuMPtP
# ewL+rhgndrUydLb31+9gaLjsY+OaxQiMfMIXo89ScQ==
# SIG # End signature block
