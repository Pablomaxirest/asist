# === Asistance 2.0: Formulario local con envío controlado ===

# 1. Generar Check ID
$nombre = "Pablo Arman"
$check_id = (Get-Date -Format "yyyyMMddHHmmss") + "_" + $nombre.Replace(" ", "").ToUpper()

# 2. Recolectar datos técnicos
$equipo     = $env:COMPUTERNAME
$usuario    = $env:USERNAME
$so         = (Get-WmiObject Win32_OperatingSystem).Caption
$ram        = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador = (Get-WmiObject Win32_Processor).Name
$ip         = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras = (Get-Printer | Select-Object -ExpandProperty Name) -join "; "

# 3. Generar HTML local con formulario manual
$html = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Solicitud de asistencia</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      padding: 40px;
      text-align: center;
    }
    input, textarea, button {
      font-size: 16px;
      padding: 10px;
      margin: 10px;
      width: 80%;
      max-width: 500px;
    }
    button {
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <h2>Solicitud de asistencia técnica</h2>
  <p>Por favor, describí el problema:</p>
  <form method="POST" action="https://script.google.com/macros/s/AKfycbxZzyCZhE23Rpd3ZPJ_a5t5-g5jeMaClesIVnOZ22AUnGrplTetVrfJIKCv_NLh1Yyk/exec">
    <textarea name="problema" required placeholder="Escribí tu problema aquí..."></textarea><br>
    <input type="hidden" name="check_id" value="$check_id">
    <input type="hidden" name="nombre" value="$nombre">
    <input type="hidden" name="equipo" value="$equipo">
    <input type="hidden" name="usuario" value="$usuario">
    <input type="hidden" name="so" value="$so">
    <input type="hidden" name="ram" value="$ram">
    <input type="hidden" name="procesador" value="$procesador">
    <input type="hidden" name="ip" value="$ip">
    <input type="hidden" name="impresora" value="$impresoras">
    <button type="submit">Enviar solicitud</button>
  </form>
</body>
</html>
"@

# 4. Guardar HTML en el escritorio y abrirlo
$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")
Set-Content -Path $archivoHTML -Value $html -Encoding UTF8

Start-Process $archivoHTML
Write-Host "`n✅ Formulario generado en el escritorio. El cliente debe completarlo para enviar la solicitud."

