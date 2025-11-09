# Strix Security Testing Framework - Windows Setup Script
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
# Run this script with: PowerShell -ExecutionPolicy Bypass -File setup-windows.ps1

# Require Administrator privileges
#Requires -RunAsAdministrator

# Colors for output
$ErrorColor = "Red"
$SuccessColor = "Green"
$WarningColor = "Yellow"
$InfoColor = "Cyan"

function Print-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Print-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Print-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

# ASCII Art
Print-Header "Strix Security Testing Framework - Windows Setup"

Write-Host @"
  ____  _        _
 / ___|| |_ _ __(_)_  __
 \___ \| __| '__| \ \/ /
  ___) | |_| |  | |>  <
 |____/ \__|_|  |_/_/\_\

 AI-Powered Security Testing
"@ -ForegroundColor Yellow

Print-Warning "IMPORTANT LEGAL NOTICE"
Write-Host ""
Write-Host "This tool is for AUTHORIZED security testing ONLY."
Write-Host "You MUST have explicit permission to test any system."
Write-Host ""
Write-Host "Legal use cases:"
Write-Host "  ✓ Your own applications and infrastructure"
Write-Host "  ✓ Bug bounty programs (within scope)"
Write-Host "  ✓ Authorized penetration testing engagements"
Write-Host "  ✓ Educational/research on systems you own"
Write-Host ""
Write-Host "ILLEGAL activities:"
Write-Host "  ✗ Testing systems without authorization"
Write-Host "  ✗ Accessing data you're not authorized to access"
Write-Host "  ✗ Causing disruption or damage"
Write-Host ""
$agreement = Read-Host "Do you understand and agree to use this tool legally? (yes/no)"

if ($agreement -ne "yes") {
    Print-Error "Setup cancelled. You must agree to use this tool legally."
    exit 1
}

# Step 1: Check for Winget (Windows Package Manager)
Print-Header "Step 1: Checking Windows Package Manager"

if (Get-Command winget -ErrorAction SilentlyContinue) {
    Print-Success "Winget already installed"
} else {
    Print-Warning "Winget not found. Installing..."
    Print-Info "Downloading from Microsoft Store..."

    # Try to install via PowerShell
    try {
        Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
        Print-Success "Winget installed"
    } catch {
        Print-Error "Failed to install Winget automatically."
        Print-Info "Please install manually from Microsoft Store: 'App Installer'"
        Print-Info "Then run this script again."
        exit 1
    }
}

# Step 2: Install Docker Desktop
Print-Header "Step 2: Installing Docker Desktop"

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Print-Success "Docker already installed"
} else {
    Print-Info "Installing Docker Desktop..."
    Print-Warning "This will download ~500MB and may take a few minutes..."

    try {
        winget install Docker.DockerDesktop --silent --accept-source-agreements --accept-package-agreements
        Print-Success "Docker Desktop installed"
    } catch {
        Print-Error "Failed to install Docker Desktop via winget"
        Print-Info "Please install manually from: https://www.docker.com/products/docker-desktop/"
        exit 1
    }

    Print-Warning "Docker Desktop requires a system restart to complete installation."
    $restart = Read-Host "Restart now? (yes/no)"
    if ($restart -eq "yes") {
        Restart-Computer
    } else {
        Print-Warning "Please restart your computer and run this script again after restart."
        exit 0
    }
}

# Check if Docker is running
Print-Info "Checking Docker daemon..."
$dockerRunning = $false
$attempts = 0
$maxAttempts = 30

while (-not $dockerRunning -and $attempts -lt $maxAttempts) {
    try {
        docker info 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $dockerRunning = $true
        }
    } catch {
        # Docker not ready
    }

    if (-not $dockerRunning) {
        if ($attempts -eq 0) {
            Print-Warning "Docker daemon is not running. Starting Docker Desktop..."
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -ErrorAction SilentlyContinue
        }
        Start-Sleep -Seconds 2
        $attempts++
    }
}

if ($dockerRunning) {
    Print-Success "Docker daemon is running"
} else {
    Print-Error "Docker daemon failed to start"
    Print-Info "Please start Docker Desktop manually from the Start menu"
    Print-Info "Then run this script again"
    exit 1
}

# Step 3: Install Python 3.12+
Print-Header "Step 3: Installing Python 3.12+"

$pythonInstalled = $false
try {
    $pythonVersion = (python --version 2>&1) -replace "Python ", ""
    if ([version]$pythonVersion -ge [version]"3.12") {
        Print-Success "Python $pythonVersion already installed"
        $pythonInstalled = $true
    }
} catch {
    # Python not found or version check failed
}

if (-not $pythonInstalled) {
    Print-Info "Installing Python 3.12..."
    try {
        winget install Python.Python.3.12 --silent --accept-source-agreements --accept-package-agreements
        Print-Success "Python 3.12 installed"

        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Print-Error "Failed to install Python via winget"
        Print-Info "Please install manually from: https://www.python.org/downloads/"
        Print-Warning "Make sure to check 'Add Python to PATH' during installation"
        exit 1
    }
}

