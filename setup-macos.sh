#!/bin/bash
#
# Strix Security Testing Framework - macOS Setup Script
# Version: 1.0
# Last Updated: 2025-11-08
#
# LEGAL NOTICE:
# This tool is for AUTHORIZED security testing only.
# Only test systems you OWN or have WRITTEN PERMISSION to test.
# Unauthorized access to computer systems is ILLEGAL.
#
# Use this responsibly for:
# - Testing your own applications
# - Authorized penetration testing engagements
# - Bug bounty programs with explicit scope
# - Educational purposes on your own systems
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only!"
    exit 1
fi

print_header "Strix Security Testing Framework - macOS Setup"

echo -e "${YELLOW}"
cat << "EOF"
  ____  _        _
 / ___|| |_ _ __(_)_  __
 \___ \| __| '__| \ \/ /
  ___) | |_| |  | |>  <
 |____/ \__|_|  |_/_/\_\

 AI-Powered Security Testing
EOF
echo -e "${NC}"

print_warning "IMPORTANT LEGAL NOTICE"
echo ""
echo "This tool is for AUTHORIZED security testing ONLY."
echo "You MUST have explicit permission to test any system."
echo ""
echo "Legal use cases:"
echo "  ✓ Your own applications and infrastructure"
echo "  ✓ Bug bounty programs (within scope)"
echo "  ✓ Authorized penetration testing engagements"
echo "  ✓ Educational/research on systems you own"
echo ""
echo "ILLEGAL activities:"
echo "  ✗ Testing systems without authorization"
echo "  ✗ Accessing data you're not authorized to access"
echo "  ✗ Causing disruption or damage"
echo ""
read -p "Do you understand and agree to use this tool legally? (yes/no): " agreement

if [[ "$agreement" != "yes" ]]; then
    print_error "Setup cancelled. You must agree to use this tool legally."
    exit 1
fi

# Step 1: Check for Homebrew
print_header "Step 1: Checking Homebrew"

if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
    brew update
fi

# Step 2: Install Docker Desktop
print_header "Step 2: Installing Docker Desktop"

if ! command -v docker &> /dev/null; then
    print_info "Installing Docker Desktop..."
    brew install --cask docker

    print_warning "Please start Docker Desktop manually:"
    echo "  1. Open Applications folder"
    echo "  2. Launch Docker.app"
    echo "  3. Wait for Docker to start (whale icon in menu bar)"
    echo ""
    read -p "Press Enter once Docker Desktop is running..."

    # Wait for Docker daemon to be ready
    print_info "Waiting for Docker daemon..."
    timeout=60
    while ! docker info &> /dev/null; do
        if [ $timeout -le 0 ]; then
            print_error "Docker failed to start. Please start Docker Desktop manually and run this script again."
            exit 1
        fi
        sleep 2
        timeout=$((timeout - 2))
    done

    print_success "Docker Desktop is running"
else
    print_success "Docker already installed"

    # Check if Docker daemon is running
    if ! docker info &> /dev/null; then
        print_warning "Docker daemon is not running. Please start Docker Desktop."
        open -a Docker
        print_info "Waiting for Docker to start..."
        timeout=60
        while ! docker info &> /dev/null; do
            if [ $timeout -le 0 ]; then
                print_error "Docker failed to start."
                exit 1
            fi
            sleep 2
            timeout=$((timeout - 2))
        done
    fi
    print_success "Docker daemon is running"
fi

# Step 3: Install Python 3.12+
print_header "Step 3: Installing Python 3.12+"

if command -v python3.12 &> /dev/null; then
    print_success "Python 3.12 already installed"
elif command -v python3 &> /dev/null; then
    python_version=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
    if (( $(echo "$python_version >= 3.12" | bc -l) )); then
        print_success "Python $python_version already installed"
    else
        print_info "Upgrading Python to 3.12..."
        brew install python@3.12
    fi
else
    print_info "Installing Python 3.12..."
    brew install python@3.12
fi

# Ensure python3 points to 3.12+
if command -v python3.12 &> /dev/null; then
    PYTHON_CMD="python3.12"
elif command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
else
    print_error "Python installation failed"
    exit 1
fi

print_success "Using Python: $($PYTHON_CMD --version)"

# Step 4: Install pipx
print_header "Step 4: Installing pipx"

