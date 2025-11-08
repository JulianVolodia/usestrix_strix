# Strix Crash Course: Windows & Cloud Deployment Guide

**Last Updated:** 2025-11-08
**Version:** 0.3.2
**Difficulty:** Beginner to Intermediate

---

## Table of Contents

1. [Quick Overview](#quick-overview)
2. [Windows Setup Guide](#windows-setup-guide)
3. [Cloud Deployment Guide](#cloud-deployment-guide)
4. [First Security Scan](#first-security-scan)
5. [Common Use Cases](#common-use-cases)
6. [Troubleshooting](#troubleshooting)
7. [Best Practices](#best-practices)

---

## Quick Overview

### What is Strix?

Strix is an AI-powered penetration testing tool that:
- ✅ Runs autonomous security scans on your applications
- ✅ Validates vulnerabilities with actual proof-of-concepts
- ✅ Works with local code, GitHub repos, or live web apps
- ✅ Uses AI (GPT, Claude, or local models) to find security issues
- ✅ Provides actionable security reports

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 8 GB | 16 GB+ |
| **CPU** | 4 cores | 8+ cores |
| **Disk** | 20 GB free | 50 GB+ free |
| **OS** | Windows 10/11, Linux | Windows 11, Ubuntu 22.04+ |
| **Docker** | 4 GB RAM allocated | 8 GB+ RAM allocated |

### Time Investment

- **Setup Time:** 15-30 minutes
- **First Scan:** 10-60 minutes (depends on target size)
- **Learning Curve:** 1-2 hours to basic proficiency

---

## Windows Setup Guide

### Step 1: Install Prerequisites

#### 1.1 Install Docker Desktop for Windows

**Download & Install:**
1. Visit: https://www.docker.com/products/docker-desktop/
2. Download Docker Desktop for Windows
3. Run the installer
4. **Important:** Enable WSL 2 backend when prompted
5. Restart your computer when installation completes

**Configure Docker:**
1. Open Docker Desktop
2. Go to Settings → Resources
3. Set **Memory** to at least 8 GB (if available)
4. Set **CPUs** to at least 4 cores
5. Click "Apply & Restart"

**Verify Installation:**
```powershell
# Open PowerShell and run:
docker --version
# Should show: Docker version 24.x.x or higher

docker ps
# Should show empty list (no errors)
```

#### 1.2 Install Python 3.12+

**Option A: Using Windows Store (Recommended)**
1. Open Microsoft Store
2. Search for "Python 3.12"
3. Click "Get" to install
4. Verify installation:
```powershell
python --version
# Should show: Python 3.12.x or higher
```

**Option B: Using Official Installer**
1. Visit: https://www.python.org/downloads/
2. Download Python 3.12.x for Windows
3. Run installer
4. ✅ **IMPORTANT:** Check "Add Python to PATH"
5. Click "Install Now"
6. Verify installation as above

#### 1.3 Install pipx (Package Manager)

```powershell
# Open PowerShell as Administrator
python -m pip install --user pipx
python -m pipx ensurepath

# Close and reopen PowerShell, then verify:
pipx --version
```

#### 1.4 Install Git (Optional, but recommended)

1. Visit: https://git-scm.com/download/win
2. Download and install Git for Windows
3. Use default settings during installation
4. Verify:
```powershell
git --version
```

### Step 2: Install Strix

```powershell
# Install Strix using pipx
pipx install strix-agent

# Verify installation
strix --help
```

**If you get "command not found":**
```powershell
# Add pipx bin directory to PATH manually
# The path is usually: C:\Users\YourUsername\AppData\Local\pipx\pipx\venv\Scripts

# Or use full path:
python -m pipx run strix-agent --help
```

### Step 3: Configure AI Provider

You need an API key from one of these providers:

#### Option A: OpenAI (GPT Models)

1. Visit: https://platform.openai.com/api-keys
2. Sign up / Log in
3. Create a new API key
4. Copy the key

**Set Environment Variables (PowerShell):**
```powershell
# For current session only:
$env:STRIX_LLM = "openai/gpt-4"
$env:LLM_API_KEY = "sk-your-api-key-here"

# Permanent (adds to user profile):
[System.Environment]::SetEnvironmentVariable('STRIX_LLM', 'openai/gpt-4', 'User')
[System.Environment]::SetEnvironmentVariable('LLM_API_KEY', 'sk-your-api-key-here', 'User')

# Close and reopen PowerShell after permanent setup
```

**Set Environment Variables (CMD):**
```cmd
setx STRIX_LLM "openai/gpt-4"
setx LLM_API_KEY "sk-your-api-key-here"

REM Close and reopen CMD after this
```

#### Option B: Anthropic (Claude Models)

1. Visit: https://console.anthropic.com/
2. Sign up / Log in
3. Create an API key
4. Copy the key

```powershell
$env:STRIX_LLM = "anthropic/claude-sonnet-4-5-20250929"
$env:LLM_API_KEY = "sk-ant-your-api-key-here"
```

#### Option C: Local Models (Ollama - Free!)

**Install Ollama:**
1. Visit: https://ollama.ai/download
2. Download Ollama for Windows
3. Install and run Ollama
4. Pull a model:
```powershell
ollama pull llama3.1:70b
```

**Configure Strix:**
```powershell
$env:STRIX_LLM = "ollama/llama3.1:70b"
$env:LLM_API_BASE = "http://localhost:11434"
$env:LLM_API_KEY = "dummy"  # Ollama doesn't need a real key
```

### Step 4: Pull Strix Docker Image

This is a one-time setup that downloads the security testing environment (~3-4 GB):

```powershell
docker pull ghcr.io/usestrix/strix-sandbox:latest

# Verify the image was downloaded:
docker images | Select-String strix-sandbox
```

### Step 5: Run Your First Test Scan

#### Test on a Sample Web App

```powershell
# Scan a public demo site (safe for testing)
strix --target https://demo.testfire.net

# Or scan with specific instructions
strix --target https://demo.testfire.net --instruction "Focus on SQL injection and XSS vulnerabilities"
```

#### Test on Local Code

```powershell
# Scan a local directory
cd C:\Users\YourName\Projects\my-web-app
strix --target .
```

#### Test a GitHub Repository

```powershell
strix --target https://github.com/yourusername/your-repo
```

### Windows-Specific Tips

**1. PowerShell Execution Policy:**
If you get execution policy errors:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**2. Windows Defender / Antivirus:**
Strix uses security testing tools that may trigger antivirus. Add Docker and Strix to exclusions:
- Open Windows Security
- Virus & threat protection → Manage settings
- Add exclusions:
  - `C:\Program Files\Docker`
  - `%LOCALAPPDATA%\pipx`

**3. WSL 2 Issues:**
If Docker fails to start:
```powershell
# Enable WSL 2
wsl --install
wsl --set-default-version 2

# Update WSL
wsl --update
```

**4. Firewall Configuration:**
Docker needs to communicate with containers. If blocked:
- Open Windows Defender Firewall
- Allow Docker Desktop through both private and public networks

---

## Cloud Deployment Guide

### Option 1: AWS EC2 (Recommended)

#### Step 1: Launch EC2 Instance

**Using AWS Console:**

1. Go to AWS Console → EC2 → Launch Instance
2. **Configuration:**
   - **Name:** strix-pentest-server
   - **AMI:** Ubuntu Server 22.04 LTS (64-bit x86)
   - **Instance Type:** t3.xlarge or larger (4 vCPUs, 16 GB RAM)
   - **Key Pair:** Create new or use existing
   - **Network Settings:**
     - Allow SSH (port 22) from your IP
     - Allow custom TCP (port 8080) if you want web access
   - **Storage:** 50 GB gp3 SSD

3. Click "Launch Instance"
4. Wait for instance to start

#### Step 2: Connect to Instance

**Using SSH (PowerShell/Terminal):**
```powershell
# Replace with your key and instance IP
ssh -i "your-key.pem" ubuntu@ec2-xx-xx-xx-xx.compute.amazonaws.com
```

**Using AWS Systems Manager Session Manager (No SSH Key Needed):**
- Go to EC2 → Instances → Select your instance
- Click "Connect" → "Session Manager" → "Connect"

#### Step 3: Install Strix on EC2

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu
newgrp docker

# Install Python 3.12
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip

# Install pipx
python3 -m pip install --user pipx
python3 -m pipx ensurepath
export PATH="$HOME/.local/bin:$PATH"

# Install Strix
pipx install strix-agent

# Configure AI provider
export STRIX_LLM="openai/gpt-4"
export LLM_API_KEY="sk-your-api-key-here"

# Pull Docker image
docker pull ghcr.io/usestrix/strix-sandbox:latest

# Run a test scan
strix --target https://example.com
```

#### Step 4: Persistent Configuration

```bash
# Add to ~/.bashrc for persistence
echo 'export STRIX_LLM="openai/gpt-4"' >> ~/.bashrc
echo 'export LLM_API_KEY="sk-your-api-key-here"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

source ~/.bashrc
```

#### Cost Optimization for AWS

| Instance Type | vCPUs | RAM | Cost/Hour (us-east-1) | Recommended For |
|--------------|-------|-----|----------------------|-----------------|
| t3.large | 2 | 8 GB | ~$0.083 | Testing, small apps |
| t3.xlarge | 4 | 16 GB | ~$0.166 | Standard usage |
| t3.2xlarge | 8 | 32 GB | ~$0.333 | Large scans, multiple targets |

**Cost Saving Tips:**
- Use Spot Instances (up to 90% discount)
- Stop instance when not in use
- Use Reserved Instances for ongoing work

### Option 2: Azure Virtual Machine

#### Step 1: Create VM

**Using Azure Portal:**

1. Go to Azure Portal → Virtual Machines → Create
2. **Configuration:**
   - **VM Name:** strix-pentest
   - **Region:** Choose closest to you
   - **Image:** Ubuntu Server 22.04 LTS
   - **Size:** Standard_D4s_v3 (4 vCPUs, 16 GB RAM)
   - **Authentication:** SSH public key or password
   - **Inbound Ports:** Allow SSH (22)

3. Review + Create

#### Step 2: Connect and Install

```bash
# SSH to VM
ssh azureuser@<vm-public-ip>

# Follow same installation steps as AWS (Step 3 above)
```

### Option 3: Google Cloud Platform (GCP)

#### Step 1: Create Compute Instance

**Using GCP Console:**

1. Go to Compute Engine → VM Instances → Create Instance
2. **Configuration:**
   - **Name:** strix-pentest
   - **Region/Zone:** Choose closest
   - **Machine Type:** n2-standard-4 (4 vCPUs, 16 GB RAM)
   - **Boot Disk:** Ubuntu 22.04 LTS, 50 GB SSD
   - **Firewall:** Allow HTTP/HTTPS traffic

3. Create

#### Step 2: Connect and Install

```bash
# SSH using GCP console or:
gcloud compute ssh strix-pentest

# Follow same installation steps as AWS (Step 3 above)
```

### Option 4: DigitalOcean Droplet (Budget-Friendly)

#### Step 1: Create Droplet

1. Go to DigitalOcean → Create → Droplets
2. **Configuration:**
   - **Image:** Ubuntu 22.04 LTS
   - **Plan:** Basic (Regular Intel, 4 GB RAM, 2 vCPUs) - $24/month
   - **Region:** Choose closest
   - **Authentication:** SSH keys or password
   - **Hostname:** strix-pentest

3. Create Droplet

#### Step 2: Connect and Install

```bash
ssh root@<droplet-ip>

# Follow same installation steps as AWS (Step 3 above)
```

**DigitalOcean Costs:**
- 2 GB RAM / 1 vCPU: $12/month (minimum for testing)
- 4 GB RAM / 2 vCPUs: $24/month (recommended)
- 8 GB RAM / 4 vCPUs: $48/month (production)

### Option 5: GitHub Codespaces (Developer-Friendly)

**Perfect for:** Quick tests, CI/CD integration, no local setup

#### Step 1: Fork Strix Repository

1. Go to: https://github.com/usestrix/strix
2. Click "Fork" in top-right
3. Create fork in your account

#### Step 2: Create Codespace

1. In your forked repo, click "Code" → "Codespaces"
2. Click "Create codespace on main"
3. Wait for environment to load (~2 minutes)

#### Step 3: Install and Run

```bash
# In Codespace terminal
poetry install
export STRIX_LLM="openai/gpt-4"
export LLM_API_KEY="sk-your-api-key-here"

# Run development version
poetry run strix --target https://example.com
```

**GitHub Codespaces Costs:**
- Free tier: 120 core-hours/month
- 2-core machine: 60 hours/month free
- 4-core machine: 30 hours/month free

### Cloud Security Best Practices

#### 1. Secure API Keys

**Never hardcode keys!** Use environment variables or secrets managers:

**AWS Secrets Manager:**
```bash
# Store secret
aws secretsmanager create-secret \
    --name strix-llm-key \
    --secret-string "sk-your-api-key"

# Retrieve in script
export LLM_API_KEY=$(aws secretsmanager get-secret-value \
    --secret-id strix-llm-key --query SecretString --output text)
```

**Azure Key Vault:**
```bash
# Store secret
az keyvault secret set \
    --vault-name myKeyVault \
    --name strix-llm-key \
    --value "sk-your-api-key"

# Retrieve in script
export LLM_API_KEY=$(az keyvault secret show \
    --vault-name myKeyVault \
    --name strix-llm-key --query value -o tsv)
```

#### 2. Network Security

**Restrict SSH Access:**
```bash
# AWS Security Group: Allow SSH only from your IP
aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxx \
    --protocol tcp --port 22 \
    --cidr your.ip.address/32
```

**Use VPN or Bastion Hosts:**
- Don't expose SSH to 0.0.0.0/0
- Use AWS Systems Manager Session Manager
- Use Azure Bastion
- Use GCP Identity-Aware Proxy

#### 3. Monitoring and Logging

**Enable CloudWatch (AWS):**
```bash
# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb

# Configure logging for Strix
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/config.json << EOF
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ubuntu/agent_runs/*/scan_summary.json",
            "log_group_name": "/strix/scans",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF
```

---

## First Security Scan

### Scenario 1: Scan a Web Application

**Basic Scan:**
```bash
strix --target https://your-app.com
```

**Focused Scan with Instructions:**
```bash
strix --target https://your-app.com \
  --instruction "Prioritize authentication and authorization testing. Test with credentials: testuser/testpass123"
```

**Multi-Target Scan (Source + Deployed App):**
```bash
strix \
  -t https://github.com/yourorg/your-app \
  -t https://staging.your-app.com \
  --instruction "Perform white-box testing using source code analysis combined with black-box testing on staging environment"
```

### Scenario 2: Scan Local Source Code

**Python/Django Application:**
```bash
cd /path/to/django-project
strix --target . \
  --instruction "Focus on SQL injection, authentication bypass, and IDOR vulnerabilities"
```

**Node.js/Express Application:**
```bash
cd /path/to/express-app
strix --target . \
  --instruction "Test for XSS, CSRF, and prototype pollution vulnerabilities"
```

**Multiple Microservices:**
```bash
cd /path/to/services-root
strix \
  -t ./auth-service \
  -t ./api-service \
  -t ./payment-service \
  --instruction "Test inter-service authentication and authorization"
```

### Scenario 3: CI/CD Integration (Headless Mode)

**GitHub Actions Workflow (.github/workflows/strix-scan.yml):**
```yaml
name: Strix Security Scan

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    timeout-minutes: 60

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install Strix
        run: pipx install strix-agent

      - name: Run Strix Security Scan
        env:
          STRIX_LLM: ${{ secrets.STRIX_LLM }}
          LLM_API_KEY: ${{ secrets.LLM_API_KEY }}
        run: |
          strix -n -t ./ \
            --instruction "Focus on high-severity vulnerabilities: SQL injection, XSS, auth bypass"

      - name: Upload Scan Results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: strix-scan-results
          path: agent_runs/
          retention-days: 30
```

**GitLab CI (.gitlab-ci.yml):**
```yaml
strix-security-scan:
  stage: test
  image: ubuntu:22.04

  variables:
    STRIX_LLM: "openai/gpt-4"

  before_script:
    - apt-get update && apt-get install -y python3-pip docker.io
    - pip3 install pipx
    - pipx install strix-agent

  script:
    - strix -n -t ./ --instruction "Comprehensive security assessment"

  artifacts:
    paths:
      - agent_runs/
    expire_in: 30 days

  only:
    - merge_requests
    - main
```

### Understanding Scan Output

#### Real-Time Output (Interactive Mode)

```
🦉 Strix v0.3.2 - AI Security Testing Framework

📍 Target: https://your-app.com
🎯 Mode: Black-box testing
🤖 LLM: openai/gpt-4

[Agent Graph]
├─ 🦉 Root Agent (Coordinator)
│  ├─ 🔍 Recon Agent (Running...)
│  ├─ 💉 SQL Injection Agent (Pending)
│  └─ 🔐 Auth Testing Agent (Pending)

[Vulnerabilities Found: 3]

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🔴 HIGH: SQL Injection in /api/users/search          ┃
┃ Agent: sqli-validator-agent-001                      ┃
┃ Validated: ✓ Proof-of-concept successful             ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

Description:
SQL injection vulnerability in search parameter allows
database extraction and potential data exfiltration.

Proof of Concept:
GET /api/users/search?q=' OR '1'='1

Impact:
- Database contents can be extracted
- Potential for data modification
- Risk of complete database compromise

Remediation:
- Use parameterized queries
- Implement input validation
- Apply principle of least privilege to database user
```

#### Scan Results Location

After scan completes:
```
agent_runs/
└── your-app-com-2025-11-08-143022/
    ├── vulnerabilities/
    │   ├── vuln-001-sql-injection.json
    │   ├── vuln-002-xss.json
    │   └── vuln-003-idor.json
    ├── agent_graph.json
    ├── messages.json
    └── scan_summary.json
```

**View Summary:**
```bash
# Windows PowerShell
Get-Content agent_runs\latest\scan_summary.json | ConvertFrom-Json | Format-List

# Linux/Mac
cat agent_runs/latest/scan_summary.json | jq .
```

---

## Common Use Cases

### Use Case 1: Pre-Production Security Gate

**Scenario:** Block deployments if critical vulnerabilities found

```bash
# Run in CI/CD pipeline
strix -n -t ./ --instruction "High-severity vulnerabilities only"

# Exit code 2 = vulnerabilities found
# Exit code 0 = clean
# Exit code 1 = error

# In CI script:
if [ $? -eq 2 ]; then
  echo "⛔ Security vulnerabilities found - blocking deployment"
  exit 1
fi
```

### Use Case 2: Bug Bounty Research

**Scenario:** Automated reconnaissance and vulnerability discovery

```bash
strix --target https://target.com \
  --instruction "
    1. Comprehensive subdomain enumeration
    2. Identify all exposed endpoints and APIs
    3. Test for OWASP Top 10 vulnerabilities
    4. Focus on business logic flaws
    5. Generate detailed proof-of-concepts for all findings
  "
```

### Use Case 3: Compliance Scanning (OWASP, PCI-DSS)

**Scenario:** Regular compliance checks

```bash
# OWASP Top 10 Scan
strix --target https://your-app.com \
  --instruction "
    Test for OWASP Top 10 2021:
    - A01: Broken Access Control
    - A02: Cryptographic Failures
    - A03: Injection
    - A04: Insecure Design
    - A05: Security Misconfiguration
    - A06: Vulnerable Components
    - A07: Authentication Failures
    - A08: Data Integrity Failures
    - A09: Logging Failures
    - A10: SSRF
    Generate compliance report with CVE references.
  "
```

### Use Case 4: API Security Testing

**Scenario:** Test REST/GraphQL APIs

```bash
strix --target https://api.your-app.com \
  --instruction "
    API Security Testing:
    1. Test authentication mechanisms (JWT, OAuth)
    2. Check for broken object level authorization (IDOR)
    3. Test rate limiting and DOS protection
    4. Validate input sanitization
    5. Check for mass assignment vulnerabilities
    6. Test API versioning security
  "
```

### Use Case 5: Containerized Application Testing

**Scenario:** Test Docker/Kubernetes deployments

```bash
# Test with source code + running container
strix \
  -t ./app-source \
  -t http://localhost:8080 \
  --instruction "
    White-box + black-box testing:
    1. Analyze Dockerfile for security issues
    2. Check for exposed secrets in images
    3. Test running application for vulnerabilities
    4. Validate container escape prevention
  "
```

---

## Troubleshooting

### Windows Issues

#### Problem: Docker not starting

**Error:** "Docker Desktop failed to start"

**Solutions:**
```powershell
# 1. Enable WSL 2
wsl --install
wsl --set-default-version 2
wsl --update

# 2. Enable Virtualization in BIOS
# Restart PC → Enter BIOS → Enable Intel VT-x or AMD-V

# 3. Reset Docker Desktop
# Settings → Troubleshoot → Reset to factory defaults

# 4. Check Windows features
# Control Panel → Programs → Turn Windows features on/off
# Enable: Hyper-V, Windows Subsystem for Linux
```

#### Problem: Strix command not found

**Error:** "strix: The term 'strix' is not recognized"

**Solutions:**
```powershell
# 1. Find pipx installation path
python -m pipx list

# 2. Add to PATH (temporary)
$env:Path += ";$env:USERPROFILE\.local\bin"

# 3. Add to PATH (permanent)
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", "User") + ";$env:USERPROFILE\.local\bin",
    "User"
)

# 4. Use full path
python -m pipx run strix-agent --target https://example.com
```

#### Problem: Docker permission denied

**Error:** "permission denied while trying to connect to Docker daemon"

**Solution:**
```powershell
# Restart Docker Desktop
# Right-click Docker Desktop icon → Quit Docker Desktop
# Start Docker Desktop again

# Or restart Docker service
Restart-Service docker
```

### Cloud Issues

#### Problem: Out of memory during scan

**Error:** Container exits with exit code 137

**Solutions:**
```bash
# 1. Increase Docker memory (if self-hosted)
# Edit /etc/docker/daemon.json:
{
  "default-ulimits": {
    "memlock": {
      "Hard": -1,
      "Name": "memlock",
      "Soft": -1
    }
  }
}

# 2. Use larger instance type
# AWS: Upgrade from t3.large to t3.xlarge
# Azure: Upgrade from Standard_D2s_v3 to Standard_D4s_v3

# 3. Limit scan scope
strix --target https://example.com \
  --instruction "Focus only on authentication endpoints"
```

#### Problem: API rate limiting

**Error:** "Rate limit exceeded"

**Solutions:**
```bash
# 1. Reduce LLM temperature (fewer retries)
export STRIX_LLM="openai/gpt-4"  # Temperature defaults to 0

# 2. Use different model
export STRIX_LLM="openai/gpt-3.5-turbo"  # Cheaper, higher limits

# 3. Implement rate limiting with delays
# (Feature request - currently not configurable)

# 4. Use local model
export STRIX_LLM="ollama/llama3.1:70b"
export LLM_API_BASE="http://localhost:11434"
```

#### Problem: SSH connection timeout

**Error:** "Connection timed out"

**Solutions:**
```bash
# 1. Check security group (AWS)
aws ec2 describe-security-groups --group-ids sg-xxxxx

# 2. Verify instance is running
aws ec2 describe-instances --instance-ids i-xxxxx

# 3. Use Session Manager instead of SSH
aws ssm start-session --target i-xxxxx

# 4. Check network ACLs
# Ensure subnet allows inbound/outbound traffic
```

### General Issues

#### Problem: Scan takes too long

**Symptoms:** Scan running for hours without completion

**Solutions:**
```bash
# 1. Set specific focus
strix --target https://example.com \
  --instruction "Only test authentication and SQL injection - complete within 30 minutes"

# 2. Reduce target scope
# Instead of scanning entire domain, focus on specific endpoints

# 3. Use headless mode with timeout
timeout 3600 strix -n -t https://example.com  # 1 hour timeout

# 4. Check agent iterations
# Agents max out at 300 iterations - may need to cancel and restart
```

#### Problem: False positives

**Symptoms:** Vulnerabilities reported that aren't real

**Solutions:**
```bash
# 1. Request validation
strix --target https://example.com \
  --instruction "
    All findings MUST be validated with working proof-of-concepts.
    No speculative vulnerabilities.
    Verify each finding with actual exploitation.
  "

# 2. Manual verification
# Review agent_runs/*/vulnerabilities/*.json
# Check "validated": true field
# Review "proof_of_concept" section

# 3. Report false positives
# Help improve Strix by reporting issues:
# https://github.com/usestrix/strix/issues
```

#### Problem: Docker image pull fails

**Error:** "Error response from daemon: manifest not found"

**Solutions:**
```bash
# 1. Check internet connectivity
ping ghcr.io

# 2. Login to GitHub Container Registry (if using private fork)
docker login ghcr.io -u your-github-username

# 3. Pull with explicit tag
docker pull ghcr.io/usestrix/strix-sandbox:latest

# 4. Build locally if all else fails
git clone https://github.com/usestrix/strix.git
cd strix/containers
docker build -t strix-sandbox:local .
```

---

## Best Practices

### Security & Ethics

#### 1. Authorization First

**❌ Never scan without permission:**
```bash
# ILLEGAL - Don't do this!
strix --target https://random-company.com
```

**✅ Only scan what you own:**
```bash
# Your own apps
strix --target https://my-app.com

# With explicit permission
strix --target https://client-app.com  # After signed agreement
```

#### 2. Responsible Disclosure

If you find vulnerabilities:
1. **Don't publish immediately** - Contact security team first
2. **Give time to fix** - Usually 90 days disclosure timeline
3. **Follow disclosure policy** - Check security.txt or bug bounty program
4. **Document thoroughly** - Use Strix's detailed reports

#### 3. Data Privacy

```bash
# Don't include sensitive data in instructions
strix --target https://app.com \
  --instruction "Test with PRODUCTION credentials: admin/RealPassword123"  # ❌ NO!

# Use test accounts
strix --target https://staging-app.com \
  --instruction "Test with test account: testuser/testpass123"  # ✅ YES!

# Be aware of scan results
# agent_runs/ may contain sensitive data - don't commit to Git!
echo "agent_runs/" >> .gitignore
```

### Performance Optimization

#### 1. Targeted Scanning

**Instead of:**
```bash
strix --target https://huge-app.com  # Scans everything
```

**Do:**
```bash
strix --target https://huge-app.com \
  --instruction "
    Only scan:
    - /api/v1/auth/* (authentication)
    - /api/v1/users/* (authorization)
    - /api/v1/payments/* (payment processing)
    Skip: static assets, documentation, marketing pages
  "
```

#### 2. Use Appropriate Models

| Model | Use Case | Speed | Cost | Accuracy |
|-------|----------|-------|------|----------|
| GPT-4 Turbo | Production scans | Medium | $$ | High |
| GPT-3.5 Turbo | Quick checks, CI/CD | Fast | $ | Medium |
| Claude Sonnet | Balanced performance | Medium | $$ | High |
| Local (Llama3.1:70b) | Large-scale, budget | Slow* | Free | Medium |

*Depends on hardware

#### 3. Incremental Scanning

```bash
# Day 1: Reconnaissance
strix --target https://app.com \
  --instruction "Only perform reconnaissance - map all endpoints and technologies"

# Day 2: Focused testing based on Day 1 findings
strix --target https://app.com \
  --instruction "Based on recon, app uses Django + PostgreSQL. Focus on Django-specific SQLi and auth bypass"

# Day 3: Validation
strix --target https://app.com \
  --instruction "Validate the 5 high-severity findings from previous scans"
```

#### 4. Resource Management

**Monitor Docker resources:**
```bash
# Check Docker resource usage
docker stats

# Clean up old containers
docker container prune

# Clean up old images
docker image prune -a

# Check disk usage
docker system df
```

**Cloud cost optimization:**
```bash
# Use Spot/Preemptible instances (up to 90% discount)
# AWS Spot
aws ec2 run-instances \
  --instance-type t3.xlarge \
  --instance-market-options MarketType=spot \
  ...

# Stop instances when not in use
aws ec2 stop-instances --instance-ids i-xxxxx

# Schedule start/stop with Lambda/EventBridge
```

### Continuous Security

#### 1. Scheduled Scans

**Cron job on Linux/Cloud:**
```bash
# Edit crontab
crontab -e

# Run weekly scan every Sunday at 2 AM
0 2 * * 0 /home/user/.local/bin/strix -n -t https://app.com --instruction "Weekly security audit"
```

**Windows Task Scheduler:**
```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "strix" -Argument "-n -t https://app.com"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2am
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Strix-Weekly-Scan"
```

#### 2. Integrate with Monitoring

```bash
# Send results to Slack
SCAN_RESULT=$(strix -n -t https://app.com 2>&1)
if [ $? -eq 2 ]; then
  curl -X POST $SLACK_WEBHOOK_URL \
    -H 'Content-Type: application/json' \
    -d "{\"text\":\"⚠️ Security vulnerabilities found!\n$SCAN_RESULT\"}"
fi

# Send results to email
echo "$SCAN_RESULT" | mail -s "Strix Scan Results" security-team@company.com

# Store in S3
aws s3 cp agent_runs/ s3://security-scans/$(date +%Y-%m-%d)/ --recursive
```

#### 3. Track Metrics

Create a dashboard to track:
- Vulnerabilities found over time
- Time to remediate
- Scan duration trends
- False positive rates
- Coverage metrics

### Development Workflow

#### Local Testing → Staging → Production

```bash
# 1. Developer runs locally before commit
cd my-feature-branch
strix -n -t ./ --instruction "Quick security check - 10 minutes max"

# 2. CI/CD runs on PR
# (Automated via GitHub Actions)

# 3. Weekly comprehensive scan on staging
strix -t https://staging.app.com \
  --instruction "Full OWASP Top 10 assessment"

# 4. Monthly audit on production (read-only mode)
strix -t https://app.com \
  --instruction "Non-invasive passive scanning only - no active exploitation"
```

---

## Quick Reference Card

### Essential Commands

```bash
# Windows Setup
docker pull ghcr.io/usestrix/strix-sandbox:latest
pipx install strix-agent
$env:STRIX_LLM = "openai/gpt-4"
$env:LLM_API_KEY = "sk-..."

# Linux/Cloud Setup
docker pull ghcr.io/usestrix/strix-sandbox:latest
pipx install strix-agent
export STRIX_LLM="openai/gpt-4"
export LLM_API_KEY="sk-..."

# Basic Scans
strix --target https://app.com                    # Web app
strix --target ./code                             # Local code
strix --target https://github.com/user/repo       # Repository
strix -n --target https://app.com                 # Headless mode

# Multi-target
strix -t https://github.com/org/app -t https://staging.app.com

# With instructions
strix --target https://app.com --instruction "Focus on auth vulnerabilities"

# View results
cd agent_runs/<latest>/
cat scan_summary.json | jq .                      # Linux/Mac
Get-Content scan_summary.json | ConvertFrom-Json # Windows
```

### Environment Variables

```bash
# Required
STRIX_LLM="openai/gpt-4"           # or anthropic/claude-sonnet-4-5
LLM_API_KEY="sk-..."               # Your API key

# Optional
LLM_API_BASE="http://localhost:11434"  # For local models
PERPLEXITY_API_KEY="..."           # For web search
```

### Exit Codes

| Code | Meaning | CI/CD Action |
|------|---------|--------------|
| 0 | Clean - no vulnerabilities | ✅ Pass |
| 1 | Error - scan failed | ⚠️ Investigate |
| 2 | Vulnerabilities found | ❌ Block deployment |

### Cost Estimates (per scan)

| Target Size | Duration | GPT-4 Cost | Claude Cost | Llama3.1 (local) |
|-------------|----------|------------|-------------|------------------|
| Small app | 10-20 min | $0.50-$2 | $0.30-$1.50 | Free |
| Medium app | 30-60 min | $2-$5 | $1.50-$3 | Free |
| Large app | 2-4 hours | $10-$20 | $5-$10 | Free |

---

## Next Steps

### Continue Learning

1. **Join the Community**
   - Discord: https://discord.gg/YjKFvEZSdZ
   - GitHub: https://github.com/usestrix/strix

2. **Explore Advanced Features**
   - Read CLAUDE.md for architecture deep-dive
   - Study prompt modules in `strix/prompts/`
   - Learn about custom tool development

3. **Contribute**
   - Report bugs and false positives
   - Submit prompt modules for new vulnerabilities
   - Share your use cases

4. **Enterprise Features**
   - Executive dashboards
   - Custom models
   - Professional support
   - Visit: https://usestrix.com

### Getting Help

**Community Support:**
- GitHub Issues: https://github.com/usestrix/strix/issues
- Discord Server: https://discord.gg/YjKFvEZSdZ

**Documentation:**
- Main README: https://github.com/usestrix/strix/blob/main/README.md
- Architecture Guide: CLAUDE.md (this repository)
- Prompt Guide: strix/prompts/README.md

**Emergency Issues:**
- Check troubleshooting section above
- Search existing GitHub issues
- Post detailed issue with logs

---

## Appendix: Cloud Provider Comparison

| Feature | AWS EC2 | Azure VM | GCP Compute | DigitalOcean | GitHub Codespaces |
|---------|---------|----------|-------------|--------------|-------------------|
| **Ease of Setup** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Cost (4 vCPU, 16GB)** | ~$120/mo | ~$150/mo | ~$130/mo | ~$48/mo | ~$36/mo |
| **Free Tier** | ✅ (750h t2.micro) | ✅ (12 months) | ✅ ($300 credit) | ❌ | ✅ (120 core-hours) |
| **Spot Instances** | ✅ (-90%) | ✅ (-80%) | ✅ (-70%) | ❌ | ❌ |
| **Global Regions** | 26+ | 60+ | 35+ | 14 | N/A |
| **Network Performance** | Excellent | Excellent | Excellent | Good | Good |
| **Best For** | Enterprise | Enterprise | Data/ML | Startups | Developers |

**Recommendation:**
- **Learning/Testing:** GitHub Codespaces (free tier) or DigitalOcean ($24/mo droplet)
- **Production/CI/CD:** AWS/Azure/GCP with Spot instances
- **Budget-Conscious:** DigitalOcean or Hetzner Cloud
- **Enterprise:** AWS/Azure with reserved instances

---

**End of Crash Course**

*Last Updated: 2025-11-08*
*Strix Version: 0.3.2*
*Questions? Join our Discord: https://discord.gg/YjKFvEZSdZ*
