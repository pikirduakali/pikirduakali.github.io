$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$port = 3456
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Server ready at http://localhost:$port" -ForegroundColor Green
Write-Host "Close this window to stop the server." -ForegroundColor DarkGray

while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $req = $ctx.Request
  $res = $ctx.Response

  $body = ""
  if ($req.InputStream) {
    $reader = New-Object System.IO.StreamReader($req.InputStream)
    $body = $reader.ReadToEnd()
    $reader.Close()
  }

  $path = $req.Url.AbsolutePath
  $ok = $true; $msg = ""

  try {
    switch ($path) {
      "/ping" { $msg = "pong" }

      "/save-article" {
        $d = $body | ConvertFrom-Json
        $slug = $d.slug
        $txt = $d.txt
        $json = $d.json
        [System.IO.File]::WriteAllText("$scriptDir\articles\$slug.txt", $txt)
        [System.IO.File]::WriteAllText("$scriptDir\articles.json", $json)
        $msg = "article saved"
      }

      "/save-project" {
        $d = $body | ConvertFrom-Json
        $slug = $d.slug
        $txt = $d.txt
        $json = $d.json
        [System.IO.File]::WriteAllText("$scriptDir\projects\$slug.txt", $txt)
        [System.IO.File]::WriteAllText("$scriptDir\projects.json", $json)
        $msg = "project saved"
      }

      "/save-content" {
        $d = $body | ConvertFrom-Json
        [System.IO.File]::WriteAllText("$scriptDir\site-content.json", $d.json)
        $msg = "content saved"
      }

      "/push" {
        $d = $body | ConvertFrom-Json
        $m = $d.message
        & "git" add -A
        $commitOut = & "git" commit -m $m 2>&1
        $pushOut = & "git" push 2>&1
        $msg = "done: $($commitOut -join '; ') | $($pushOut -join '; ')"
      }

      default { $ok = $false; $msg = "unknown route" }
    }
  } catch {
    $ok = $false
    $msg = $_.Exception.Message
  }

  $resp = @{ ok = $ok; msg = $msg } | ConvertTo-Json
  $buffer = [System.Text.Encoding]::UTF8.GetBytes($resp)
  $res.ContentType = "application/json"
  $res.ContentLength64 = $buffer.Length
  $res.OutputStream.Write($buffer, 0, $buffer.Length)
  $res.OutputStream.Close()
}

$listener.Stop()