if ! command -v pipx &> /dev/null; then
    print_info "Installing pipx..."
    brew install pipx
    pipx ensurepath

    # Add pipx to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    print_success "pipx installed"
else
    print_success "pipx already installed"
fi

# Step 5: Install Strix
print_header "Step 5: Installing Strix"

if pipx list | grep -q "strix-agent"; then
    print_warning "Strix already installed. Upgrading..."
    pipx upgrade strix-agent
else
    print_info "Installing Strix..."
    pipx install strix-agent
fi

print_success "Strix installed successfully"

# Step 6: Pull Docker image
print_header "Step 6: Pulling Strix Docker Sandbox Image"

print_info "Downloading security testing environment (~3-4 GB)..."
print_info "This may take several minutes depending on your connection..."

if docker pull ghcr.io/usestrix/strix-sandbox:latest; then
    print_success "Docker image downloaded successfully"
else
    print_error "Failed to pull Docker image"
    exit 1
fi

# Step 7: Configure LLM Provider
print_header "Step 7: Configuring AI Provider"

echo "Strix requires an AI model to perform security testing."
echo ""
echo "Options:"
echo "  1. OpenAI (GPT-4, GPT-3.5) - Most tested, recommended"
echo "  2. Anthropic (Claude) - Excellent for security analysis"
echo "  3. Local (Ollama) - Free, but requires powerful hardware"
echo "  4. Skip for now - Configure later manually"
echo ""
read -p "Select option (1-4): " llm_choice

case $llm_choice in
    1)
        print_info "OpenAI selected"
        echo ""
        echo "Get your API key from: https://platform.openai.com/api-keys"
        echo ""
        read -p "Enter your OpenAI API key (or press Enter to skip): " api_key

        if [[ -n "$api_key" ]]; then
            # Add to shell profile
            SHELL_PROFILE=""
            if [[ -f "$HOME/.zshrc" ]]; then
                SHELL_PROFILE="$HOME/.zshrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                SHELL_PROFILE="$HOME/.bash_profile"
            fi

            if [[ -n "$SHELL_PROFILE" ]]; then
                echo "" >> "$SHELL_PROFILE"
                echo "# Strix Configuration" >> "$SHELL_PROFILE"
                echo "export STRIX_LLM=\"openai/gpt-4\"" >> "$SHELL_PROFILE"
                echo "export LLM_API_KEY=\"$api_key\"" >> "$SHELL_PROFILE"

                export STRIX_LLM="openai/gpt-4"
                export LLM_API_KEY="$api_key"

                print_success "Configuration saved to $SHELL_PROFILE"
            else
                print_warning "Could not detect shell profile. Set these manually:"
                echo "export STRIX_LLM=\"openai/gpt-4\""
                echo "export LLM_API_KEY=\"$api_key\""
            fi
        fi
        ;;
    2)
        print_info "Anthropic Claude selected"
        echo ""
        echo "Get your API key from: https://console.anthropic.com/"
        echo ""
        read -p "Enter your Anthropic API key (or press Enter to skip): " api_key

        if [[ -n "$api_key" ]]; then
            SHELL_PROFILE=""
            if [[ -f "$HOME/.zshrc" ]]; then
                SHELL_PROFILE="$HOME/.zshrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                SHELL_PROFILE="$HOME/.bash_profile"
            fi

            if [[ -n "$SHELL_PROFILE" ]]; then
                echo "" >> "$SHELL_PROFILE"
                echo "# Strix Configuration" >> "$SHELL_PROFILE"
                echo "export STRIX_LLM=\"anthropic/claude-sonnet-4-5-20250929\"" >> "$SHELL_PROFILE"
                echo "export LLM_API_KEY=\"$api_key\"" >> "$SHELL_PROFILE"

                export STRIX_LLM="anthropic/claude-sonnet-4-5-20250929"
                export LLM_API_KEY="$api_key"

                print_success "Configuration saved to $SHELL_PROFILE"
            fi
        fi
        ;;
    3)
        print_info "Installing Ollama for local AI models..."

        if ! command -v ollama &> /dev/null; then
            brew install ollama
        fi

        print_info "Starting Ollama service..."
        brew services start ollama
        sleep 3

        print_info "Downloading Llama 3.1 70B model (this is large!)..."
        ollama pull llama3.1:70b

        SHELL_PROFILE=""
        if [[ -f "$HOME/.zshrc" ]]; then
            SHELL_PROFILE="$HOME/.zshrc"
        elif [[ -f "$HOME/.bash_profile" ]]; then
            SHELL_PROFILE="$HOME/.bash_profile"
        fi

        if [[ -n "$SHELL_PROFILE" ]]; then
            echo "" >> "$SHELL_PROFILE"
            echo "# Strix Configuration" >> "$SHELL_PROFILE"
            echo "export STRIX_LLM=\"ollama/llama3.1:70b\"" >> "$SHELL_PROFILE"
            echo "export LLM_API_BASE=\"http://localhost:11434\"" >> "$SHELL_PROFILE"
            echo "export LLM_API_KEY=\"dummy\"" >> "$SHELL_PROFILE"

            export STRIX_LLM="ollama/llama3.1:70b"
            export LLM_API_BASE="http://localhost:11434"
            export LLM_API_KEY="dummy"

            print_success "Ollama configured"
        fi
        ;;
    4)
        print_warning "Skipping AI configuration. Set these environment variables later:"
        echo "export STRIX_LLM=\"openai/gpt-4\""
        echo "export LLM_API_KEY=\"your-api-key\""
        ;;
    *)
        print_warning "Invalid option. Skipping AI configuration."
        ;;
