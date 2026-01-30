# 🚀 ZKAY Roblox Rejoin - Termux Installer

One-line installer for ZKAY Roblox Rejoin Tool on Termux with global `zkayrj` command.

## ⚡ Quick Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh)
```

## ✨ Features

✅ **One-Command Installation** - Everything installed automatically  
✅ **Global Command** - Run `zkayrj` from anywhere  
✅ **Auto Dependencies** - All packages installed automatically  
✅ **Config Backup** - Configs preserved during updates  
✅ **Discord Integration** - Optional heartbeat monitoring  
✅ **Easy Updates** - Update with `zkayrj -u`  
✅ **Termux Widget** - Add shortcut to home screen  

## 📋 Requirements

- **Termux** (from F-Droid or GitHub, NOT Play Store)
- **Root Access** (to read cookies and launch apps)
- **Roblox App** (Global or VNG version)
- **Internet Connection**

### Optional:
- Termux:API (for wake lock)
- Termux:Widget (for home screen shortcuts)
- Discord Bot (for heartbeat feature)

## 🎯 Usage

### Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/install.sh)
```

### Run Tool

```bash
zkayrj              # Run rejoin tool
zkayrj -u           # Update tool
zkayrj -r           # Run with root
zkayrj -h           # Show help
```

### Commands

| Command | Description |
|---------|-------------|
| `zkayrj` | Run the rejoin tool (main menu) |
| `zkayrj -u` | Update to latest version |
| `zkayrj -r` | Run with root permissions |
| `zkayrj -c` | View current configs |
| `zkayrj -l` | View logs |
| `zkayrj clean` | Clean temporary files |
| `zkayrj -h` | Show help menu |

## 📦 What Gets Installed

### System Packages
- git, nodejs, python, sqlite
- termux-api, wget, curl

### Node.js Packages
- axios, cli-table3, figlet, boxen
- screenshot-desktop, discord.js, dotenv

### File Structure
```
~/zkay-rejoin/              # Installation directory
  ├── rejoin.cjs           # Main script
  ├── *.json               # Config files
  └── .env                 # Environment variables

$PREFIX/bin/zkayrj         # Global command

~/.shortcuts/ZKAY-Rejoin   # Widget shortcut
```

## ⚙️ Configuration

### 1. Setup Packages (Required)

```bash
zkayrj
# Choose option 2: Setup packages
# Select packages to configure
# Choose game and delay
```

### 2. Discord Heartbeat (Optional)

1. Create Discord bot at https://discord.com/developers/applications
2. Enable "MESSAGE CONTENT INTENT"
3. Create `.env` file:

```bash
cd ~/zkay-rejoin
cp .env.example .env
nano .env
```

4. Add your credentials:
```bash
DISCORD_BOT_TOKEN=your_token_here
HEARTBEAT_CHANNEL_ID=your_channel_id_here
```

### 3. Custom Package Prefix (Optional)

If using Roblox clones:

```bash
zkayrj
# Option 4: Configure package prefix
# Enter new prefix (e.g., com.robox)
```

## 🔄 Update

### Auto Update
```bash
zkayrj -u
```

### Manual Update
```bash
cd ~/zkay-rejoin
git pull origin main
npm install
```

## 🗑️ Uninstall

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ZKAY404/zkay-roblox-rejoin/main/uninstall.sh)
```

Or manually:
```bash
rm -rf ~/zkay-rejoin
rm -f $PREFIX/bin/zkayrj
rm -f ~/.shortcuts/ZKAY-Rejoin
```

## 🔧 Troubleshooting

### "Command not found: zkayrj"
```bash
echo 'export PATH=$PREFIX/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### "Permission denied"
```bash
chmod +x $PREFIX/bin/zkayrj
```

### "Cannot read Roblox cookie"
- Make sure you have root access
- Login to Roblox app first
- Run with root: `zkayrj -r`

### "Package not found"
- Install Roblox app (Global or VNG)
- Check package: `pm list packages | grep roblox`
- Configure prefix if using clone

### Discord bot not connecting
- Check token is correct
- Enable "MESSAGE CONTENT INTENT"
- Verify bot is in server
- Check channel ID is correct

## 💡 Tips

### Run in Background
```bash
pkg install tmux
tmux new -s rejoin
zkayrj
# Ctrl+B, D to detach
```

### Auto-start on Boot
```bash
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/start-rejoin.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
sleep 10
zkayrj &
EOF
chmod +x ~/.termux/boot/start-rejoin.sh
```

### View Logs
```bash
zkayrj -l
# or
tail -f ~/zkay-rejoin/rejoin.log
```

## 📊 Features Installed

| Feature | Description | Status |
|---------|-------------|--------|
| Multi-Instance | Run multiple Roblox accounts | ✅ |
| Auto Rejoin | Automatic rejoin on disconnect | ✅ |
| Discord Webhook | Status notifications | ✅ |
| Heartbeat Monitor | Discord-based alive check | ✅ |
| Package Manager | Easy package configuration | ✅ |
| Global Command | Run from anywhere | ✅ |
| Auto Update | One-command updates | ✅ |
| Config Backup | Automatic backup on update | ✅ |
| Widget Support | Home screen shortcuts | ✅ |
| Root Support | Full device access | ✅ |

## 📚 Documentation

- [Installation Guide](INSTALLATION_GUIDE.md) - Detailed installation instructions
- [Discord Integration](INTEGRATION_GUIDE.md) - Discord heartbeat setup
- [Quick Reference](QUICK_REFERENCE.cjs) - Code snippets for manual setup

## 🆘 Support

### Report Issues
https://github.com/ZKAY404/zkay-roblox-rejoin/issues

Include:
- Full error log
- Termux version: `termux-info`
- Node version: `node --version`
- OS info: `uname -a`

### Community
- Discord: discord.gg/37VJXk9hH4
- GitHub: https://github.com/ZKAY404/zkay-roblox-rejoin

## 📝 Changelog

### v1.0.0 (Initial Release)
- ✨ One-line installer
- ✨ Global `zkayrj` command
- ✨ Automatic dependency installation
- ✨ Config backup/restore on update
- ✨ Discord heartbeat support
- ✨ Termux Widget integration
- ✨ Multiple update methods
- ✨ Comprehensive error handling

## 📜 License

MIT License - See LICENSE file

## 👨‍💻 Author

**ZKAY404 / The Real Dawn**
- GitHub: [@ZKAY404](https://github.com/ZKAY404)
- Repository: [zkay-roblox-rejoin](https://github.com/ZKAY404/zkay-roblox-rejoin)

## 🙏 Acknowledgments

- Termux community
- Discord.js developers
- Node.js ecosystem
- All contributors and users

## ⚠️ Disclaimer

This tool is for educational purposes only. Using automation tools may violate Roblox Terms of Service. Use at your own risk.

---

**Made with ❤️ by ZKAY404**

**⭐ Star this repo if you find it useful!**
