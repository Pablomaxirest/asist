# === Asistance 2.0: Main PowerShell ===

# 1. Recolectar datos técnicos
$nombre     = "Pablo Arman"
$check_id   = (Get-Date -Format "yyyyMMddHHmmss") + "_" + $nombre.Replace(" ", "").ToUpper()
$equipo     = $env:COMPUTERNAME
$usuario    = $env:USERNAME
$so         = (Get-WmiObject Win32_OperatingSystem).Caption
$ram        = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador = (Get-WmiObject Win32_Processor).Name
$ip         = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras = (Get-Printer | Select-Object -ExpandProperty Name) -join "; "

# 2. Descargar HTML base desde GitHub
$githubUrl = "https://raw.githubusercontent.com/Pablomaxirest/asist/main/formulario.html"
$htmlBase = Invoke-WebRequest -Uri $githubUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# 3. Reemplazar variables en el HTML
$htmlFinal = $htmlBase -replace "Pablo Arman", $nombre
$htmlFinal = $htmlFinal -replace "20250503165000_PABLOARMAN", $check_id
$htmlFinal = $htmlFinal -replace "PC-01", $equipo
$htmlFinal = $htmlFinal -replace "PABLO", $usuario
$htmlFinal = $htmlFinal -replace "8.00 GB", $ram
$htmlFinal = $htmlFinal -replace "Windows 10 Pro", $so
$htmlFinal = $htmlFinal -replace "Intel\(R\) Core\(TM\) i5-8265U", $procesador
$htmlFinal = $htmlFinal -replace "192.168.0.123", $ip
$htmlFinal = $htmlFinal -replace "EPSON L3150", $impresoras

# 4. Guardar HTML local
$hora = Get-Date -Format "HH:mm:ss"
$htmlFinal = $htmlFinal -replace "<!--HORA-->", "Ejecutado a las $hora"

$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")
[System.IO.File]::WriteAllText($archivoHTML, $htmlFinal, [System.Text.Encoding]::UTF8)

# 5. Abrir formulario
Start-Process $archivoHTML
Write-Host "\n✅ Formulario generado y abierto con éxito. Check ID: $check_id"
