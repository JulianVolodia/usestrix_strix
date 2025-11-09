# Responsible Security Testing Guide

**Version:** 1.0
**Last Updated:** 2025-11-08
**Status:** Official Guide

---

## ⚖️ Legal Notice

**UNAUTHORIZED COMPUTER ACCESS IS A CRIME**

Before using Strix or any security testing tool, you **MUST** understand the legal framework:

### United States
- **Computer Fraud and Abuse Act (CFAA)** - 18 U.S.C. § 1030
  - Unauthorized access to computer systems: Up to 20 years imprisonment
  - Damage to protected computers: Criminal and civil penalties
  - Exceeding authorized access: Criminal charges

### European Union
- **Computer Misuse Act** (UK)
- **GDPR** - Data protection violations
- Each EU country has specific cybercrime laws

### International
- **Council of Europe Convention on Cybercrime** (Budapest Convention)
- Most countries have similar laws against unauthorized access

### Consequences of Illegal Testing

| Violation | Potential Consequences |
|-----------|------------------------|
| **Unauthorized Access** | Criminal charges, imprisonment, fines |
| **Data Breach** | Civil lawsuits, GDPR fines (up to 4% revenue), criminal prosecution |
| **Denial of Service** | Aggravated charges, higher penalties |
| **Intent to Defraud** | Federal fraud charges, enhanced penalties |
| **International Targeting** | Extradition, international prosecution |

**Case Examples:**
- Marcus Hutchins: Unauthorized access charges (plea deal)
- David Nosal: Exceeding authorized access (9th Circuit ruling)
- Aaron Swartz: CFAA charges (tragic outcome)

**⚠️ Bottom line:** If you don't own it or don't have written permission, **DON'T TEST IT**.

---

## ✅ Legal Ways to Find Vulnerabilities

### 1. Your Own Systems

**100% Legal:**
- Applications you developed
- Infrastructure you own
- Systems you manage
- Personal projects

**With Strix:**
```bash
# Test your own application
strix --target ./my-app

# Test your deployed service
strix --target https://my-service.com

# Test your infrastructure
strix --target https://api.mycompany.com
```

### 2. Bug Bounty Programs

**What are Bug Bounty Programs?**

Companies offer rewards for responsibly disclosed security vulnerabilities. These programs provide **legal authorization** to test specific systems within defined scope.

**Key Points:**
- ✅ **Legal protection** - Written authorization in program terms
- ✅ **Financial rewards** - From $100 to $1,000,000+
- ✅ **Recognition** - Hall of Fame, security community reputation
- ✅ **Clear scope** - Know exactly what you can test
- ✅ **Coordinated disclosure** - Companies get time to fix before public disclosure

### 3. Authorized Penetration Testing

**Professional Engagement:**
- Signed contract with client
- Statement of Work (SOW) defining scope
- Rules of Engagement (ROE) document
- Clear authorization letter

**Required Documents:**
1. **Penetration Testing Agreement**
2. **Scope Definition** (IP ranges, domains, applications)
3. **Authorization Letter** (for ISPs, cloud providers)
4. **Insurance Coverage** (professional liability)

### 4. Capture The Flag (CTF) Competitions

