# === Asistance 2.0: Script principal desde la nube ===

$nombre = "Pablo Arman"
$check_id = (Get-Date -Format "yyyyMMddHHmmss") + "_" + $nombre.Replace(" ", "").ToUpper()

$equipo     = $env:COMPUTERNAME
$usuario    = $env:USERNAME
$so         = (Get-WmiObject Win32_OperatingSystem).Caption
$ram        = "{0:N2} GB" -f ((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$procesador = (Get-WmiObject Win32_Processor).Name
$ip         = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "169.*" } | Select-Object -First 1).IPAddress
$impresoras = (Get-Printer | Select-Object -ExpandProperty Name) -join "; "

$html = @"
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Enviando datos técnicos...</title>
</head>
<body>
  <form id="autoform" method="POST" action="https://script.google.com/macros/s/AKfycbxZzyCZhE23Rpd3ZPJ_a5t5-g5jeMaClesIVnOZ22AUnGrplTetVrfJIKCv_NLh1Yyk/exec">
    <input type="hidden" name="check_id" value="$check_id">
    <input type="hidden" name="equipo" value="$equipo">
    <input type="hidden" name="usuario" value="$usuario">
    <input type="hidden" name="so" value="$so">
    <input type="hidden" name="ram" value="$ram">
    <input type="hidden" name="procesador" value="$procesador">
    <input type="hidden" name="ip" value="$ip">
    <input type="hidden" name="impresora" value="$impresoras">
  </form>
  <script>
    document.getElementById("autoform").submit();
    setTimeout(() => {
      window.location.href = "https://script.google.com/macros/s/AKfycbxZzyCZhE23Rpd3ZPJ_a5t5-g5jeMaClesIVnOZ22AUnGrplTetVrfJIKCv_NLh1Yyk/exec?check_id=$check_id";
    }, 1500);
  </script>
</body>
</html>
"@

$archivoHTML = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "asistance_envio.html")
Set-Content -Path $archivoHTML -Value $html -Encoding UTF8

Start-Process $archivoHTML
Write-Host "`n✅ Datos técnicos enviados. Se abrió el formulario para que el cliente lo complete."
