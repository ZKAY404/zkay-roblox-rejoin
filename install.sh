#!/data/data/com.termux/files/usr/bin/bash

# ============================================================================
# ZKAY Roblox Rejoin - Termux Installer & Loader
# ============================================================================
# This script:
# 1. Installs all required dependencies
# 2. Sets up the environment
# 3. Creates a global 'zkayrj' command
# 4. Handles updates and maintenance
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/ZKAY404/zkay-roblox-rejoin.git"
INSTALL_DIR="$HOME/zkay-rejoin"
BIN_DIR="$PREFIX/bin"
SCRIPT_NAME="zkayrj"
MAIN_SCRIPT="rejoin.cjs"

# ============================================================================
# Helper Functions
# ============================================================================

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║        🚀  ZKAY ROBLOX REJOIN INSTALLER  🚀             ║"
    echo "║                                                          ║"
    echo "║              Bản quyền thuộc về ZKAY404                  ║"
    echo "║            github.com/ZKAY404/zkay-roblox-rejoin         ║"
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

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Check if running in Termux
# ============================================================================

check_termux() {
    if [ ! -d "/data/data/com.termux" ]; then
        print_error "Script này chỉ chạy được trên Termux!"
        print_info "Vui lòng cài đặt Termux từ F-Droid hoặc GitHub"
        exit 1
    fi
    print_success "Đang chạy trên Termux"
}

# ============================================================================
# Update Termux packages
# ============================================================================

update_termux() {
    print_step "Cập nhật Termux packages..."
    
    if ! pkg update -y 2>/dev/null; then
        print_warning "Lỗi khi update packages, thử lại..."
        pkg update -y || {
            print_error "Không thể update packages"
            exit 1
        }
    fi
    
    if ! pkg upgrade -y 2>/dev/null; then
        print_warning "Lỗi khi upgrade packages, bỏ qua..."
    fi
    
    print_success "Đã cập nhật Termux packages"
}

# ============================================================================
# Install required packages
# ============================================================================

install_dependencies() {
    print_step "Cài đặt các dependencies cần thiết..."
    
    local packages=(
        "git"
        "nodejs"
        "python"
        "sqlite"
        "termux-api"
        "wget"
        "curl"
    )
    
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null && ! pkg list-installed | grep -q "^$package/"; then
            print_info "Đang cài đặt $package..."
            if pkg install -y "$package" 2>/dev/null; then
                print_success "Đã cài đặt $package"
            else
                print_warning "Không thể cài đặt $package, có thể đã được cài đặt"
            fi
        else
            print_success "$package đã được cài đặt"
        fi
    done
    
    print_success "Hoàn tất cài đặt dependencies"
}

# ============================================================================
# Setup storage permissions
# ============================================================================

setup_storage() {
    print_step "Thiết lập quyền truy cập storage..."
    
    if [ ! -d "$HOME/storage" ]; then
        print_info "Yêu cầu quyền truy cập storage..."
        termux-setup-storage
        
        # Wait for user to grant permission
        echo -e "${YELLOW}Vui lòng cấp quyền truy cập storage khi được yêu cầu${NC}"
        sleep 3
        
        if [ -d "$HOME/storage" ]; then
            print_success "Đã cấp quyền truy cập storage"
        else
            print_warning "Chưa cấp quyền storage, tiếp tục cài đặt..."
        fi
    else
        print_success "Storage đã được thiết lập"
    fi
}

# ============================================================================
# Clone or update repository
# ============================================================================

setup_repository() {
    print_step "Thiết lập repository..."
    
    if [ -d "$INSTALL_DIR" ]; then
        print_info "Thư mục đã tồn tại, đang cập nhật..."
        cd "$INSTALL_DIR"
        
        # Backup configs if they exist
        if [ -f "multi_configs.json" ]; then
            print_info "Đang backup configs..."
            cp multi_configs.json multi_configs.json.backup
            cp webhook_config.json webhook_config.json.backup 2>/dev/null || true
            cp package_prefix_config.json package_prefix_config.json.backup 2>/dev/null || true
            cp activity_config.json activity_config.json.backup 2>/dev/null || true
        fi
        
        # Update repository
        if git pull origin main 2>/dev/null; then
            print_success "Đã cập nhật repository"
        else
            print_warning "Không thể update, sử dụng phiên bản hiện tại"
        fi
        
        # Restore configs
        if [ -f "multi_configs.json.backup" ]; then
            print_info "Đang khôi phục configs..."
            mv multi_configs.json.backup multi_configs.json
            mv webhook_config.json.backup webhook_config.json 2>/dev/null || true
            mv package_prefix_config.json.backup package_prefix_config.json 2>/dev/null || true
            mv activity_config.json.backup activity_config.json 2>/dev/null || true
            print_success "Đã khôi phục configs"
        fi
    else
        print_info "Đang clone repository..."
        if git clone "$REPO_URL" "$INSTALL_DIR" 2>/dev/null; then
            print_success "Đã clone repository"
        else
            print_error "Không thể clone repository"
            print_info "Thử tải trực tiếp..."
            
            mkdir -p "$INSTALL_DIR"
            cd "$INSTALL_DIR"
            
            # Download main script directly
            if wget -O "$MAIN_SCRIPT" "https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/$MAIN_SCRIPT" 2>/dev/null; then
                print_success "Đã tải script chính"
            else
                print_error "Không thể tải script"
                exit 1
            fi
        fi
    fi
    
    cd "$INSTALL_DIR"
    print_success "Repository đã sẵn sàng tại $INSTALL_DIR"
}

