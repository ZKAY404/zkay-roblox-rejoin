#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# ZKAY Roblox Rejoin - Uninstaller
# ============================================================================
# This script removes the ZKAY Rejoin installation
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
INSTALL_DIR="$HOME/zkay-rejoin"
BIN_DIR="$PREFIX/bin"
SCRIPT_NAME="zkayrj"

print_banner() {
    clear
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║        🗑️  ZKAY ROBLOX REJOIN UNINSTALLER  🗑️           ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}[$(date +%H:%M:%S)]${NC} ${GREEN}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

backup_configs() {
    print_step "Backup configs..."
    
    if [ -d "$INSTALL_DIR" ]; then
        local backup_dir="$HOME/zkay-rejoin-backup-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$backup_dir"
        
        # Backup config files
        [ -f "$INSTALL_DIR/multi_configs.json" ] && cp "$INSTALL_DIR/multi_configs.json" "$backup_dir/"
        [ -f "$INSTALL_DIR/webhook_config.json" ] && cp "$INSTALL_DIR/webhook_config.json" "$backup_dir/"
        [ -f "$INSTALL_DIR/package_prefix_config.json" ] && cp "$INSTALL_DIR/package_prefix_config.json" "$backup_dir/"
        [ -f "$INSTALL_DIR/activity_config.json" ] && cp "$INSTALL_DIR/activity_config.json" "$backup_dir/"
        [ -f "$INSTALL_DIR/discord_bot_config.json" ] && cp "$INSTALL_DIR/discord_bot_config.json" "$backup_dir/"
        
        if [ "$(ls -A $backup_dir)" ]; then
            print_success "Configs đã được backup tại: $backup_dir"
        else
            rm -rf "$backup_dir"
            print_warning "Không có config nào để backup"
        fi
    fi
}

remove_command() {
    print_step "Xóa lệnh global 'zkayrj'..."
    
    if [ -f "$BIN_DIR/$SCRIPT_NAME" ]; then
        rm -f "$BIN_DIR/$SCRIPT_NAME"
        print_success "Đã xóa lệnh 'zkayrj'"
    else
        print_warning "Lệnh 'zkayrj' không tồn tại"
    fi
}

remove_installation() {
    print_step "Xóa installation directory..."
    
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        print_success "Đã xóa thư mục installation"
    else
        print_warning "Thư mục installation không tồn tại"
    fi
}

remove_shortcuts() {
    print_step "Xóa shortcuts..."
    
    if [ -f "$HOME/.shortcuts/ZKAY-Rejoin" ]; then
        rm -f "$HOME/.shortcuts/ZKAY-Rejoin"
        print_success "Đã xóa shortcuts"
    else
        print_warning "Không có shortcuts để xóa"
    fi
}

main() {
    print_banner
    
    echo -e "${YELLOW}Bạn có chắc chắn muốn gỡ cài đặt ZKAY Rejoin?${NC}"
    echo -e "${CYAN}Configs sẽ được backup trước khi xóa.${NC}"
    echo ""
    read -p "Nhập 'yes' để xác nhận: " confirm
    
    if [ "$confirm" != "yes" ]; then
        echo -e "${GREEN}Đã hủy gỡ cài đặt${NC}"
        exit 0
    fi
    
    echo ""
    echo -e "${RED}Bắt đầu gỡ cài đặt...${NC}"
    echo ""
    
    backup_configs
    remove_command
    remove_shortcuts
    remove_installation
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║  ✓  GỠ CÀI ĐẶT HOÀN TẤT!               ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Cảm ơn bạn đã sử dụng ZKAY Rejoin Tool!${NC}"
    echo -e "${YELLOW}Để cài đặt lại:${NC}"
    echo -e "  bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh)"
    echo ""
}

main "$@"
