# 🚀 ZKAY Roblox Rejoin - Installation Guide

Hướng dẫn cài đặt và sử dụng ZKAY Roblox Rejoin Tool cho Termux

## 📋 Yêu Cầu

### Bắt Buộc:
- ✅ Termux (tải từ F-Droid hoặc GitHub, **KHÔNG** từ Play Store)
- ✅ Ít nhất 1 app Roblox (Global hoặc VNG)
- ✅ Quyền Root (để đọc cookie và launch app)
- ✅ Kết nối Internet

### Tùy Chọn:
- 📱 Termux:API (để wake lock)
- 📱 Termux:Widget (để tạo shortcut trên home screen)
- 🤖 Discord Bot (để heartbeat checking)

## 🎯 Cài Đặt Nhanh (One-Line Install)

### Phương Pháp 1: Từ GitHub (Khuyên dùng)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh)
```

### Phương Pháp 2: Từ Local File

```bash
# Tải file installer
curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh -o install.sh

# Cấp quyền thực thi
chmod +x install.sh

# Chạy installer
./install.sh
```

## 📦 Cài Đặt Chi Tiết (Manual)

### Bước 1: Cập nhật Termux

```bash
pkg update -y
pkg upgrade -y
```

### Bước 2: Cài đặt Dependencies

```bash
# Cài các package cần thiết
pkg install -y git nodejs python sqlite termux-api wget curl

# Kiểm tra Node.js đã cài đặt
node --version
npm --version
```

### Bước 3: Clone Repository

```bash
# Clone repository
git clone https://github.com/ZKAY404/zkay-roblox-rejoin.git

# Di chuyển vào thư mục
cd zkay-roblox-rejoin

# Cài npm packages
npm install
```

### Bước 4: Tạo Global Command (Tùy chọn)

```bash
# Tạo script wrapper
cat > $PREFIX/bin/zkayrj << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/zkay-roblox-rejoin
node rejoin.cjs "$@"
EOF

# Cấp quyền thực thi
chmod +x $PREFIX/bin/zkayrj
```

### Bước 5: Setup Storage Permissions

```bash
# Cấp quyền truy cập storage
termux-setup-storage
```

## ⚙️ Cấu Hình

### Setup Packages (Bắt Buộc)

```bash
# Chạy tool
zkayrj

# Chọn option 2: Setup packages
# Chọn packages muốn setup (0 để setup tất cả)
# Chọn game và delay cho mỗi package
```

### Cấu Hình Discord Heartbeat (Tùy chọn)

#### 1. Tạo Discord Bot

1. Truy cập https://discord.com/developers/applications
2. Click "New Application"
3. Đặt tên cho bot (VD: "Roblox Heartbeat Bot")
4. Vào tab "Bot"
5. Click "Reset Token" và copy token
6. **QUAN TRỌNG**: Bật "MESSAGE CONTENT INTENT"
7. Save changes

#### 2. Invite Bot Vào Server

Tạo invite URL:
```
https://discord.com/api/oauth2/authorize?client_id=YOUR_CLIENT_ID&permissions=66560&scope=bot
```

Thay `YOUR_CLIENT_ID` bằng Application ID của bạn (tìm ở tab "General Information")

#### 3. Lấy Channel ID

1. Bật Developer Mode: Discord Settings > Advanced > Developer Mode
2. Right-click vào channel muốn dùng > Copy ID

#### 4. Cấu Hình Environment Variables

```bash
# Di chuyển vào thư mục installation
cd ~/zkay-rejoin

# Copy file .env.example
cp .env.example .env

# Chỉnh sửa file .env
nano .env
```

Nội dung file .env:
```bash
DISCORD_BOT_TOKEN=your_bot_token_here
HEARTBEAT_CHANNEL_ID=your_channel_id_here
```

Lưu file (Ctrl+O, Enter, Ctrl+X)

### Cấu Hình Package Prefix (Tùy chọn)

Nếu bạn sử dụng Roblox clone với package name khác:

```bash
zkayrj
# Chọn option 4: Chỉnh prefix package Roblox
# Nhập prefix mới (VD: com.robox, con.roblx, etc.)
```

### Cấu Hình Activity (Tùy chọn)

Nếu app Roblox của bạn sử dụng activity khác:

```bash
zkayrj
# Chọn option 5: Chỉnh activity Roblox
# Nhập activity mới
```

## 🎮 Sử Dụng

### Chạy Tool

```bash
# Cách 1: Sử dụng global command
zkayrj

# Cách 2: Chạy trực tiếp
cd ~/zkay-rejoin
node rejoin.cjs

# Cách 3: Chạy với root
zkayrj -r
```

### Menu Chính

```
1. 🚀 Bắt đầu auto rejoin    - Chạy auto rejoin
2. ⚙️ Setup packages         - Cấu hình packages
3. ✏️ Chỉnh sửa config       - Sửa configs hiện có
4. 📦 Chỉnh prefix package   - Đổi prefix (nếu dùng clone)
5. 🎯 Chỉnh activity         - Đổi activity (nếu cần)
6. 🔗 Cấu hình webhook       - Setup Discord webhook
```

### Commands

```bash
zkayrj           # Chạy tool (menu chính)
zkayrj -u        # Cập nhật tool
zkayrj -r        # Chạy với root
zkayrj -c        # Xem configs
zkayrj -l        # Xem logs
zkayrj -h        # Hiển thị help
zkayrj clean     # Xóa files tạm
```

## 🔧 Xử Lý Sự Cố

### Lỗi: "Permission denied"

```bash
# Cấp quyền thực thi
chmod +x install.sh
chmod +x $PREFIX/bin/zkayrj
```

### Lỗi: "Command not found: zkayrj"

```bash
# Thêm vào PATH
echo 'export PATH=$PREFIX/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Lỗi: "Cannot find module 'axios'"