# Verify Python installation
try {
    $pythonVersion = (python --version 2>&1) -replace "Python ", ""
    Print-Success "Using Python: $pythonVersion"
} catch {
    Print-Error "Python installation verification failed"
    Print-Info "Please add Python to PATH and run this script again"
    exit 1
}

# Step 4: Install pipx
Print-Header "Step 4: Installing pipx"

if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Print-Success "pipx already installed"
} else {
    Print-Info "Installing pipx..."
    python -m pip install --user pipx
    python -m pipx ensurepath

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Print-Success "pipx installed"
    Print-Warning "You may need to restart your terminal for pipx to work"
}

# Step 5: Install Strix
Print-Header "Step 5: Installing Strix"

try {
    $strixInstalled = pipx list | Select-String "strix-agent"
    if ($strixInstalled) {
        Print-Warning "Strix already installed. Upgrading..."
        pipx upgrade strix-agent
    } else {
        Print-Info "Installing Strix..."
        pipx install strix-agent
    }
    Print-Success "Strix installed successfully"
} catch {
    Print-Error "Failed to install Strix"
    Print-Info "Try running: pipx install strix-agent manually"
    exit 1
}

# Step 6: Pull Docker image
Print-Header "Step 6: Pulling Strix Docker Sandbox Image"

Print-Info "Downloading security testing environment (~3-4 GB)..."
Print-Info "This may take several minutes depending on your connection..."

try {
    docker pull ghcr.io/usestrix/strix-sandbox:latest
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Docker image downloaded successfully"
    } else {
        throw "Docker pull failed"
    }
} catch {
    Print-Error "Failed to pull Docker image"
    Print-Info "Check your internet connection and Docker installation"
    exit 1
}

# Step 7: Configure LLM Provider
Print-Header "Step 7: Configuring AI Provider"

Write-Host "Strix requires an AI model to perform security testing."
Write-Host ""
Write-Host "Options:"
Write-Host "  1. OpenAI (GPT-4, GPT-3.5) - Most tested, recommended"
Write-Host "  2. Anthropic (Claude) - Excellent for security analysis"
Write-Host "  3. Local (Ollama) - Free, but requires powerful hardware"
Write-Host "  4. Skip for now - Configure later manually"
Write-Host ""
$llmChoice = Read-Host "Select option (1-4)"

switch ($llmChoice) {
    "1" {
        Print-Info "OpenAI selected"
        Write-Host ""
        Write-Host "Get your API key from: https://platform.openai.com/api-keys"
        Write-Host ""
        $apiKey = Read-Host "Enter your OpenAI API key (or press Enter to skip)"

        if ($apiKey) {
            [System.Environment]::SetEnvironmentVariable('STRIX_LLM', 'openai/gpt-4', 'User')
            [System.Environment]::SetEnvironmentVariable('LLM_API_KEY', $apiKey, 'User')

            $env:STRIX_LLM = 'openai/gpt-4'
            $env:LLM_API_KEY = $apiKey

            Print-Success "Configuration saved to user environment variables"
        }
    }
    "2" {
        Print-Info "Anthropic Claude selected"
        Write-Host ""
        Write-Host "Get your API key from: https://console.anthropic.com/"
        Write-Host ""
        $apiKey = Read-Host "Enter your Anthropic API key (or press Enter to skip)"

        if ($apiKey) {
            [System.Environment]::SetEnvironmentVariable('STRIX_LLM', 'anthropic/claude-sonnet-4-5-20250929', 'User')
            [System.Environment]::SetEnvironmentVariable('LLM_API_KEY', $apiKey, 'User')

            $env:STRIX_LLM = 'anthropic/claude-sonnet-4-5-20250929'
            $env:LLM_API_KEY = $apiKey

            Print-Success "Configuration saved to user environment variables"
        }
    }
    "3" {
        Print-Info "Installing Ollama for local AI models..."

        if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
            Print-Info "Downloading Ollama..."
            $ollamaUrl = "https://ollama.ai/download/OllamaSetup.exe"
            $ollamaInstaller = "$env:TEMP\OllamaSetup.exe"

            Invoke-WebRequest -Uri $ollamaUrl -OutFile $ollamaInstaller
            Start-Process -FilePath $ollamaInstaller -Wait
            Remove-Item $ollamaInstaller

            # Refresh PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }

        Print-Info "Downloading Llama 3.1 70B model (this is large!)..."
        ollama pull llama3.1:70b

        [System.Environment]::SetEnvironmentVariable('STRIX_LLM', 'ollama/llama3.1:70b', 'User')
        [System.Environment]::SetEnvironmentVariable('LLM_API_BASE', 'http://localhost:11434', 'User')
        [System.Environment]::SetEnvironmentVariable('LLM_API_KEY', 'dummy', 'User')

        $env:STRIX_LLM = 'ollama/llama3.1:70b'
        $env:LLM_API_BASE = 'http://localhost:11434'
        $env:LLM_API_KEY = 'dummy'

        Print-Success "Ollama configured"
    }
    "4" {
        Print-Warning "Skipping AI configuration. Set these environment variables later:"
        Write-Host "`$env:STRIX_LLM = 'openai/gpt-4'"
        Write-Host "`$env:LLM_API_KEY = 'your-api-key'"
    }
    default {
        Print-Warning "Invalid option. Skipping AI configuration."
    }
}