# ============================================================================
# Install Node.js packages
# ============================================================================

install_node_packages() {
    print_step "Cài đặt Node.js packages..."
    
    cd "$INSTALL_DIR"
    
    # Create package.json if it doesn't exist
    if [ ! -f "package.json" ]; then
        print_info "Tạo package.json..."
        cat > package.json << 'EOF'
{
  "name": "zkay-roblox-rejoin",
  "version": "1.0.0",
  "description": "ZKAY Roblox Auto Rejoin Tool",
  "main": "rejoin.cjs",
  "scripts": {
    "start": "node rejoin.cjs"
  },
  "keywords": ["roblox", "rejoin", "automation"],
  "author": "ZKAY404",
  "license": "MIT",
  "dependencies": {
    "axios": "^1.6.0",
    "cli-table3": "^0.6.3",
    "figlet": "^1.7.0",
    "boxen": "^7.1.1",
    "screenshot-desktop": "^1.15.0",
    "discord.js": "^14.14.1",
    "dotenv": "^16.3.1"
  }
}
EOF
        print_success "Đã tạo package.json"
    fi
    
    # Install packages
    print_info "Đang cài đặt npm packages (có thể mất vài phút)..."
    
    if npm install 2>/dev/null; then
        print_success "Đã cài đặt tất cả npm packages"
    else
        print_warning "Lỗi khi cài packages, thử cài từng package..."
        
        local packages=(
            "axios"
            "cli-table3"
            "figlet"
            "boxen"
            "screenshot-desktop"
            "discord.js"
            "dotenv"
        )
        
        for package in "${packages[@]}"; do
            print_info "Đang cài $package..."
            npm install "$package" 2>/dev/null || print_warning "Không thể cài $package"
        done
    fi
    
    print_success "Hoàn tất cài đặt Node.js packages"
}

# ============================================================================
# Create global command
# ============================================================================