```bash
# Cài lại packages
cd ~/zkay-rejoin
npm install
```

### Lỗi: "No such file or directory: sqlite3"

```bash
# Cài sqlite
pkg install sqlite
```

### Lỗi: "Root required"

```bash
# Chạy với quyền root
su
zkayrj

# Hoặc
zkayrj -r
```

### Lỗi: "Cannot read Roblox cookie"

**Nguyên nhân**: Không có quyền root hoặc app Roblox chưa đăng nhập

**Giải pháp**:
1. Đảm bảo đã root device
2. Đăng nhập vào app Roblox
3. Chạy tool với root: `zkayrj -r`

### Lỗi: "Package not found"

**Nguyên nhân**: App Roblox chưa cài hoặc package name không đúng

**Giải pháp**:
1. Cài app Roblox (Global hoặc VNG)
2. Kiểm tra package name: `pm list packages | grep roblox`
3. Nếu dùng clone, cấu hình prefix: `zkayrj` > Option 4

### Discord Bot Không Kết Nối

**Kiểm tra**:
1. Token có đúng không
2. "MESSAGE CONTENT INTENT" đã bật chưa
3. Bot đã ở trong server chưa
4. Channel ID có đúng không

**Debug**:
```bash
# Kiểm tra file .env
cat ~/zkay-rejoin/.env

# Kiểm tra bot có chạy không
# Nhìn log khi start tool, tìm dòng:
# "✅ Discord Bot đã kết nối: BotName#1234"
```

## 📊 Cấu Trúc File

```
~/zkay-rejoin/
├── rejoin.cjs                    # Script chính
├── package.json                  # Node dependencies
├── multi_configs.json           # Configs cho các packages
├── webhook_config.json          # Webhook settings
├── package_prefix_config.json   # Package prefix config
├── activity_config.json         # Activity config
├── .env                         # Environment variables
├── .env.example                 # Template .env
└── node_modules/                # Node packages

$PREFIX/bin/
└── zkayrj                       # Global command

~/.shortcuts/
└── ZKAY-Rejoin                  # Termux Widget shortcut
```

## 🔄 Cập Nhật

### Cập Nhật Tool

```bash
# Sử dụng command
zkayrj -u

# Hoặc manual
cd ~/zkay-rejoin
git pull origin main
npm install
```

### Cập Nhật Configs

```bash
# Xem configs hiện tại
zkayrj -c

# Chỉnh sửa configs
zkayrj
# Chọn option 3: Chỉnh sửa config
```

## 🗑️ Gỡ Cài Đặt

### Sử Dụng Uninstaller

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/uninstall.sh)
```

### Manual Uninstall

```bash
# Backup configs (nếu cần)
cp ~/zkay-rejoin/multi_configs.json ~/multi_configs_backup.json
cp ~/zkay-rejoin/.env ~/.env_backup

# Xóa installation
rm -rf ~/zkay-rejoin

# Xóa global command
rm -f $PREFIX/bin/zkayrj

# Xóa shortcuts
rm -f ~/.shortcuts/ZKAY-Rejoin
```

## 💡 Tips & Tricks

### Chạy Nền (Background)

```bash
# Sử dụng tmux
pkg install tmux
tmux new -s rejoin
zkayrj
# Ctrl+B, D để detach

# Attach lại
tmux attach -t rejoin
```

### Chạy Khi Khởi Động

```bash
# Tạo boot script
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/start-rejoin.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
sleep 10
zkayrj &
EOF

chmod +x ~/.termux/boot/start-rejoin.sh

# Cài Termux:Boot app để kích hoạt
```

### Monitor Resources

```bash
# CPU và RAM
top

# Disk usage
df -h

# Process
ps aux | grep node
```

### Logs

```bash
# Xem logs real-time
zkayrj -l

# Hoặc
tail -f ~/zkay-rejoin/rejoin.log
```

### Backup Configs

```bash
# Backup định kỳ
cd ~/zkay-rejoin
cp multi_configs.json ~/storage/downloads/multi_configs_backup.json
cp .env ~/storage/downloads/.env_backup
```

## 🆘 Hỗ Trợ

### Báo Lỗi

Nếu gặp lỗi, vui lòng tạo issue tại:
https://github.com/ZKAY404/zkay-roblox-rejoin/issues

Kèm theo:
- Log lỗi đầy đủ
- Phiên bản Termux: `termux-info`
- Phiên bản Node: `node --version`
- OS version: `uname -a`

### Community

- GitHub: https://github.com/ZKAY404/zkay-roblox-rejoin
- Discord: discord.gg/37VJXk9hH4

## 📝 Changelog

### v1.0.0
- Initial release với installer
- Global command `zkayrj`
- Auto dependency installation
- Config backup/restore
- Discord heartbeat support

## 📜 License

MIT License - See LICENSE file for details

## 👨‍💻 Credits

- Developed by: ZKAY404 / The Real Dawn
- Repository: https://github.com/ZKAY404/zkay-roblox-rejoin

## 🙏 Cảm Ơn

Cảm ơn bạn đã sử dụng ZKAY Roblox Rejoin Tool!

---

**⚠️ Disclaimer**: Tool này chỉ dùng cho mục đích giáo dục. Sử dụng tool có thể vi phạm Terms of Service của Roblox. Sử dụng với trách nhiệm của riêng bạn.
