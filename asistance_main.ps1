# === Asistance 2.0: Main PowerShell ===

# 1. Recolectar datos técnicos
echo "[INFO] Recolectando información del sistema..."
$nombre     = "Pablo Arman"
$check_id   = (Get-Date -Format "yyyyMMddHHmmss") + "_" + $nombre.Replace(" ", "").ToUpper()
$equipo     = $env:COMPUTERNAME
$usuario    = $env:USERNAME
$so         = (Get-WmiObject Win32_OperatingSystem).Caption
$ram        = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador = (Get-WmiObject Win32_Processor).Name
$ip         = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras = (Get-Printer | Select-Object -ExpandProperty Name) -join "; "

# Valor fijo por ahora del código de cliente
$codigoCliente = "4444"

# 2. Descargar HTML base desde GitHub
$githubUrl = "https://raw.githubusercontent.com/Pablomaxirest/asist/main/formulario.html"
echo "[INFO] Descargando formulario base desde GitHub..."
$htmlBase = Invoke-WebRequest -Uri $githubUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# 3. Reemplazar datos del sistema en el HTML
$htmlFinal = $htmlBase -replace "VALOR_NOMBRE", [regex]::Escape($nombre)
$htmlFinal = $htmlFinal -replace "VALOR_CHECKID", [regex]::Escape($check_id)
$htmlFinal = $htmlFinal -replace "VALOR_EQUIPO", [regex]::Escape($equipo)
$htmlFinal = $htmlFinal -replace "VALOR_USUARIO", [regex]::Escape($usuario)
$htmlFinal = $htmlFinal -replace "VALOR_SO", [regex]::Escape($so)
$htmlFinal = $htmlFinal -replace "VALOR_RAM", [regex]::Escape($ram)
$htmlFinal = $htmlFinal -replace "VALOR_PROCESADOR", [regex]::Escape($procesador)
$htmlFinal = $htmlFinal -replace "VALOR_IP", [regex]::Escape($ip)
$htmlFinal = $htmlFinal -replace "VALOR_IMPRESORA", [regex]::Escape($impresoras)
$htmlFinal = $htmlFinal -replace "VALOR_CODIGOCLIENTE", [regex]::Escape($codigoCliente)

# Agregar hora de ejecución
$hora = Get-Date -Format "HH:mm:ss"
$htmlFinal = $htmlFinal -replace "<!--HORA-->", "Ejecutado a las $hora"

# 4. Guardar HTML local y abrir
$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")
[System.IO.File]::WriteAllText($archivoHTML, $htmlFinal, [System.Text.Encoding]::UTF8)

Start-Process $archivoHTML
Write-Host "`n✅ Formulario generado y abierto con éxito. Check ID: $check_id"
