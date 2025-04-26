# Đường dẫn và tên file backup
$time = Get-Date -Format "yyyyMMdd_HHmmss"
$backupFolder = "C:\Backup"
$backupFile = "$backupFolder\MyHaoInvoiceServiceTT78_$time.bak"

# Tạo thư mục nếu chưa tồn tại
if (-not (Test-Path $backupFolder)) {
    New-Item -ItemType Directory -Path $backupFolder | Out-Null
}

# Câu lệnh SQL để backup
$sql = @"
BACKUP DATABASE [MyHaoInvoiceServiceTT78]
TO DISK = N'$backupFile'
WITH FORMAT, INIT, NAME = 'Backup MyHaoInvoiceServiceTT78_$time';
"@

# Ghi script SQL tạm vào file
$sqlFile = "$backupFolder\backup_temp.sql"
$sql | Out-File -FilePath $sqlFile -Encoding UTF8

# Thực hiện backup bằng sqlcmd
sqlcmd -S "SERVER\SQLEXPRESS" -E -i $sqlFile

# Xóa file script tạm
Remove-Item $sqlFile
