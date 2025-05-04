# === Asistance 2.0: Main PowerShell con datos reales ===

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

# 3. Reemplazar los valores del formulario
$htmlFinal = $htmlBase -replace "VALOR_NOMBRE", $nombre
$htmlFinal = $htmlFinal -replace "VALOR_CHECKID", $check_id
$htmlFinal = $htmlFinal -replace "VALOR_EQUIPO", $equipo
$htmlFinal = $htmlFinal -replace "VALOR_USUARIO", $usuario
$htmlFinal = $htmlFinal -replace "VALOR_SO", $so
$htmlFinal = $htmlFinal -replace "VALOR_RAM", $ram
$htmlFinal = $htmlFinal -replace "VALOR_PROCESADOR", $procesador
$htmlFinal = $htmlFinal -replace "VALOR_IP", $ip
$htmlFinal = $htmlFinal -replace "VALOR_IMPRESORA", $impresoras

# 4. Agregar la hora de ejecución
$hora = Get-Date -Format "HH:mm:ss"
$htmlFinal = $htmlFinal -replace "<!--HORA-->", "Ejecutado a las $hora"

# 5. Guardar y abrir el HTML local
$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")
[System.IO.File]::WriteAllText($archivoHTML, $htmlFinal, [System.Text.Encoding]::UTF8)
Start-Process $archivoHTML
Write-Host "`n✅ Formulario generado y abierto con éxito. Check ID: $check_id"
