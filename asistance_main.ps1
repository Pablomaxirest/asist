# === Asistance 2.0: Formulario local con envío controlado ===

$nombre = "Pablo Arman"
$check_id = (Get-Date -Format "yyyyMMddHHmmss") + "_" + $nombre.Replace(" ", "").ToUpper()

$equipo     = $env:COMPUTERNAME
$usuario    = $env:USERNAME
$so         = (Get-WmiObject Win32_OperatingSystem).Caption
$ram        = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador = (Get-WmiObject Win32_Processor).Name
$ip         = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras = (Get-Printer | Select-Object -ExpandProperty Name) -join "; "
$fechaHora  = Get-Date -Format "dd MM yyyy HH:mm:ss"

$htmlContent = @"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Solicitud de Asistencia Técnica</title>
  <style>
    body {
      font-family: "Segoe UI", sans-serif;
      background-color: #f4f4f4;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .form-container {
      background: white;
      padding: 30px 40px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
      text-align: center;
      width: 100%;
      max-width: 450px;
    }
    textarea {
      width: 100%;
      height: 100px;
      margin-top: 10px;
      font-size: 14px;
      padding: 10px;
      resize: none;
    }
    button {
      background-color: #28a745;
      color: white;
      font-size: 16px;
      padding: 12px 25px;
      border: none;
      border-radius: 6px;
      margin-top: 20px;
      cursor: pointer;
    }
    button:hover {
      background-color: #218838;
    }
    .ejecutado {
      font-size: 13px;
      color: #888;
      margin-bottom: 10px;
    }
  </style>
</head>
<body>
  <div class="form-container">
    <p class="ejecutado">Ejecutado el $fechaHora</p>
    <h2><strong>Solicitud de asistencia técnica</strong></h2>
    <p>Por favor, describí el problema:</p>
    <form method="POST" action="https://script.google.com/macros/s/AKfycbxZzyCZhE23Rpd3ZPJ_a5t5-g5jeMaClesIVnOZ22AUnGrplTetVrfJIKCv_NLh1Yyk/exec">
      <textarea name="problema" required></textarea>
      <input type="hidden" name="nombre" value="$nombre">
      <input type="hidden" name="check_id" value="$check_id">
      <input type="hidden" name="equipo" value="$equipo">
      <input type="hidden" name="usuario" value="$usuario">
      <input type="hidden" name="so" value="$so">
      <input type="hidden" name="ram" value="$ram">
      <input type="hidden" name="procesador" value="$procesador">
      <input type="hidden" name="ip" value="$ip">
      <input type="hidden" name="impresora" value="$impresoras">
      <button type="submit">Enviar solicitud</button>
    </form>
  </div>
</body>
</html>
"@

$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_formulario.html")

# ✅ Esta línea es la clave
$utf8BOM = New-Object System.Text.UTF8Encoding $true
$htmlContent | Out-File -FilePath $archivoHTML -Encoding utf8


Start-Process $archivoHTML
Write-Host "`n✅ Formulario generado en el escritorio. El cliente debe completarlo para enviar la solicitud."