**Intentionally Vulnerable Systems:**
- HackTheBox (https://www.hackthebox.com/)
- TryHackMe (https://tryhackme.com/)
- PentesterLab (https://pentesterlab.com/)
- Root-Me (https://www.root-me.org/)
- OverTheWire (https://overthewire.org/)

**Educational/Practice Environments:**
- OWASP WebGoat
- DVWA (Damn Vulnerable Web Application)
- Metasploitable
- bWAPP

---

## 🎯 Bug Bounty Programs for Major Companies

### Apple Security Bounty

**Program:** https://security.apple.com/bounty/
**Platform:** Direct submission to Apple
**Scope:** iOS, macOS, tvOS, watchOS, iCloud, and more

**Reward Range:** $5,000 - $1,000,000

| Vulnerability Type | Maximum Reward |
|-------------------|----------------|
| Zero-click kernel code execution | $1,000,000 |
| Zero-click iCloud account takeover | $1,000,000 |
| Network attack without user interaction | $500,000 |
| Physical attack | $250,000 |

**In-Scope Assets:**
- ✅ Apple Operating Systems (iOS, macOS, watchOS, tvOS)
- ✅ iCloud services
- ✅ Apple Store online
- ✅ Apple hardware (with device required)

**Out-of-Scope:**
- ❌ Third-party applications
- ❌ Social engineering
- ❌ Physical security of Apple facilities
- ❌ Denial of Service attacks

**How to Test Apple Products Legally with Strix:**

```bash
# Test your own iOS/macOS application
strix --target ./my-ios-app-source \
  --instruction "Focus on authentication, data storage, and API security"

# Test web services (check program scope first!)
# Only test if explicitly listed in bounty program scope
strix --target https://appleid.apple.com \
  --instruction "Passive reconnaissance only, no active exploitation"
```

**Important:**
- Read the full program rules: https://security.apple.com/bounty/rules-terms/
- Obtain a device for hardware testing
- No testing on production user data
- Report immediately, do not demonstrate on real users

### Microsoft Security Response Center (MSRC)

**Program:** https://msrc.microsoft.com/engage
**Platform:** MSRC portal
**Scope:** Windows, Office, Azure, Xbox, Dynamics, and more

**Reward Range:** $500 - $250,000+

| Product Category | Typical Rewards |
|-----------------|-----------------|
| Windows | $500 - $250,000 |
| Azure | $500 - $40,000 |
| Office | $500 - $15,000 |
| Microsoft Edge | $1,000 - $30,000 |
| Xbox | $500 - $20,000 |

**Special Bounties:**
- **AI Bug Bounty:** Bing Chat, Microsoft Security Copilot ($2,000 - $15,000)
- **Identity Bounty:** Microsoft Entra (formerly Azure AD) ($500 - $26,000)
- **Hyper-V:** Virtualization vulnerabilities (up to $250,000)

**In-Scope:**
- ✅ Online services (Azure, Office 365, Outlook.com)
- ✅ On-premises products (Windows Server, SQL Server)
- ✅ Applications (Office, Edge, Teams)
- ✅ Cloud infrastructure (Azure)

**Out-of-Scope:**
- ❌ Outdated/unsupported products
- ❌ Issues requiring physical access
- ❌ Social engineering attacks
- ❌ DoS attacks

**Testing Microsoft Products with Strix:**

```bash
# Test your own Azure application
strix --target https://your-app.azurewebsites.net \
  --instruction "Test for OWASP Top 10 in Azure-hosted application"

# Test your own Microsoft 365 add-in
strix --target ./office-addin-source \
  --instruction "Focus on authentication and data access vulnerabilities"

# White-box testing of Windows desktop app
strix --target ./my-windows-app \
  --instruction "Analyze for privilege escalation and injection vulnerabilities"
```

**Submission Process:**
1. Create account at https://msrc.microsoft.com/
2. Submit vulnerability report with detailed PoC
3. Microsoft validates (typically 24-48 hours response)
4. Coordinate disclosure timeline (90 days standard)
5. Receive bounty payment after fix is released

### Google Vulnerability Reward Program (VRP)

**Program:** https://bughunters.google.com/
**Platform:** Google Bug Hunters
**Scope:** Google.com, Android, Chrome, Google Cloud, and more

**Reward Range:** $100 - $1,000,000+

| Program | Reward Range |
|---------|--------------|
| Google.com | $100 - $31,337 |
| Android | $100 - $1,000,000 |
| Chrome | $500 - $250,000 |
| Google Cloud | $100 - $133,337 |
| Google Play Protect | $5,000 - $20,000 |

**Bonus Multipliers:**
- **Quality of Report:** Up to 2x multiplier
- **Patch Ready:** Additional rewards
- **Exceptional Impact:** Up to $1M for Android exploits

**In-Scope Assets:**

**Google Web Properties:**
- ✅ google.com and subdomains
- ✅ YouTube
- ✅ Gmail
- ✅ Google Cloud Platform
- ✅ Google Play
- ✅ Google Workspace

**Products:**
- ✅ Chrome browser
- ✅ Android OS
- ✅ ChromeOS
- ✅ Google Home/Nest devices

**Out-of-Scope:**
- ❌ Acquired companies with separate programs
- ❌ Third-party apps on Google Play
- ❌ Blogger.com
- ❌ Social engineering

**Testing Google Products with Strix:**

```bash
# Test your own Google Cloud application
strix --target https://your-app.appspot.com \
  --instruction "Security assessment of GCP-hosted application"

# Test Chrome extension you're developing
strix --target ./my-chrome-extension \
  --instruction "Focus on XSS, CSRF, and extension permission vulnerabilities"

# Test Android app (your own)
strix --target ./android-app-source \
  --instruction "Android security best practices, data storage, authentication"
```

**Submission Guidelines:**
1. Register at https://bughunters.google.com/
2. Submit detailed vulnerability report
3. Include reproducible PoC
4. Await Google security team review
5. Coordinate public disclosure

### Facebook/Meta Bug Bounty

**Program:** https://www.facebook.com/whitehat/
**Platform:** Meta Bug Bounty (via HackerOne)
**Scope:** Facebook, Instagram, WhatsApp, Oculus

**Reward Range:** $500 - $40,000+

**Special Categories:**
- Account takeover: High rewards
- Remote code execution: High rewards
- Data exposure: High rewards
- Authentication bypass: High rewards

**In-Scope:**
- ✅ facebook.com
- ✅ instagram.com
- ✅ whatsapp.com
- ✅ oculus.com
- ✅ Mobile apps (iOS/Android)

**Testing Meta Properties:**

```bash
# Test your own Facebook/Instagram integration
strix --target ./fb-integration-app \
  --instruction "Test OAuth flow, API security, data handling"
```

### Amazon Web Services (AWS) Bug Bounty

**Program:** AWS Vulnerability Reporting
**Email:** aws-security@amazon.com
**Scope:** AWS services (not amazon.com)

**No public bounties**, but AWS acknowledges security researchers and may provide rewards on case-by-case basis.

**In-Scope:**
- ✅ AWS services (EC2, S3, Lambda, etc.)
- ✅ AWS Management Console
- ✅ AWS CLI/SDKs

**Testing AWS Services:**

```bash
# Test your own AWS infrastructure
strix --target ./aws-terraform-configs \
  --instruction "Analyze for misconfigurations, excessive permissions, insecure settings"

# Test your AWS-hosted application
strix --target https://your-app.elasticbeanstalk.com \
  --instruction "Security assessment of AWS-hosted application"
```

---

## 🎓 Bug Bounty Platforms

### Major Platforms

#### HackerOne
**URL:** https://hackerone.com/
**Programs:** 2,000+
**Paid Out:** $230M+

**Notable Programs:**
- U.S. Department of Defense
- PayPal
- GitHub
- Shopify
- Nintendo
- Valve (Steam)

**Getting Started:**
1. Create HackerOne account
2. Browse programs: https://hackerone.com/directory/programs
3. Filter by "Offers bounties"
4. Read program scope carefully
5. Submit high-quality reports

#### Bugcrowd
**URL:** https://bugcrowd.com/
**Programs:** 1,000+
**Focus:** Enterprise crowdsourced security

**Notable Programs:**
- Tesla
- Mozilla
- Mastercard
- Fitbit
- LastPass

**Getting Started:**
1. Sign up at https://bugcrowd.com/researchers
2. Browse programs
3. Check eligibility requirements
4. Review scope and rules
5. Submit findings

#### Intigriti
**URL:** https://www.intigriti.com/
**Focus:** European companies
**Programs:** 300+

#### YesWeHack
**URL:** https://www.yeswehack.com/
**Focus:** European market
**Programs:** 700+

#### Synack
**URL:** https://www.synack.com/
**Model:** Invite-only platform
**Focus:** Enterprise-grade testing

---

## 📝 How to Write a Good Vulnerability Report

### Essential Elements

1. **Title**
   - Clear, concise description
   - Include vulnerability type
   - Example: "SQL Injection in /api/users/search endpoint"

2. **Severity**
   - Use CVSS scoring or program's rating system
   - Critical / High / Medium / Low

3. **Vulnerability Type**
   - OWASP category (A01, A02, etc.)
   - CWE number if applicable

4. **Affected Asset**
   - URL, endpoint, or component
   - Version information if relevant

5. **Description**
   - Clear explanation of the vulnerability
   - Why it's a security issue
   - Potential impact

6. **Proof of Concept (PoC)**
   - Step-by-step reproduction
   - Code samples or requests
   - Screenshots or videos
   - **Working, but minimal** - Prove the issue without causing harm

7. **Impact**
   - What attacker can achieve
   - Business impact
   - User impact

8. **Remediation**
   - Suggested fix
   - Code examples if applicable
   - References to best practices

### Example Report Template

```markdown
# SQL Injection in User Search Endpoint

## Summary
The `/api/v1/users/search` endpoint is vulnerable to SQL injection via the `q` parameter, allowing an unauthenticated attacker to extract sensitive data from the database.

## Severity
**Critical (CVSS 9.1)**

## Vulnerability Details
**Type:** CWE-89: SQL Injection
**Affected Asset:** https://example.com/api/v1/users/search
**Endpoint:** GET /api/v1/users/search

## Description
The application constructs SQL queries using unsanitized user input from the `q` parameter, allowing injection of arbitrary SQL commands.

## Proof of Concept

### Request
```http
GET /api/v1/users/search?q=admin' UNION SELECT username,password,email FROM users-- HTTP/1.1
Host: example.com
```

### Response
```json
{
  "results": [
    {
      "username": "admin",
      "password": "$2b$12$KIX...",
      "email": "admin@example.com"
    }
  ]
}
```

### Steps to Reproduce
1. Send GET request to `/api/v1/users/search`
2. Include malicious SQL in `q` parameter
3. Observe that arbitrary SQL is executed
4. Database contents are returned in response

## Impact
- **Data Breach:** All user data can be extracted (usernames, hashed passwords, emails, PII)
- **Authentication Bypass:** Password hashes can be cracked offline
- **Privilege Escalation:** Admin accounts can be compromised
- **Regulatory Impact:** GDPR violation, potential fines

## Remediation

### Recommended Fix
Use parameterized queries instead of string concatenation:

```python
# Vulnerable code
query = f"SELECT * FROM users WHERE username LIKE '%{q}%'"

# Secure code
query = "SELECT * FROM users WHERE username LIKE %s"
cursor.execute(query, (f'%{q}%',))
```

### Additional Recommendations
1. Implement input validation and sanitization
2. Use ORM frameworks with built-in protection
3. Apply principle of least privilege to database user
4. Implement WAF rules to detect SQL injection attempts
5. Regular security testing and code reviews

## References
- OWASP SQL Injection: https://owasp.org/www-community/attacks/SQL_Injection
- CWE-89: https://cwe.mitre.org/data/definitions/89.html
```

---

## 🛡️ Using Strix Responsibly for Bug Bounties

### Preparation Phase

#### 1. Read the Program Policy

**Before any testing:**
- Read entire bug bounty policy
- Understand in-scope assets
- Note out-of-scope items
- Check prohibited testing methods
- Understand disclosure timeline

#### 2. Document Authorization

**Save evidence:**
- Screenshot of program scope
- Copy of terms and conditions
- Date of access to program
- Any communication with program team

#### 3. Set Up Testing Environment

```bash
# Configure Strix for responsible testing
export STRIX_LLM="openai/gpt-4"
export LLM_API_KEY="your-api-key"

# Create project directory
mkdir -p ~/bug-bounty/company-name
cd ~/bug-bounty/company-name

# Document the scope
cat > SCOPE.md << EOF
# Bug Bounty: Company Name
Program: https://...
Date: 2025-11-08
In Scope:
- https://app.example.com
- https://api.example.com

Out of Scope:
- https://blog.example.com
- DoS testing
- Social engineering

Prohibited:
- Testing with real user data
- Automated scanning without notice
EOF
```

### Testing Phase

#### 1. Passive Reconnaissance (Always Safe)

```bash
# Gather information without active testing
strix --target https://target.com \
  --instruction "
    Passive reconnaissance only:
    1. Identify technologies and frameworks
    2. Map public endpoints
    3. Enumerate subdomains
    4. Check for exposed files (robots.txt, sitemap.xml)
    5. NO active exploitation
    6. NO credential testing
    7. NO vulnerability scanning
  "
```

#### 2. Test on Isolated Environment First

```bash
# If company provides test environment
strix --target https://staging.target.com \
  --instruction "
    Test environment security assessment:
    - Use test credentials provided
    - Focus on authentication and authorization
    - Test for injection vulnerabilities
    - Validate input handling
  "
```

#### 3. Responsible Active Testing

```bash
# Active testing on production (with caution)
strix --target https://api.target.com \
  --instruction "
    Careful security testing:
    1. Create test account with unique email (your@your-domain.com)
    2. Only test with your own account data
    3. NO testing on other users' data
    4. NO brute force attacks
    5. NO DoS or heavy load testing
    6. Document all test requests
    7. Clean up test data after testing
    8. Focus on high-impact vulnerabilities:
       - Authentication bypass
       - Authorization flaws (IDOR)
       - Injection vulnerabilities (SQLi, XSS)
       - Sensitive data exposure
  "
```

#### 4. Limits and Boundaries

**DO:**
- ✅ Test with your own account
- ✅ Create isolated test data
- ✅ Use rate limiting to avoid service impact
- ✅ Document every test
- ✅ Stop immediately if you access other users' data
- ✅ Report immediately if you find critical vulnerability

**DON'T:**
- ❌ Access other users' data
- ❌ Modify or delete production data
- ❌ Perform DoS attacks
- ❌ Test out-of-scope assets
- ❌ Use automated tools excessively
- ❌ Publicly disclose before coordinated disclosure
- ❌ Use findings for any purpose other than security research

### Reporting Phase

#### 1. Validate Your Finding

```bash
# Verify the vulnerability
strix --target https://target.com/vulnerable-endpoint \
  --instruction "
    Validate the vulnerability found:
    1. Reproduce the issue 3 times to confirm
    2. Ensure it's not a false positive
    3. Create minimal PoC
    4. Document exact steps
    5. Capture evidence (requests, responses, screenshots)
  "
```

#### 2. Assess Impact

**Impact Analysis:**
- What data can be accessed?
- Can this lead to further compromise?
- How many users are affected?
- What's the business impact?
- Rate severity using CVSS

#### 3. Write the Report

Use Strix's vulnerability reports as a starting point:

```bash
# Find Strix's generated report
cat agent_runs/latest/vulnerabilities/vuln-001.json

# Use report template above
# Include:
# - Clear title
# - Severity rating
# - Detailed description
# - Step-by-step PoC
# - Impact assessment
# - Remediation suggestions
```

#### 4. Submit Responsibly

**Platform Submission:**
1. Log into bug bounty platform
2. Select the program
3. Create new report
4. Fill in all required fields
5. Attach evidence
6. Submit

**Direct Submission (if no platform):**
1. Email security@company.com or security contact
2. Use PGP encryption if available
3. Include all report elements
4. Request acknowledgment

### Post-Submission Phase

#### 1. Coordinate Disclosure

**Typical Timeline:**
- Day 0: Submit report
- Day 1-3: Company acknowledges receipt
- Day 7-14: Company validates and triages
- Day 30-90: Company develops and tests fix
- Day 90: Coordinated public disclosure (if applicable)

**Your Responsibilities:**
- Don't publicly disclose until agreed timeline
- Respond to company questions promptly
- Retest fix if requested
- Be patient - fixes take time

#### 2. Handle Disputes

**If report is rejected:**
- Ask for specific reasons
- Provide additional evidence if available
- Request reconsideration if you disagree
- Accept decision gracefully if confirmed not a vulnerability
- Learn from feedback

**If bounty is lower than expected:**
- Ask for justification
- Provide impact evidence
- Negotiate politely
- Accept final decision

#### 3. Public Disclosure (After Fix)

**If you want to publish:**
- Wait for company's public fix announcement
- Request permission for disclosure
- Coordinate publication timing
- Give company credit for quick response
- Share technical details to help community
- Update CVE database if applicable

---

## 🚨 Red Flags - When to STOP

### Immediate Stop Situations

| Scenario | What to Do |
|----------|------------|
| **Accessed other users' data** | Stop immediately. Document what happened. Report to company immediately with details. Delete any data obtained. |
| **Triggered alerts/monitoring** | Stop testing. Contact security team. Explain you're a researcher. Provide evidence of authorization (bug bounty program). |
| **Found critical 0-day in out-of-scope asset** | Stop testing that asset. Report to company anyway (responsible disclosure). May still be rewarded. |
| **Caused service disruption** | Stop immediately. Contact security team urgently. Document what caused disruption. Offer to help remediate. |
| **Found child exploitation material** | Stop immediately. DO NOT DOWNLOAD. Report to NCMEC (US): https://report.cybertip.org/ or local authorities. Then report to company. |
| **Found evidence of ongoing attack** | Stop your testing. Report to company's security team immediately. Provide details of suspicious activity. |

### Warning Signs

- System behaving unexpectedly after your test
- Access to administrative functions you shouldn't have
- Ability to read arbitrary files on server
- Access to other companies' data (multi-tenant breach)
- Production database access
- Source code repository access
- Internal network access

**In all cases: STOP, DOCUMENT, REPORT**

---

## 📚 Learning Resources

### Bug Bounty Guides

- **HackerOne Resources:** https://www.hackerone.com/resources
- **Bugcrowd University:** https://www.bugcrowd.com/hackers/bugcrowd-university/
- **OWASP Testing Guide:** https://owasp.org/www-project-web-security-testing-guide/
- **PortSwigger Web Security Academy:** https://portswigger.net/web-security (FREE)

### Security Training

- **PentesterLab:** https://pentesterlab.com/
- **HackTheBox:** https://www.hackthebox.com/
- **TryHackMe:** https://tryhackme.com/
- **SANS Cyber Aces:** https://tutorials.cyberaces.org/ (FREE)

### Books

- **"The Web Application Hacker's Handbook"** - Dafydd Stuttard, Marcus Pinto
- **"Real-World Bug Hunting"** - Peter Yaworski
- **"Bug Bounty Bootcamp"** - Vickie Li
- **"Hacking: The Art of Exploitation"** - Jon Erickson

### Communities

- **Twitter:** Follow #bugbounty, #infosec
- **Reddit:** r/bugbounty, r/netsec
- **Discord:** Many programs have official Discord servers
- **Conferences:** DEF CON, Black Hat, BSides events

---

## ✅ Pre-Testing Checklist

Before starting any security testing with Strix:

- [ ] I own this system OR
- [ ] I have written authorization OR
- [ ] This is part of an official bug bounty program
- [ ] I have read and understood the bug bounty program policy
- [ ] I know what is in-scope and out-of-scope
- [ ] I know what testing methods are prohibited
- [ ] I have created a test account with my own email
- [ ] I will not access other users' data
- [ ] I will not cause service disruption
- [ ] I will document all testing activities
- [ ] I will report findings responsibly
- [ ] I will not publicly disclose until authorized
- [ ] I understand the legal consequences of unauthorized access
- [ ] I have saved evidence of authorization

**If you cannot check ALL boxes above, DO NOT PROCEED with testing.**

---

## 📞 Getting Help

### Legal Questions

**Consult a lawyer** if you have questions about:
- Authorization scope
- Contract interpretation
- Legal risk
- Potential violations

**Resources:**
- Electronic Frontier Foundation (EFF): https://www.eff.org/
- Legal clinics at law schools
- Bar association referral services

### Ethical Questions

**Ask yourself:**
- Would I be comfortable explaining this to a judge?
- Am I causing harm?
- Am I acting in good faith?
- Would the company welcome this research?

**When in doubt, DON'T TEST. ASK FIRST.**

### Technical Questions

- Bug bounty platform support
- Company security team
- Security community forums
- Strix Discord: https://discord.gg/YjKFvEZSdZ

---

## 🎯 Summary: The Golden Rules

1. **Authorization First** - Never test without permission
2. **Read the Policy** - Understand scope and rules
3. **Document Everything** - Keep records of all testing
4. **Minimize Impact** - Test gently, avoid disruption
5. **Respect Privacy** - Only access your own data
6. **Report Responsibly** - Coordinated disclosure
7. **Act in Good Faith** - Ethical research only
8. **Know the Law** - Understand legal framework
9. **Be Professional** - Courteous communication
10. **Give Back** - Share knowledge with community

---

## 📖 Appendix: Legal Resources

### Bug Bounty Legal Safe Harbor

Many programs include "safe harbor" provisions:

**Example Safe Harbor Language:**
> "If you make a good faith effort to comply with this policy during your security research, we will consider your research to be authorized, and will work with you to understand and resolve the issue quickly, and will not recommend or pursue legal action related to your research."

**What this means:**
- Company won't pursue legal action
- Good faith effort required
- Must follow program rules
- Not a blanket immunity

### Vulnerability Disclosure Policy (VDP)

Even without bounties, many companies have VDPs:

**What is VDP:**
- Policy for reporting vulnerabilities
- No monetary rewards
- Legal safe harbor
- Coordinated disclosure process

**Finding VDPs:**
- security.txt file: https://example.com/.well-known/security.txt
- Company security page
- Disclose.io: https://disclose.io/

### International Considerations

**Testing foreign companies:**
- Subject to their country's laws
- May face extradition
- Consult international law expert
- Verify legal jurisdiction

---

**Last Updated:** 2025-11-08
**Version:** 1.0
**Maintained by:** Strix Community

**Questions?** Join our Discord: https://discord.gg/YjKFvEZSdZ

---

**Remember:** The best security researchers are those who can find vulnerabilities AND report them responsibly. Your reputation and freedom depend on following these guidelines.

**Stay legal. Stay ethical. Stay safe.** 🦉
