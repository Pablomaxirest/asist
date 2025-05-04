# === Asistance 2.0: Main PowerShell ===

# 🔹 Información del cliente
echo "[INFO] Recolectando información del sistema..."
$nombre         = "Pablo Arman"
$codigoCliente  = "4444"
$equipo         = $env:COMPUTERNAME
$usuario        = $env:USERNAME

# 📌 Timestamp formateado (sin segundos) y Check ID
$timestamp      = Get-Date -Format "yyyyMMddHHmm"
$check_id       = "$codigoCliente-$equipo-$timestamp"

# ─────────────────────────────────────────────────────────────────────

# 🔸 Información técnica del sistema
$so             = (Get-WmiObject Win32_OperatingSystem).Caption
$ram            = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador     = (Get-WmiObject Win32_Processor).Name
$ip             = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras     = (Get-Printer | Select-Object -ExpandProperty Name) -join ";"  # ← sin espacios para luego dividir

# 2. Descargar HTML base desde GitHub
$githubUrl = "https://raw.githubusercontent.com/Pablomaxirest/asist/main/formulario.html"
echo "[INFO] Descargando formulario base desde GitHub..."
$htmlBase = Invoke-WebRequest -Uri $githubUrl -UseBasicParsing | Select-Object -ExpandProperty Content

# 3. Reemplazar datos del sistema en el HTML
$htmlFinal = $htmlBase -replace "VALOR_NOMBRE", $nombre
$htmlFinal = $htmlFinal -replace "VALOR_CHECKID", $check_id
$htmlFinal = $htmlFinal -replace "VALOR_EQUIPO", $equipo
$htmlFinal = $htmlFinal -replace "VALOR_USUARIO", $usuario
$htmlFinal = $htmlFinal -replace "VALOR_SO", $so
$htmlFinal = $htmlFinal -replace "VALOR_RAM", $ram
$htmlFinal = $htmlFinal -replace "VALOR_PROCESADOR", $procesador
$htmlFinal = $htmlFinal -replace "VALOR_IP", $ip
$htmlFinal = $htmlFinal -replace "VALOR_IMPRESORA", $impresoras
$htmlFinal = $htmlFinal -replace "VALOR_CODIGOCLIENTE", $codigoCliente

# 4. Guardar HTML local y abrir
$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")
[System.IO.File]::WriteAllText($archivoHTML, $htmlFinal, [System.Text.Encoding]::UTF8)

Start-Process $archivoHTML
Write-Host "`n✅ Formulario generado y abierto con éxito. Check ID: $check_id"
