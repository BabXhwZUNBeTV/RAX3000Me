# ��־�ļ�·��
$LOG_FILE = Join-Path (Get-Location) "generate_config.log"

# ��¼��־����
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    #Write-Output $logEntry
    Add-Content -Path $LOG_FILE -Value $logEntry
}

# ��� OpenSSL �Ƿ�װ
function Check-OpenSSL {
    $opensslPath = "C:\Program Files\OpenSSL-Win64\bin\openssl.exe"
    if (-not (Test-Path $opensslPath)) {
        Log-Message "OpenSSL not found at: $opensslPath"
        Log-Message "Please install OpenSSL and ensure it is available in the specified path."
        Write-Output "OpenSSL not found at: $opensslPath"
        Write-Output "Please install OpenSSL and ensure it is available in the specified path."
        exit 1
    }
    Log-Message "OpenSSL found at: $opensslPath"
    Write-Output "OpenSSL found at: $opensslPath"
}

# �������뺯��
function Generate-Password {
    param (
        [string]$SN
    )
    $salt = "aV6dW8bD"
    try {
        $mypassword = & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" passwd -1 -salt $salt $SN
        Log-Message "Password generated successfully."
        return $mypassword
    } catch {
        Log-Message "Failed to generate password! Error: $_"
        exit 1
    }
}

# ���������ļ�����
function Generate-Config {
    param (
        [string]$Password,
        [string]$SN
    )
    # �����ļ�·��
    $IMPORT_FILE = Join-Path (Get-Location) "RAX3000M_XR30_cfg-telnet-20240117.conf"
    $EXPORT_FILE = Join-Path (Get-Location) "cfg_import_config_file_new.conf"

    # ��������ļ��Ƿ����
    if (-not (Test-Path $IMPORT_FILE)) {
        Log-Message "Configuration file not found: $IMPORT_FILE"
        Write-Output "Configuration file not found: $IMPORT_FILE"
        exit 1
    }
    Log-Message "Using existing configuration file: $IMPORT_FILE"
    Write-Output "Using existing configuration file: $IMPORT_FILE"

    # ����ɵļ����ļ�
    if (Test-Path $EXPORT_FILE) {
        Remove-Item -Path $EXPORT_FILE -Force
        Log-Message "Deleted old encrypted file: $EXPORT_FILE"
    }

    # ʹ�� OpenSSL �����ļ�
    try {
        Log-Message "Encrypting configuration file..."
        & "C:\Program Files\OpenSSL-Win64\bin\openssl.exe" aes-256-cbc -pbkdf2 -k $Password -in $IMPORT_FILE -out $EXPORT_FILE
        if (-not (Test-Path $EXPORT_FILE)) {
            throw "Encrypted file not found!"
        }
        Log-Message "Configuration file encrypted and saved to: $EXPORT_FILE"
        Write-Output "Configuration file encrypted and saved to: $EXPORT_FILE"
    } catch {
        Log-Message "Failed to encrypt configuration file! Error: $_"
        Write-Output "Failed to encrypt configuration file! Error: $_"
        exit 1
    }

    # �����ܺ���ļ��Ƿ����
    if (Test-Path $EXPORT_FILE) {
        Log-Message "Done!"
        Write-Output "Done!"
    } else {
        Log-Message "Failed to export file! Check the SN or password!"
        Write-Output "Failed to export file! Check the SN or password!"
    }
}

# ������
try {
    # ��ʼ����־�ļ�
    if (Test-Path $LOG_FILE) {
        Remove-Item -Path $LOG_FILE -Force
    }
    New-Item -Path $LOG_FILE -ItemType File -Force

    # ��� OpenSSL
    Check-OpenSSL

    # ���ú���
    if ($SN) {
        $mypassword = Generate-Password -SN $SN
        Log-Message "Your password: $mypassword"
        Generate-Config -Password $mypassword -SN $SN
    } else {
        Log-Message "SN is not provided!"
    }
} catch {
    Log-Message "An error occurred during execution: $_"
    Write-Output "An error occurred during execution: $_"
}

# ��ͣ���ȴ��û����س���
#Log-Message "Script execution completed."