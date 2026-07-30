$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$port = 3457
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Server ready at http://localhost:$port" -ForegroundColor Green
Write-Host "Close this window to stop the server." -ForegroundColor DarkGray

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request
  $res = $ctx.Response

  # CORS headers on every response
  $res.Headers.Add("Access-Control-Allow-Origin", "*")
  $res.Headers.Add("Access-Control-Allow-Headers", "Content-Type")
  $res.Headers.Add("Access-Control-Allow-Methods", "POST, GET, OPTIONS")

  # Handle OPTIONS preflight
  if ($req.HttpMethod -eq "OPTIONS") {
    $res.StatusCode = 204; $res.OutputStream.Close(); continue
  }

  $path = $req.Url.AbsolutePath

  # Read body for POST
  $body = ""
  if ($req.InputStream) {
    $reader = New-Object System.IO.StreamReader($req.InputStream)
    $body = $reader.ReadToEnd(); $reader.Close()
  }

  # Serve static files
  if ($req.HttpMethod -eq "GET" -and $path -ne "/ping") {
    if ($path -eq "/") { $path = "/sendmessage.html" }
    $filePath = "$scriptDir$path"
    if (Test-Path $filePath -PathType Leaf) {
      $ext = [System.IO.Path]::GetExtension($filePath)
      $map = @{ ".html" = "text/html"; ".css" = "text/css"; ".js" = "application/javascript"; ".json" = "application/json"; ".png" = "image/png"; ".jpg" = "image/jpeg"; ".svg" = "image/svg+xml"; ".txt" = "text/plain" }
      $ct = if ($map.ContainsKey($ext)) { $map[$ext] } else { "application/octet-stream" }
      $data = [System.IO.File]::ReadAllBytes($filePath)
      $res.ContentType = $ct; $res.ContentLength64 = $data.Length
      $res.OutputStream.Write($data, 0, $data.Length)
      $res.OutputStream.Close(); continue
    }
  }

  # API routes
  $ok = $true; $msg = ""
  try {
    if ($path -eq "/ping") {
      $msg = "pong"
    } elseif ($path -eq "/save-article") {
      $d = $body | ConvertFrom-Json
      [System.IO.File]::WriteAllText("$scriptDir\articles\$($d.slug).txt", $d.txt)
      [System.IO.File]::WriteAllText("$scriptDir\articles.json", $d.json)
      $msg = "article saved"
    } elseif ($path -eq "/save-project") {
      $d = $body | ConvertFrom-Json
      [System.IO.File]::WriteAllText("$scriptDir\projects\$($d.slug).txt", $d.txt)
      [System.IO.File]::WriteAllText("$scriptDir\projects.json", $d.json)
      $msg = "project saved"
    } elseif ($path -eq "/save-content") {
      $d = $body | ConvertFrom-Json
      [System.IO.File]::WriteAllText("$scriptDir\site-content.json", $d.json)
      $msg = "content saved"
    } elseif ($path -eq "/push") {
      $d = $body | ConvertFrom-Json
      Set-Location $scriptDir
      git add -A 2>&1 | Out-Null
      $commitOut = git commit -m "$($d.message)" 2>&1
      $pushJob = Start-Job -ScriptBlock { param($d) Set-Location $d; git push 2>&1 } -ArgumentList $scriptDir
      $pushResult = Wait-Job $pushJob -Timeout 30
      if (!$pushResult) { Stop-Job $pushJob; $pushOut = "TIMEOUT — git push stuck (credentials?)" }
      else { $pushOut = Receive-Job $pushJob }
      Remove-Job $pushJob -Force
      $msg = "$($commitOut -join '; ') | $($pushOut -join '; ')"
    } else {
      $ok = $false; $msg = "not found"
    }
  } catch {
    $ok = $false; $msg = $_.Exception.Message
  }

  $resp = (@{ ok = $ok; msg = $msg } | ConvertTo-Json)
  $buffer = [System.Text.Encoding]::UTF8.GetBytes($resp)
  $res.ContentType = "application/json"
  $res.ContentLength64 = $buffer.Length
  $res.OutputStream.Write($buffer, 0, $buffer.Length)
  $res.OutputStream.Close()
}

$listener.Stop()
