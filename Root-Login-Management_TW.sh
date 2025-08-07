#!/bin/bash

# 檢查是否以root權限執行
if [ "$(id -u)" != "0" ]; then
    echo "錯誤：此腳本必須以root權限執行！" >&2
    echo "請使用 'sudo $0' 重新執行"
    exit 1
fi

# 備份原始設定檔
backup_config() {
    local timestamp=$(date +%Y%m%d-%H%M%S)
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$timestamp
    echo "> 設定檔已備份至 /etc/ssh/sshd_config.bak.$timestamp"
}

# 啟用root登入
enable_root() {
    backup_config
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart ssh
    echo "> 已啟用 Root 登入"
    echo "> 密碼驗證已開啟"
}

# 禁用root登入
disable_root() {
    backup_config
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
    systemctl restart ssh
    echo "> 已禁用 Root 登入"
    echo "> 密碼驗證已關閉"
}

# 顯示選單
show_menu() {
    clear
    echo "========================================"
    echo " Debian Root 登入管理腳本"
    echo "========================================"
    echo " 1. 啟用 Root 登入"
    echo " 2. 禁用 Root 登入"
    echo " 3. 退出"
    echo "========================================"
}

# 主程式
while true; do
    show_menu
    read -p "請輸入選項 [1-3]: " option
    
    case $option in
        1)
            enable_root
            read -p "按Enter鍵繼續..."
            ;;
        2)
            disable_root
            read -p "按Enter鍵繼續..."
            ;;
        3)
            echo "退出程式。"
            exit 0
            ;;
        *)
            echo "錯誤：無效選項！"
            read -p "按Enter鍵重新選擇..."
            ;;
    esac
done