esac

# Step 8: Verification
print_header "Step 8: Verifying Installation"

print_info "Checking installations..."

# Check Docker
if docker info &> /dev/null; then
    print_success "Docker: OK"
else
    print_error "Docker: FAILED"
fi

# Check Python
if command -v $PYTHON_CMD &> /dev/null; then
    print_success "Python: OK ($($PYTHON_CMD --version))"
else
    print_error "Python: FAILED"
fi

# Check pipx
if command -v pipx &> /dev/null; then
    print_success "pipx: OK"
else
    print_error "pipx: FAILED"
fi

# Check Strix
if command -v strix &> /dev/null || pipx list | grep -q "strix-agent"; then
    print_success "Strix: OK"
else
    print_error "Strix: FAILED"
fi

# Check Docker image
if docker images | grep -q "strix-sandbox"; then
    print_success "Docker Image: OK"
else
    print_error "Docker Image: FAILED"
fi

# Check LLM configuration
if [[ -n "$STRIX_LLM" ]] && [[ -n "$LLM_API_KEY" ]]; then
    print_success "AI Provider: Configured ($STRIX_LLM)"
else
    print_warning "AI Provider: Not configured (set STRIX_LLM and LLM_API_KEY)"
fi

# Final instructions
print_header "Installation Complete!"

echo -e "${GREEN}"
cat << "EOF"
╔════════════════════════════════════════════════════╗
║                                                    ║
║   ✓ Strix is ready for security testing!          ║
║                                                    ║
╚════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "Next steps:"
echo ""
echo "1. Restart your terminal to load environment variables"
echo "   or run: source ~/.zshrc"
echo ""
echo "2. Run your first security scan:"
echo "   strix --target ./your-app-directory"
echo ""
echo "3. For web applications:"
echo "   strix --target https://your-app.com"
echo ""
echo "4. For GitHub repositories:"
echo "   strix --target https://github.com/yourorg/yourrepo"
echo ""

print_warning "IMPORTANT REMINDERS:"
echo ""
echo "• Only test systems you OWN or have PERMISSION to test"
echo "• Check bug bounty programs for legal scope:"
echo "  - HackerOne: https://hackerone.com/bug-bounty-programs"
echo "  - Bugcrowd: https://bugcrowd.com/programs"
echo "  - Apple: https://security.apple.com/"
echo "  - Microsoft: https://msrc.microsoft.com/engage"
echo "  - Google: https://bughunters.google.com/"
echo ""
echo "• Unauthorized testing is ILLEGAL and can result in:"
echo "  - Criminal charges"
echo "  - Civil lawsuits"
echo "  - Fines and imprisonment"
echo ""
echo "• Use Strix responsibly and ethically!"
echo ""

print_info "Documentation:"
echo "  - Setup Guide: README.md"
echo "  - Architecture: CLAUDE.md"
echo "  - Crash Course: CRASH_COURSE.md"
echo "  - Responsible Testing: RESPONSIBLE_SECURITY_TESTING.md"
echo ""
print_info "Need help? Join Discord: https://discord.gg/YjKFvEZSdZ"
echo ""

print_success "Setup complete! Happy (legal) hacking! 🦉"