# Step 8: Configure Windows Defender exclusions (optional)
Print-Header "Step 8: Configuring Security Exclusions (Optional)"

Write-Host "Strix uses security tools that may trigger Windows Defender."
Write-Host "Would you like to add Docker and Strix to exclusions?"
$addExclusions = Read-Host "(yes/no)"

if ($addExclusions -eq "yes") {
    Print-Info "Adding exclusions to Windows Defender..."

    try {
        # Add Docker exclusion
        Add-MpPreference -ExclusionPath "C:\Program Files\Docker" -ErrorAction SilentlyContinue

        # Add pipx/Strix exclusion
        $pipxPath = "$env:USERPROFILE\.local\pipx"
        Add-MpPreference -ExclusionPath $pipxPath -ErrorAction SilentlyContinue

        Print-Success "Exclusions added"
    } catch {
        Print-Warning "Failed to add exclusions. You may need to add them manually in Windows Security."
    }
}

# Step 9: Verification
Print-Header "Step 9: Verifying Installation"

Print-Info "Checking installations..."

# Check Docker
try {
    docker info 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Print-Success "Docker: OK"
    } else {
        Print-Error "Docker: FAILED"
    }
} catch {
    Print-Error "Docker: FAILED"
}

# Check Python
try {
    $pythonVersion = python --version 2>&1
    Print-Success "Python: OK ($pythonVersion)"
} catch {
    Print-Error "Python: FAILED"
}

# Check pipx
if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Print-Success "pipx: OK"
} else {
    Print-Error "pipx: FAILED"
}

# Check Strix
try {
    $strixCheck = pipx list | Select-String "strix-agent"
    if ($strixCheck) {
        Print-Success "Strix: OK"
    } else {
        Print-Error "Strix: FAILED"
    }
} catch {
    Print-Error "Strix: FAILED"
}

# Check Docker image
try {
    $imageCheck = docker images | Select-String "strix-sandbox"
    if ($imageCheck) {
        Print-Success "Docker Image: OK"
    } else {
        Print-Error "Docker Image: FAILED"
    }
} catch {
    Print-Error "Docker Image: FAILED"
}

# Check LLM configuration
if ($env:STRIX_LLM -and $env:LLM_API_KEY) {
    Print-Success "AI Provider: Configured ($env:STRIX_LLM)"
} else {
    Print-Warning "AI Provider: Not configured (set STRIX_LLM and LLM_API_KEY)"
}

# Final instructions
Print-Header "Installation Complete!"

Write-Host @"
╔════════════════════════════════════════════════════╗
║                                                    ║
║   ✓ Strix is ready for security testing!          ║
║                                                    ║
╚════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Print-Info "Next steps:"
Write-Host ""
Write-Host "1. Restart PowerShell to load environment variables"
Write-Host "   or run: `$env:Path = [System.Environment]::GetEnvironmentVariable('Path','User')"
Write-Host ""
Write-Host "2. Run your first security scan:"
Write-Host "   strix --target .\your-app-directory"
Write-Host ""
Write-Host "3. For web applications:"
Write-Host "   strix --target https://your-app.com"
Write-Host ""
Write-Host "4. For GitHub repositories:"
Write-Host "   strix --target https://github.com/yourorg/yourrepo"
Write-Host ""

Print-Warning "IMPORTANT REMINDERS:"
Write-Host ""
Write-Host "• Only test systems you OWN or have PERMISSION to test"
Write-Host "• Check bug bounty programs for legal scope:"
Write-Host "  - HackerOne: https://hackerone.com/bug-bounty-programs"
Write-Host "  - Bugcrowd: https://bugcrowd.com/programs"
Write-Host "  - Apple: https://security.apple.com/"
Write-Host "  - Microsoft: https://msrc.microsoft.com/engage"
Write-Host "  - Google: https://bughunters.google.com/"
Write-Host ""
Write-Host "• Unauthorized testing is ILLEGAL and can result in:"
Write-Host "  - Criminal charges"
Write-Host "  - Civil lawsuits"
Write-Host "  - Fines and imprisonment"
Write-Host ""
Write-Host "• Use Strix responsibly and ethically!"
Write-Host ""

Print-Info "Documentation:"
Write-Host "  - Setup Guide: README.md"
Write-Host "  - Architecture: CLAUDE.md"
Write-Host "  - Crash Course: CRASH_COURSE.md"
Write-Host "  - Responsible Testing: RESPONSIBLE_SECURITY_TESTING.md"
Write-Host ""
Print-Info "Need help? Join Discord: https://discord.gg/YjKFvEZSdZ"
Write-Host ""

Print-Success "Setup complete! Happy (legal) hacking! 🦉"
