function CheckNetwork() {
  $ipInfo = Invoke-RestMethod -Uri "https://ipinfo.io/json"
  $ispName = $ipInfo.org
  Write-Output "您的运营商是: $ispName"
  $urls = @("http://www.163.com/", "http://www.qq.com/", "http://www.sohu.com/",
             "http://www.sina.com.cn/", "http://www.baidu.com/")
  $results = @{'URL' = '延迟 (ms)'}
  foreach ($url in $urls) {
    try {
      $startTime = Get-Date
      Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 5 | Out-Null
      $endTime = Get-Date
      $responseTime = New-TimeSpan -Start $startTime -End $endTime
	$responseTime = [int]$responseTime.ToString("sfff")
      $results += @{$url = $responseTime}
    } catch {
      $results += @{$url = "[失败]"}
    }
  }
  $results | Format-Table -Property @{L='中国网站测试 URL'; E='Name'}, @{L='HTTP 连接延迟 (ms)'; E='Value'} -AutoSize
  Write-Host "按任意键继续..."
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function ClearDNSCache() {
  Clear-DnsClientCache
  Write-Output "DNS缓存已清理"
  Write-Host "按任意键继续..."
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function ShowNetworkAdapters() {
  $adapters = Get-NetAdapter
  Write-Output "所有网络适配器信息:"
  Write-Output $adapters
  Write-Host "按任意键继续..."
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
$host.ui.RawUI.WindowTitle = 'DNSUtil v6 by Doodle'
while ($true) {
  Write-Output "============ DNSUtil v6 by Doodle (Public FOSS) ============"
  Write-Output "1. 网络检测"
  Write-Output "2. 清理DNS缓存"
  Write-Output "3. 显示所有网络适配器信息"
  $choice = Read-Host "请选择一个功能(1-3)"
  switch ($choice) {
  "1" { CheckNetwork }
  "2" { ClearDNSCache }
  "3" { ShowNetworkAdapters }
  default { Write-Output "无效选项。请重试。" }
}
}