create_global_command() {
    print_step "Tạo lệnh global 'zkayrj'..."
    
    # Create the wrapper script
    cat > "$BIN_DIR/$SCRIPT_NAME" << EOF
#!/data/data/com.termux/files/usr/bin/bash

# ZKAY Roblox Rejoin - Global Command
# This script runs the rejoin tool from anywhere

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

INSTALL_DIR="$INSTALL_DIR"
MAIN_SCRIPT="$MAIN_SCRIPT"

# Check if installation exists
if [ ! -d "\$INSTALL_DIR" ]; then
    echo -e "\${RED}✗\${NC} Không tìm thấy installation!"
    echo -e "\${YELLOW}Vui lòng chạy lại installer:\${NC}"
    echo -e "  bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh)"
    exit 1
fi

# Check if main script exists
if [ ! -f "\$INSTALL_DIR/\$MAIN_SCRIPT" ]; then
    echo -e "\${RED}✗\${NC} Không tìm thấy script chính!"
    echo -e "\${YELLOW}Vui lòng chạy lại installer\${NC}"
    exit 1
fi

# Handle arguments
case "\$1" in
    update|--update|-u)
        echo -e "\${CYAN}🔄 Đang cập nhật ZKAY Rejoin...\${NC}"
        cd "\$INSTALL_DIR"
        
        # Backup configs
        [ -f "multi_configs.json" ] && cp multi_configs.json multi_configs.json.backup
        [ -f "webhook_config.json" ] && cp webhook_config.json webhook_config.json.backup
        [ -f "package_prefix_config.json" ] && cp package_prefix_config.json package_prefix_config.json.backup
        [ -f "activity_config.json" ] && cp activity_config.json activity_config.json.backup
        
        # Update
        if git pull origin main 2>/dev/null; then
            echo -e "\${GREEN}✓\${NC} Đã cập nhật repository"
        else
            echo -e "\${YELLOW}⚠\${NC} Không thể update repository"
        fi
        
        # Restore configs
        [ -f "multi_configs.json.backup" ] && mv multi_configs.json.backup multi_configs.json
        [ -f "webhook_config.json.backup" ] && mv webhook_config.json.backup webhook_config.json
        [ -f "package_prefix_config.json.backup" ] && mv package_prefix_config.json.backup package_prefix_config.json
        [ -f "activity_config.json.backup" ] && mv activity_config.json.backup activity_config.json
        
        # Update packages
        echo -e "\${CYAN}📦 Đang cập nhật packages...\${NC}"
        npm install 2>/dev/null && echo -e "\${GREEN}✓\${NC} Đã cập nhật packages"
        
        echo -e "\${GREEN}✓\${NC} Hoàn tất cập nhật!"
        ;;
    
    config|--config|-c)
        echo -e "\${CYAN}⚙️ Mở thư mục config...\${NC}"
        cd "\$INSTALL_DIR"
        ls -lah *.json 2>/dev/null || echo -e "\${YELLOW}Chưa có file config nào\${NC}"
        ;;
    
    logs|--logs|-l)
        echo -e "\${CYAN}📋 Hiển thị logs...\${NC}"
        if [ -f "\$INSTALL_DIR/rejoin.log" ]; then
            tail -n 50 "\$INSTALL_DIR/rejoin.log"
        else
            echo -e "\${YELLOW}Chưa có log file\${NC}"
        fi
        ;;
    
    clean|--clean)
        echo -e "\${CYAN}🧹 Dọn dẹp files...\${NC}"
        cd "\$INSTALL_DIR"
        rm -f screenshot_*.png system_info_*.txt cookies_temp_*.db
        echo -e "\${GREEN}✓\${NC} Đã xóa các file tạm"
        ;;
    
    root|--root|-r)
        echo -e "\${CYAN}🔑 Chạy với quyền root...\${NC}"
        cd "\$INSTALL_DIR"
        su -c "node \$MAIN_SCRIPT"
        ;;
    
    help|--help|-h)
        echo -e "\${CYAN}╔════════════════════════════════════════╗\${NC}"
        echo -e "\${CYAN}║  ZKAY Roblox Rejoin - Commands        ║\${NC}"
        echo -e "\${CYAN}╚════════════════════════════════════════╝\${NC}"
        echo ""
        echo -e "\${GREEN}Usage:\${NC} zkayrj [command]"
        echo ""
        echo -e "\${YELLOW}Commands:\${NC}"
        echo -e "  (none)           Chạy rejoin tool"
        echo -e "  update, -u       Cập nhật tool"
        echo -e "  config, -c       Xem configs"
        echo -e "  logs, -l         Xem logs"
        echo -e "  clean            Xóa files tạm"
        echo -e "  root, -r         Chạy với root"
        echo -e "  help, -h         Hiển thị help"
        echo ""
        echo -e "\${YELLOW}Examples:\${NC}"
        echo -e "  zkayrj           # Chạy tool"
        echo -e "  zkayrj -u        # Cập nhật"
        echo -e "  zkayrj -r        # Chạy với root"
        ;;
    
    *)
        # Default: Run the main script
        cd "\$INSTALL_DIR"
        
        # Check for root if needed
        if [ "\$(id -u)" != "0" ]; then
            echo -e "\${YELLOW}⚠ Đang chạy không có quyền root\${NC}"
            echo -e "\${CYAN}Một số tính năng có thể không hoạt động\${NC}"
            echo -e "\${YELLOW}Chạy 'zkayrj -r' để chạy với root\${NC}"
            echo ""
        fi
        
        # Run the script
        node "\$MAIN_SCRIPT" "\$@"
        ;;
esac
EOF
    
    # Make it executable
    chmod +x "$BIN_DIR/$SCRIPT_NAME"
    
    print_success "Đã tạo lệnh global 'zkayrj'"
    print_info "Bây giờ bạn có thể chạy 'zkayrj' từ bất kỳ đâu!"
}

# ============================================================================
# Setup Termux API permissions
# ============================================================================

setup_termux_api() {
    print_step "Thiết lập Termux API..."
    
    if command -v termux-wake-lock &> /dev/null; then
        print_success "Termux API đã được cài đặt"
        
        # Try to enable wake lock
        if termux-wake-lock 2>/dev/null; then
            print_success "Wake lock đã được bật"
        else
            print_warning "Không thể bật wake lock (cần cài Termux:API app)"
            print_info "Tải Termux:API từ F-Droid hoặc GitHub"
        fi
    else
        print_warning "Termux API chưa được cài đặt"
    fi
}

