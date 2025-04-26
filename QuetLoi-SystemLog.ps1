# Tạo thư mục lưu log nếu chưa có
$logDir = "C:\Logs\SystemCheck"
if (!(Test-Path -Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir
}

# Định dạng tên file log theo ngày giờ
$timeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logDir\SystemLog_$timeStamp.txt"

# Ghi tiêu đề vào file log
Add-Content -Path $logFile -Value "===== System and Application Error Logs ($timeStamp) =====`n"

# Quét lỗi từ System log
Add-Content -Path $logFile -Value "`n-- SYSTEM LOG ERRORS --`n"
Get-WinEvent -LogName System -FilterXPath "*[System[(Level=2)]]" -MaxEvents 50 | 
    Format-Table TimeCreated, Id, LevelDisplayName, Message -Wrap -AutoSize | 
    Out-String | Add-Content -Path $logFile

# Quét lỗi từ Application log
Add-Content -Path $logFile -Value "`n-- APPLICATION LOG ERRORS --`n"
Get-WinEvent -LogName Application -FilterXPath "*[System[(Level=2)]]" -MaxEvents 50 | 
    Format-Table TimeCreated, Id, LevelDisplayName, Message -Wrap -AutoSize | 
    Out-String | Add-Content -Path $logFile

# Xuất đường dẫn log
Write-Output "Log file created at: $logFile"