# ============================================================================
# Create desktop shortcut (optional)
# ============================================================================

create_shortcut() {
    print_step "Tạo shortcut..."
    
    local shortcut_dir="$HOME/.shortcuts"
    mkdir -p "$shortcut_dir"
    
    cat > "$shortcut_dir/ZKAY-Rejoin" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
zkayrj
EOF
    
    chmod +x "$shortcut_dir/ZKAY-Rejoin"
    print_success "Đã tạo shortcut trong Termux Widget"
    print_info "Thêm Termux:Widget để dùng shortcut từ home screen"
}

# ============================================================================
# Print final instructions
# ============================================================================

print_instructions() {
    clear
    print_banner
    
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}║  ✓  CÀI ĐẶT HOÀN TẤT!                                      ║${NC}"
    echo -e "${GREEN}║                                                            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${CYAN}📍 Installation Directory:${NC}"
    echo -e "   $INSTALL_DIR"
    echo ""
    
    echo -e "${CYAN}🚀 Cách sử dụng:${NC}"
    echo -e "   ${GREEN}zkayrj${NC}              - Chạy rejoin tool"
    echo -e "   ${GREEN}zkayrj -u${NC}           - Cập nhật tool"
    echo -e "   ${GREEN}zkayrj -r${NC}           - Chạy với root"
    echo -e "   ${GREEN}zkayrj -h${NC}           - Xem help"
    echo ""
    
    echo -e "${CYAN}⚙️ Cấu hình Discord Heartbeat (Tùy chọn):${NC}"
    echo -e "   1. Tạo Discord Bot tại: ${YELLOW}https://discord.com/developers/applications${NC}"
    echo -e "   2. Copy file .env.example thành .env:"
    echo -e "      ${GREEN}cd $INSTALL_DIR && cp .env.example .env${NC}"
    echo -e "   3. Chỉnh sửa .env với token và channel ID của bạn:"
    echo -e "      ${GREEN}nano .env${NC}"
    echo ""
    
    echo -e "${CYAN}🔑 Quyền Root:${NC}"
    echo -e "   Tool cần quyền root để:"
    echo -e "   - Đọc cookie từ app Roblox"
    echo -e "   - Launch app Roblox"
    echo -e "   - Chụp screenshot"
    echo ""
    
    echo -e "${CYAN}📚 Hướng dẫn chi tiết:${NC}"
    echo -e "   ${YELLOW}https://github.com/ZKAY404/zkay-roblox-rejoin${NC}"
    echo ""
    
    echo -e "${CYAN}💡 Quick Start:${NC}"
    echo -e "   ${GREEN}1.${NC} Chạy: ${GREEN}zkayrj${NC}"
    echo -e "   ${GREEN}2.${NC} Chọn option ${GREEN}2${NC} (Setup packages)"
    echo -e "   ${GREEN}3.${NC} Chọn packages để setup"
    echo -e "   ${GREEN}4.${NC} Chọn game và delay"
    echo -e "   ${GREEN}5.${NC} Chạy: ${GREEN}zkayrj${NC} và chọn option ${GREEN}1${NC} (Bắt đầu auto rejoin)"
    echo ""
    
    echo -e "${YELLOW}⚠️  Lưu ý:${NC}"
    echo -e "   - Cần cài ít nhất 1 app Roblox (Global hoặc VNG)"
    echo -e "   - Cần quyền root để tool hoạt động đầy đủ"
    echo -e "   - File configs sẽ được lưu tại $INSTALL_DIR"
    echo ""
    
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    read -p "$(echo -e ${CYAN}Nhấn Enter để bắt đầu sử dụng tool...${NC})"
    
    # Run the tool
    cd "$INSTALL_DIR"
    node "$MAIN_SCRIPT"
}

# ============================================================================
# Main installation flow
# ============================================================================

main() {
    print_banner
    
    echo -e "${CYAN}Bắt đầu cài đặt ZKAY Roblox Rejoin Tool...${NC}"
    echo ""
    
    # Check environment
    check_termux
    
    # Update and install dependencies
    update_termux
    install_dependencies
    
    # Setup storage and API
    setup_storage
    setup_termux_api
    
    # Setup repository
    setup_repository
    
    # Install Node packages
    install_node_packages
    
    # Create global command
    create_global_command
    
    # Create shortcuts
    create_shortcut
    
    # Show final instructions
    print_instructions
}

# ============================================================================
# Error handling
# ============================================================================

trap 'echo -e "\n${RED}✗ Lỗi xảy ra! Cài đặt bị gián đoạn.${NC}"; exit 1' ERR

# ============================================================================
# Run main installation
# ============================================================================

main "$@"