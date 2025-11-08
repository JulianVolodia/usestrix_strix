# CLAUDE.md - Comprehensive Repository Documentation

**Project:** Strix - Open-source AI Hackers for Application Security
**Version:** 0.3.2
**Repository:** https://github.com/usestrix/strix
**Documentation Date:** 2025-11-08
**Branch:** claude/document-archive-analysis-011CUvdtnSVKtigC5eE98hxF

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Repository Structure](#repository-structure)
3. [Architecture Deep Dive](#architecture-deep-dive)
4. [Development Guide](#development-guide)
5. [Git Branch Information](#git-branch-information)
6. [Testing & Quality](#testing--quality)
7. [Deployment & Operations](#deployment--operations)
8. [Contributing Guidelines](#contributing-guidelines)

---

## Project Overview

### What is Strix?

Strix is an autonomous AI-powered penetration testing framework that acts like a real hacker - running code dynamically, discovering vulnerabilities, and validating them through proof-of-concepts. Unlike static analysis tools, Strix provides real validation with minimal false positives.

**Key Capabilities:**
- Autonomous AI agents with full hacker toolkit
- Multi-agent collaboration for comprehensive security testing
- Real vulnerability validation with PoCs (not just static analysis)
- Developer-first CLI with actionable reports
- CI/CD integration for automated security testing
- White-box (source code) and black-box (web app) testing modes

### Core Statistics

- **Language:** Python 3.12+
- **Total Lines of Code:** ~5,619 lines
- **Architecture:** Multi-agent system with Docker sandboxing
- **Package Name:** `strix-agent`
- **License:** Apache 2.0
- **Current Version:** 0.3.2

### Use Cases

1. **Vulnerability Detection** - Detect and validate critical vulnerabilities in applications
2. **Penetration Testing** - Complete pentests in hours instead of weeks with compliance reports
3. **Bug Bounty Research** - Automate bug hunting and generate PoCs for faster reporting
4. **CI/CD Security** - Block vulnerabilities before they reach production

### Supported Vulnerability Classes

- **Access Control:** IDOR, privilege escalation, authorization bypass
- **Injection:** SQL, NoSQL, command injection, XSS
- **Server-Side:** SSRF, XXE, deserialization flaws
- **Authentication:** JWT vulnerabilities, session management
- **Business Logic:** Race conditions, workflow manipulation
- **Infrastructure:** Misconfigurations, exposed services

---

## Repository Structure

```
usestrix_strix/
├── .github/                    # GitHub-specific files
│   ├── ISSUE_TEMPLATE/        # Issue templates
│   ├── logo.png               # Project logo
│   └── screenshot.png         # Demo screenshot
├── containers/                 # Docker container definitions
│   ├── Dockerfile             # Kali-based sandbox image
│   └── docker-entrypoint.sh   # Container initialization script
├── strix/                      # Main application code
│   ├── __init__.py            # Package initialization
│   ├── agents/                # Agent system implementation
│   │   ├── base_agent.py      # Abstract base agent with metaclass
│   │   ├── state.py           # Agent state management (Pydantic)
│   │   └── StrixAgent/        # Main Strix agent implementation
│   │       ├── strix_agent.py
│   │       └── system_prompt.jinja
│   ├── interface/             # User interface (CLI/TUI)
│   │   ├── main.py            # Entry point and orchestration
│   │   ├── cli.py             # Non-interactive headless mode
│   │   ├── tui.py             # Interactive Textual interface
│   │   ├── tool_components/   # UI renderers for tools
│   │   └── assets/            # UI assets
│   ├── llm/                   # LLM integration layer
│   │   ├── llm.py             # Main LLM client (LiteLLM)
│   │   ├── config.py          # LLM configuration
│   │   ├── request_queue.py   # Request management
│   │   ├── memory_compressor.py # Context window optimization
│   │   └── utils.py           # LLM utilities
│   ├── prompts/               # Modular prompt system
│   │   ├── README.md          # Prompt authoring guide
│   │   ├── vulnerabilities/   # Vulnerability-specific prompts
│   │   ├── frameworks/        # Framework-specific prompts (Django, FastAPI, etc.)
│   │   ├── technologies/      # Technology-specific prompts (Firebase, Supabase, etc.)
│   │   ├── protocols/         # Protocol-specific prompts (GraphQL, OAuth, etc.)
│   │   ├── cloud/             # Cloud provider prompts (AWS, Azure, GCP)
│   │   ├── reconnaissance/    # Advanced enumeration techniques
│   │   ├── coordination/      # Multi-agent coordination patterns
│   │   └── custom/            # Community contributions
│   ├── runtime/               # Sandbox runtime management
│   │   ├── runtime.py         # Abstract runtime interface
│   │   ├── docker_runtime.py  # Docker-based sandbox
│   │   └── tool_server.py     # FastAPI tool execution server
│   ├── tools/                 # Agent tool implementations
│   │   ├── registry.py        # Decorator-based tool registration
│   │   ├── executor.py        # Tool execution (sandbox vs local)
│   │   ├── agents_graph/      # Multi-agent coordination tools
│   │   ├── browser/           # Playwright browser automation
│   │   ├── proxy/             # Caido HTTP proxy integration
│   │   ├── terminal/          # Terminal session management (tmux)
│   │   ├── python/            # Python code execution
│   │   ├── file_edit/         # File manipulation
│   │   ├── notes/             # Knowledge management
│   │   ├── reporting/         # Vulnerability reporting
│   │   ├── thinking/          # Reasoning/planning tool
│   │   ├── web_search/        # Perplexity API integration
│   │   └── finish/            # Scan completion
│   └── telemetry/             # Observability and tracing
│       └── tracer.py          # Global event tracer
├── .gitignore                 # Git ignore patterns
├── .pre-commit-config.yaml    # Pre-commit hooks configuration
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # Apache 2.0 license
├── Makefile                   # Development automation
├── README.md                  # User-facing documentation
├── poetry.lock                # Locked dependencies
└── pyproject.toml             # Project configuration and dependencies
```

---

## Architecture Deep Dive

### 1. System Architecture Overview

Strix uses a **multi-agent architecture** where specialized AI agents collaborate to perform security testing. Each agent runs in isolation but shares a common Docker sandbox for efficiency and collaboration.

```
┌─────────────────────────────────────────────────────────────┐
│                     Host Machine                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                 CLI/TUI Interface                     │  │
│  │         (strix/interface/main.py)                     │  │
│  └───────────────────┬───────────────────────────────────┘  │
│                      │                                       │
│  ┌───────────────────▼───────────────────────────────────┐  │
│  │            Root Strix Agent                          │  │
│  │  - Coordination only (no testing)                    │  │
│  │  - Creates specialized sub-agents                    │  │
│  │  - Compiles final reports                            │  │
│  └───────────────────┬───────────────────────────────────┘  │
│                      │                                       │
│         ┌────────────┼────────────┬────────────────┐        │
│         ▼            ▼            ▼                ▼        │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐    ┌──────────┐   │
│  │  Recon   │ │   SQLi   │ │   XSS    │... │ Validator│   │
│  │  Agent   │ │  Agent   │ │  Agent   │    │  Agent   │   │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘    └────┬─────┘   │
│       │            │            │               │          │
│       └────────────┴────────────┴───────────────┘          │
│                    │ Tool Calls (HTTP)                     │
└────────────────────┼───────────────────────────────────────┘
                     │
┌────────────────────▼───────────────────────────────────────┐
│          Docker Container (Shared Sandbox)                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Tool Server (FastAPI)                     │   │
│  │  - Per-agent worker processes                       │   │
│  │  - Bearer token authentication                      │   │
│  │  - Process isolation for tool execution             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Security Tools                         │   │
│  │  - Nmap, SQLMap, Nuclei, FFuf, etc.                │   │
│  │  - Browser (Playwright Chromium)                   │   │
│  │  - HTTP Proxy (Caido)                              │   │
│  │  - Terminal (tmux sessions)                        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  /workspace/  - Source code or cloned repos                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2. Component Details

#### A. Entry Point & CLI (`strix/interface/`)

**main.py** - Orchestrates the entire flow:

1. **Environment Validation**: Checks `STRIX_LLM`, `LLM_API_KEY`, optional variables
2. **Docker Setup**: Verifies Docker installation, pulls `ghcr.io/usestrix/strix-sandbox`
3. **LLM Warm-up**: Tests connection to configured LLM provider
4. **Target Processing**: Infers target types (repo, local code, web app, domain)
5. **Interface Selection**: Routes to CLI (headless) or TUI (interactive)

**CLI Modes:**
- **Interactive TUI** (`tui.py`): Full Textual interface with live updates, agent graph visualization
- **Non-Interactive CLI** (`cli.py`): Headless mode for CI/CD, real-time vulnerability output, exits with code 2 if vulnerabilities found

#### B. Agent System (`strix/agents/`)

**Design Pattern:** Metaclass-based with automatic Jinja2 configuration

**BaseAgent** (`base_agent.py`):
- Uses `AgentMeta` metaclass for auto-configuration of Jinja2 environment
- Implements core agent loop (max 300 iterations)
- State management, error handling, message processing
- Tool execution coordination

**Agent Loop Flow:**
```python
while not should_stop:
    1. Check for incoming messages from other agents
    2. Check if waiting for input or cancellation
    3. Generate LLM response with system prompt + history
    4. Parse and execute tool invocations
    5. Handle errors and update state
    6. Add observations to history
```

**StrixAgent** (`StrixAgent/strix_agent.py`):
- Main implementation for security testing
- Root agents get "root_agent" coordination prompt
- Multi-target scan configuration support

**AgentState** (`state.py`):
Pydantic model tracking:
- Agent ID, parent ID, sandbox info
- Conversation history (messages)
- Iteration count, completion status
- Actions taken, observations, errors
- Waiting states and timeout handling

#### C. Tools System (`strix/tools/`)

**Registry Pattern** (`registry.py`):
```python
@register_tool(sandbox_execution=True)  # or False
def my_tool(arg1: str, arg2: int) -> str:
    """Tool implementation"""
    pass
```

- Decorator-based registration
- XML schema loading from co-located `*_schema.xml` files
- Dynamic schema injection (e.g., available prompt modules)
- Dual execution modes: sandbox (Docker) vs local (host)

**Tool Execution Flow** (`executor.py`):
1. Validate tool availability
2. Determine execution location (sandbox vs local)
3. For sandbox: HTTP POST to tool server with auth token
4. For local: Direct function call with argument conversion
5. Process results, extract screenshots if present
6. Return formatted XML observation

**Available Tool Categories:**

| Tool Category | Purpose | Execution |
|--------------|---------|-----------|
| `agents_graph` | Multi-agent coordination (create, message, view) | Local |
| `browser` | Playwright browser automation | Sandbox |
| `proxy` | Caido HTTP interception | Sandbox |
| `terminal` | Terminal sessions (tmux) | Sandbox |
| `python` | Python code execution | Sandbox |
| `file_edit` | File manipulation | Sandbox |
| `notes` | Knowledge management | Sandbox |
| `reporting` | Vulnerability reporting | Local |
| `thinking` | Reasoning/planning | Local |
| `web_search` | Perplexity API search | Local |
| `finish` | Scan completion | Local |

#### D. Runtime & Sandboxing (`strix/runtime/`)

**Docker Runtime** (`docker_runtime.py`):

**Container Management:**
- One container per scan (reused across agents for efficiency)
- Named: `strix-scan-{scan_id}`
- Labeled with scan ID for discovery
- Base: Kali Linux Rolling with comprehensive tooling

**Container Features:**
- Caido proxy on dynamic port
- Tool server (FastAPI) on dynamic port
- Capabilities: `NET_ADMIN`, `NET_RAW`
- User: `pentester` with passwordless sudo
- Workspace: `/workspace` for source code

**Initialization Sequence:**
1. Start Caido proxy server
2. Launch tool server (FastAPI app)
3. Copy local source code to `/workspace` if provided
4. Register agent with tool server

**Tool Server** (`tool_server.py`):
- FastAPI app running inside Docker
- **Multi-Process Architecture**: Each agent gets dedicated worker process
- **Process Isolation**: Tools run in separate processes via multiprocessing
- **Authentication**: Bearer token auth for all requests

**Endpoints:**
- `POST /execute` - Execute tool with arguments
- `POST /register_agent` - Register new agent worker
- `GET /health` - Health check with active agent list

#### E. LLM Integration (`strix/llm/`)

**LLM Class** (`llm.py`):

**Provider Support:**
- Uses LiteLLM for multi-provider compatibility
- Supports: OpenAI, Anthropic, Azure, local models (Ollama, LMStudio), etc.

**Prompt Caching** (Anthropic models):
- System prompt always cached
- Intermediate messages cached at intervals (every 10-30 messages)
- Max 3 cached breakpoints for cost optimization
- Automatic cache tracking (hits, creation, tokens)

**Features:**
- Memory compression via `MemoryCompressor`
- Request queuing via `RequestQueue`
- Token usage tracking (input, output, cached, cache creation)
- Cost calculation
- Model-specific handling (stop words, reasoning effort)
- Comprehensive error handling for all LiteLLM errors

**LLM Config** (`config.py`):
```python
@dataclass
class LLMConfig:
    model: str                    # From STRIX_LLM env var
    temperature: float = 0        # Deterministic by default
    use_prompt_caching: bool      # Auto-enabled for Anthropic
    prompt_modules: list[str]     # Max 5 modules per agent
```

#### F. Prompt System (`strix/prompts/`)

**Modular Design:**

Specialized knowledge packages loaded dynamically per agent:

```python
create_agent(
    task="Test authentication in API",
    name="Auth Specialist",
    prompt_modules="authentication_jwt,business_logic"
)
```

**Categories:**
- **vulnerabilities/** - SQL injection, XSS, SSRF, XXE, IDOR, RCE, CSRF, JWT, race conditions, etc.
- **frameworks/** - Django, Express, FastAPI, Next.js
- **technologies/** - Supabase, Firebase, Auth0, payment gateways
- **protocols/** - GraphQL, WebSocket, OAuth
- **cloud/** - AWS, Azure, GCP, Kubernetes
- **reconnaissance/** - Advanced enumeration techniques
- **coordination/** - Multi-agent patterns (e.g., root_agent)
- **custom/** - Community contributions

**Prompt Structure:**
Each module is a `.jinja` file with XML-style tags:
```xml
<vulnerability_guide>
<title>SQL INJECTION</title>
<critical>...</critical>
<methodology>...</methodology>
<detection_channels>...</detection_channels>
<validation>...</validation>
<pro_tips>...</pro_tips>
</vulnerability_guide>
```

**Loading System:**
- Dynamic module discovery from Jinja templates
- Validation against available modules
- Injection into agent system prompt via `get_module()` function
- Rendered at agent initialization

#### G. Docker Sandbox Container

**Base Image:** `kalilinux/kali-rolling`

**Installed Tools:**

**Network & Reconnaissance:**
- nmap, ncat, subfinder, httpx, katana, gospider
- naabu, nuclei, ffuf, dirsearch, arjun
- net-tools, dnsutils, whois

**Vulnerability Scanners:**
- sqlmap, wapiti, zaproxy, nuclei
- trivy, semgrep, bandit, trufflehog

**Development & Scripting:**
- Python 3.12+ with venv, pip, poetry
- Node.js, npm, Go
- gcc, build-essential

**Browser & Proxy:**
- Playwright Chromium (headless)
- Caido CLI (HTTP proxy)

**Utilities:**
- jq, ripgrep, curl, wget, git
- tmux, vim, nano
- jwt_tool, JS-Snooper, jsniper

**Custom Configuration:**
- Self-signed CA certificate for MITM testing
- Passwordless sudo for pentester user
- Environment variables for Python/SSL

### 3. Component Interactions

**High-Level Flow:**

```
User → CLI/TUI
    ↓
StrixAgent created with LLMConfig (prompt modules)
    ↓
Docker container started (or reused)
    ↓
Tool server initialized in container
    ↓
Agent loop begins:
    ├→ LLM.generate() with system prompt + modules
    ├→ Parse tool invocations
    ├→ Execute tools (sandbox or local)
    │   ├→ Sandbox: HTTP → Tool Server → Process Worker
    │   └→ Local: Direct function call
    ├→ Process results
    └→ Update state, add to history
    ↓
Agent creates sub-agents via agents_graph.create_agent
    ├→ New AgentState with parent_id
    ├→ New thread spawned
    ├→ Inherit context if specified
    └→ Run independent agent loop
    ↓
Inter-agent messaging via agents_graph.send_message
    ↓
Validation agents verify findings
    ↓
Reporting agents call create_vulnerability_report
    ↓
(White-box only) Fixing agents patch code
    ↓
Root agent calls finish_scan
    ↓
Tracer saves results to agent_runs/{run_name}/
```

**Multi-Agent Coordination:**
- Shared data structures: `_agent_graph`, `_agent_messages`, `_agent_instances`
- Message passing: Agents send XML-formatted messages to each other
- Graph visualization: Tree structure with status tracking
- Process isolation: Each agent in separate thread, but shared Docker container
- Shared resources: `/workspace`, proxy history, notes

**Telemetry** (`telemetry/tracer.py`):
- Global tracer singleton
- Tracks all agent creations, tool executions, messages
- Vulnerability reports stored and indexed
- Scan results saved to disk (`agent_runs/{run_name}/`)
- Callback system for real-time UI updates

### 4. Key Design Patterns

#### 1. Metaclass Pattern (AgentMeta)
Auto-configures Jinja environment per agent class, loads templates from agent-specific directories, reduces boilerplate.

#### 2. Decorator-Based Tool Registration
Tools self-register via `@register_tool`, XML schemas co-located with implementation, clear sandbox vs local separation.

#### 3. Dual Execution Model
Critical tools run locally (agent coordination), most run in sandbox for isolation, transparent to LLM.

#### 4. Process-Based Tool Isolation
Each agent gets dedicated worker process in tool server, prevents state leakage, tools loaded independently.

#### 5. Modular Prompting
Specialized knowledge as composable modules, agents load only relevant expertise (max 5), dynamic injection at runtime.

#### 6. Multi-Agent Graph
Tree structure enforced, parent-child relationships, mandatory validation workflow, message passing coordination.

#### 7. Shared Sandbox Architecture
One Docker container per scan (not per agent), faster creation, shared tools/data, enables collaboration.

#### 8. State Management
Pydantic models for type safety, explicit state transitions, timeout mechanisms, iteration limits with warnings.

#### 9. Error Resilience
Comprehensive LLM error handling, graceful degradation on tool failures, agent cancellation support, cleanup handlers.

#### 10. Observable System
Global tracer for all events, real-time callbacks for UI updates, structured logging, persistence to disk.

#### 11. Caching Strategy
Prompt caching for Anthropic models, smart breakpoint selection, tracks cache hits/creation for cost optimization.

#### 12. XML-Based Tool Protocol
LLM-friendly structured format, single tool call per message, stop word: `</function>`, prevents common errors.

---

## Development Guide

### Prerequisites

- **Python 3.12+**
- **Docker** (running)
- **Poetry** (for dependency management)
- **Git**
- An LLM provider API key (OpenAI, Anthropic, etc.) or local LLM

### Local Development Setup

1. **Clone the repository:**
```bash
git clone https://github.com/usestrix/strix.git
cd strix
```

2. **Install development dependencies:**
```bash
make setup-dev

# or manually:
poetry install --with=dev
poetry run pre-commit install
```

3. **Configure LLM provider:**
```bash
export STRIX_LLM="openai/gpt-5"
export LLM_API_KEY="your-api-key"

# Optional:
export LLM_API_BASE="your-api-base-url"  # For local models
export PERPLEXITY_API_KEY="your-api-key"  # For search
```

4. **Run Strix in development mode:**
```bash
poetry run strix --target https://example.com
```

### Project Configuration

**pyproject.toml** - Comprehensive configuration:

**Dependencies:**
- **LLM:** litellm (~1.79.1), openai (>=1.99.5,<1.100.0)
- **Web:** fastapi, uvicorn, requests, playwright, docker
- **CLI/TUI:** rich, textual, IPython
- **Utilities:** pydantic, tenacity, gql, xmltodict, pyte, libtmux

**Dev Dependencies:**
- **Type Checking:** mypy, pyright
- **Linting:** ruff, pylint
- **Security:** bandit
- **Testing:** pytest, pytest-asyncio, pytest-cov, pytest-mock
- **Formatting:** black, isort
- **Automation:** pre-commit

**Code Quality Standards:**
- Line length: 100 characters
- Type hints: Required (strict mode)
- Python version: 3.12
- Test coverage: 80% minimum

### Makefile Commands

```bash
# Development Setup
make setup-dev       # Install all dev dependencies + pre-commit
make install         # Install production dependencies only
make dev-install     # Install dev dependencies

# Code Quality
make format          # Format code with ruff
make lint            # Lint with ruff and pylint
make type-check      # Type check with mypy and pyright
make security        # Security scan with bandit
make check-all       # Run all quality checks

# Testing
make test            # Run tests with pytest
make test-cov        # Run tests with coverage reporting

# Development
make pre-commit      # Run pre-commit hooks on all files
make clean           # Clean up cache files and artifacts
make dev             # Full dev cycle: format, lint, type-check, test
```

### Code Style Guidelines

**From CONTRIBUTING.md:**

- Follow PEP 8 with 100-character line limit
- Use type hints for all functions
- Write docstrings for public methods
- Keep functions focused and small
- Use meaningful variable names

**Ruff Configuration:**
- Comprehensive rule sets: pycodestyle, Pyflakes, isort, pep8-naming, pyupgrade, bandit, bugbear, etc.
- Auto-fix enabled for most rules
- Ignores: S101 (assert), COM812 (trailing comma), TRY003 (exception messages)

**Type Checking:**
- Strict mode enabled for mypy and pyright
- Disallow untyped definitions
- Warn on redundant casts, unused ignores, unreachable code
- Third-party library overrides configured

### Adding New Features

#### Adding a New Tool

1. Create tool directory: `strix/tools/my_tool/`
2. Create `__init__.py` with tool function:
```python
from strix.tools.registry import register_tool

@register_tool(sandbox_execution=True)  # or False
def my_tool(arg1: str, arg2: int) -> str:
    """
    Tool description.

    Args:
        arg1: First argument
        arg2: Second argument

    Returns:
        Result string
    """
    # Implementation
    return "result"
```

3. Create `my_tool_schema.xml`:
```xml
<tool_description>
<tool_name>my_tool</tool_name>
<description>What this tool does</description>
<parameters>
<parameter>
<name>arg1</name>
<type>string</type>
<description>Description of arg1</description>
<required>true</required>
</parameter>
</parameters>
</tool_description>
```

4. Add to `strix/tools/__init__.py` imports if needed
5. If sandbox execution, copy to Docker in `containers/Dockerfile`

#### Adding a New Prompt Module

1. Choose category: `vulnerabilities/`, `frameworks/`, `technologies/`, etc.
2. Create `.jinja` file with structured content:
```jinja
<module_guide>
<title>MODULE NAME</title>
<critical>Why this matters</critical>
<methodology>
1. Step-by-step approach
</methodology>
<techniques>
- Specific techniques
- Working examples
</techniques>
<validation>
How to confirm findings
</validation>
<pro_tips>
Advanced insights
</pro_tips>
</module_guide>
```

3. Submit via PR with clear description
4. See `strix/prompts/README.md` for detailed guidelines

### File Organization

**Key Files for Common Tasks:**

| Task | Files to Modify |
|------|----------------|
| Add tool | `strix/tools/{tool_name}/__init__.py`, `{tool_name}_schema.xml` |
| Add prompt | `strix/prompts/{category}/{name}.jinja` |
| Modify agent behavior | `strix/agents/base_agent.py`, `strix/agents/StrixAgent/` |
| Change LLM logic | `strix/llm/llm.py`, `strix/llm/config.py` |
| Update UI | `strix/interface/cli.py`, `strix/interface/tui.py` |
| Docker sandbox | `containers/Dockerfile`, `containers/docker-entrypoint.sh` |
| Runtime | `strix/runtime/docker_runtime.py`, `strix/runtime/tool_server.py` |

---

## Git Branch Information

### Current Branch

**Branch:** `claude/document-archive-analysis-011CUvdtnSVKtigC5eE98hxF`
**Status:** Clean (no uncommitted changes at start)
**Remote:** `origin/claude/document-archive-analysis-011CUvdtnSVKtigC5eE98hxF`

### Recent Commits (Last 20)

```
b6d9d94 (HEAD) Update README
edd628b Chore: fix discord link in readme
d76c7c5 Fix: update litellm dependency version
b5ddba3 docs: Update README
2763998 chore: Bump version for new release
6a84ea9 feat: add error handling for headless mode in agent execution
cf1d437 feat: improve completion message display for scan results
b9f8ee3 fix: replace raise with sys.exit(1) in clone_repository
2d6db8f feat: enhance agent prompt for multi-target testing
7178307 docs: Update README to include multi-target testing examples
738fdc2 feat: implement multi-target scanning
deee85d chore(deps): bump pypdf from 6.0.0 to 6.1.3
354fd48 chore(deps): bump mammoth from 1.10.0 to 1.11.0
1f29c71 chore: Update Discord invite link in CONTRIBUTING.md
97154c7 docs: Update README with configuration details and headless mode
395013f feat(docs): Enhance README with headless mode and CI/CD integration
ecf5271 feat: Add iteration limit warnings for agent
71c232b feat: Increase agents max_iterations to 300
f2b4ecc refactor: Migrate tracer to new telemetry module
86dd6f5 feat(interface): Introduce non-interactive CLI mode
```

### Commit Message Conventions

Based on recent history:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation updates
- `chore:` - Maintenance tasks
- `refactor:` - Code restructuring
- `chore(deps):` - Dependency updates

### Branch Naming

Current branch follows pattern: `claude/{description}-{session-id}`

**Important:** When pushing, always use:
```bash
git push -u origin <branch-name>
```

Branch must start with 'claude/' and end with matching session ID, otherwise push will fail with 403.

---

## Testing & Quality

### Test Infrastructure

**Framework:** pytest with async support

**Configuration** (pyproject.toml):
```toml
[tool.pytest.ini_options]
minversion = "6.0"
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=strix",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-report=xml",
    "--cov-fail-under=80"
]
testpaths = ["tests"]
asyncio_mode = "auto"
```

**Coverage Requirements:**
- Minimum: 80%
- Reports: Terminal, HTML, XML
- Omit: tests, migrations, `__pycache__`

### Running Tests

```bash
# Basic test run
make test
poetry run pytest -v

# With coverage
make test-cov
poetry run pytest -v --cov=strix --cov-report=html

# Coverage report location
open htmlcov/index.html
```

### Code Quality Tools

#### Ruff (Linter & Formatter)
Fast Python linter with comprehensive rule sets.

**Enabled Rules:**
- E/W (pycodestyle)
- F (Pyflakes)
- I (isort)
- N (pep8-naming)
- S (flake8-bandit security)
- B (flake8-bugbear)
- PL (Pylint)
- And 20+ more categories

```bash
make format      # Auto-format code
make lint        # Lint with auto-fix
```

#### Type Checking

**Mypy:**
- Strict mode enabled
- Disallow untyped definitions
- Disallow any generics
- Warn on redundant casts, unused ignores

**Pyright:**
- Strict type checking mode
- Report missing imports, type issues
- Track unused imports, variables, functions

```bash
make type-check
```

#### Security Scanning

**Bandit:** Security-focused static analysis

```bash
make security
```

**Skipped Checks:**
- B101 (assert statements)
- B601 (shell injection - partial)
- B404/B603/B607 (subprocess imports and calls)

### Pre-commit Hooks

Configured in `.pre-commit-config.yaml`:

**Installation:**
```bash
poetry run pre-commit install
```

**Run manually:**
```bash
make pre-commit
poetry run pre-commit run --all-files
```

**Hooks:**
- Trailing whitespace removal
- EOF fixer
- YAML/TOML validation
- Python syntax check
- Large file prevention
- Merge conflict detection

### Quality Checklist

Before submitting PR:
```bash
make check-all  # Runs: format, lint, type-check, security
```

All checks must pass.

---

## Deployment & Operations

### Installation Methods

#### 1. User Installation (pipx)

**Recommended for end users:**
```bash
pipx install strix-agent
```

#### 2. Development Installation (poetry)

**For contributors:**
```bash
git clone https://github.com/usestrix/strix.git
cd strix
poetry install --with=dev
```

#### 3. Production Installation (pip)

```bash
pip install strix-agent
```

### Configuration

**Required Environment Variables:**
```bash
export STRIX_LLM="openai/gpt-5"         # LLM provider and model
export LLM_API_KEY="your-api-key"       # API key
```

**Optional Environment Variables:**
```bash
export LLM_API_BASE="http://localhost:8080"  # For local LLMs
export PERPLEXITY_API_KEY="your-key"         # For web search
```

**Supported LLM Providers** (via LiteLLM):
- OpenAI (GPT-4, GPT-5, etc.)
- Anthropic (Claude Sonnet, Opus, Haiku)
- Azure OpenAI
- Google (Gemini)
- Local models via Ollama, LMStudio
- 100+ providers supported

See: https://docs.litellm.ai/docs/providers

### Usage Examples

**Local codebase analysis:**
```bash
strix --target ./app-directory
```

**Repository security review:**
```bash
strix --target https://github.com/org/repo
```

**Web application assessment:**
```bash
strix --target https://your-app.com
```

**Multi-target white-box testing:**
```bash
strix -t https://github.com/org/app -t https://your-app.com
```

**Multiple environments:**
```bash
strix -t https://dev.app.com -t https://staging.app.com -t https://prod.app.com
```

**Focused testing with instructions:**
```bash
strix --target api.app.com --instruction "Prioritize authentication and authorization"
```

**Testing with credentials:**
```bash
strix --target https://app.com --instruction "Test with testuser/testpass. Focus on privilege escalation."
```

### Headless Mode (CI/CD)

Run programmatically without interactive UI:

```bash
strix -n --target https://your-app.com --instruction "Focus on auth vulnerabilities"
```

**Behavior:**
- Prints real-time vulnerability findings
- Displays final report before exit
- Exits with code 2 if vulnerabilities found
- Exits with code 0 if clean
- Exits with code 1 on errors

### GitHub Actions Integration

**Example workflow:**

```yaml
name: strix-penetration-test

on:
  pull_request:

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Strix
        run: pipx install strix-agent

      - name: Run Strix
        env:
          STRIX_LLM: ${{ secrets.STRIX_LLM }}
          LLM_API_KEY: ${{ secrets.LLM_API_KEY }}
        run: strix -n -t ./
```

**Required Secrets:**
- `STRIX_LLM` - e.g., "openai/gpt-5"
- `LLM_API_KEY` - Your LLM provider API key

### Docker Container

**Image:** `ghcr.io/usestrix/strix-sandbox`

**Building locally:**
```bash
cd containers
docker build -t strix-sandbox:local .
```

**Container specs:**
- Base: Kali Linux Rolling
- Size: ~3-4 GB (with all tools)
- User: pentester (passwordless sudo)
- Workspace: /workspace
- Entrypoint: docker-entrypoint.sh

**Environment variables in container:**
- `STRIX_SANDBOX_MODE=true`
- `PYTHONPATH=/app`
- `VIRTUAL_ENV=/app/venv`
- `REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt`

### Output & Results

**Result Location:**
```
agent_runs/<run-name>/
├── vulnerabilities/        # Vulnerability reports
├── agent_graph.json       # Agent tree structure
├── messages.json          # Inter-agent messages
└── scan_summary.json      # Final summary
```

**Vulnerability Report Format:**
```json
{
  "id": "unique-id",
  "title": "SQL Injection in /api/users",
  "severity": "high",
  "description": "...",
  "impact": "...",
  "proof_of_concept": "...",
  "remediation": "...",
  "cve_references": [],
  "discovered_by": "agent-id",
  "validated": true
}
```

### Security Architecture

**Container Isolation:**
- All testing in sandboxed Docker environments
- Network isolation configurable
- Capabilities: NET_ADMIN, NET_RAW (for security tools)

**Local Processing:**
- Testing runs locally
- No data sent to external services (except LLM API)
- Code stays on your machine

**Warning:**
> Only test systems you own or have permission to test. You are responsible for using Strix ethically and legally.

---

## Contributing Guidelines

### How to Contribute

**From CONTRIBUTING.md:**

#### 1. Code Contributions

**Process:**
1. Create an issue first describing the problem or feature
2. Fork and branch from `main`
3. Make your changes following code style
4. Write/update tests ensuring coverage
5. Run quality checks: `make check-all` must pass
6. Submit PR linking to issue with context

**PR Guidelines:**
- Clear description explaining what and why
- Small, focused changes (one feature/fix per PR)
- Include examples showing before/after behavior
- Update documentation if adding features
- Pass all checks (tests, linting, type checking)

#### 2. Prompt Module Contributions

**Quick Guide:**
1. Choose the right category (`/vulnerabilities`, `/frameworks`, `/technologies`, etc.)
2. Create a `.jinja` file with your prompts
3. Include practical examples (working payloads, commands, test cases)
4. Provide validation methods (how to confirm findings, avoid false positives)
5. Submit via PR with clear description

See `strix/prompts/README.md` for detailed guidelines.

#### 3. Reporting Issues

**Include:**
- Python version and OS
- Strix version
- LLMs being used
- Full error traceback
- Steps to reproduce
- Expected vs actual behavior

#### 4. Feature Requests

**Process:**
- Check existing issues first
- Describe the use case clearly
- Explain why it would benefit users
- Consider implementation approach
- Be open to discussion

### Community

**Discord:** https://discord.gg/YjKFvEZSdZ
**GitHub Issues:** https://github.com/usestrix/strix/issues
**GitHub Discussions:** For questions and ideas

### Recognition

Contributors are:
- Listed in release notes
- Thanked in Discord
- Added to contributors list (coming soon)

### Code of Conduct

**Principles:**
- Ethical use only - test systems you own or have permission to test
- Responsible disclosure of vulnerabilities
- Respectful communication
- Collaborative problem-solving

---

## Additional Resources

### Documentation

- **User Documentation:** README.md
- **Contribution Guide:** CONTRIBUTING.md
- **Prompt Authoring:** strix/prompts/README.md
- **License:** Apache 2.0 (LICENSE file)

### Links

- **Website:** https://usestrix.com
- **GitHub:** https://github.com/usestrix/strix
- **PyPI:** https://pypi.org/project/strix-agent/
- **Discord:** https://discord.gg/YjKFvEZSdZ
- **LiteLLM Docs:** https://docs.litellm.ai/docs/providers

### Enterprise

For enterprise features:
- Executive dashboards
- Custom fine-tuned models
- CI/CD integration support
- Large-scale scanning
- Third-party integrations
- Enterprise support

Visit: https://usestrix.com

---

## Appendix: Quick Reference

### Common Commands

```bash
# Development
make setup-dev          # Setup dev environment
make check-all          # Run all quality checks
make test-cov           # Run tests with coverage

# Usage
strix --target ./code                    # Local code
strix --target https://github.com/org/repo  # Repository
strix --target https://app.com           # Web app
strix -n --target ./code                 # Headless mode

# Environment
export STRIX_LLM="openai/gpt-5"
export LLM_API_KEY="your-key"
```

### File Path Quick Reference

```
Entry Point:        strix/interface/main.py
CLI Handler:        strix/interface/cli.py
TUI Handler:        strix/interface/tui.py
Base Agent:         strix/agents/base_agent.py
Main Agent:         strix/agents/StrixAgent/strix_agent.py
Tool Registry:      strix/tools/registry.py
Tool Executor:      strix/tools/executor.py
LLM Client:         strix/llm/llm.py
Docker Runtime:     strix/runtime/docker_runtime.py
Tool Server:        strix/runtime/tool_server.py
Dockerfile:         containers/Dockerfile
Dependencies:       pyproject.toml
Makefile:           Makefile
```

### Environment Variables

| Variable | Required | Purpose |
|----------|----------|---------|
| `STRIX_LLM` | Yes | LLM provider and model (e.g., "openai/gpt-5") |
| `LLM_API_KEY` | Yes | API key for LLM provider |
| `LLM_API_BASE` | No | Base URL for local LLMs |
| `PERPLEXITY_API_KEY` | No | For web search capabilities |
| `STRIX_SANDBOX_MODE` | Auto | Set in container (internal) |

### Agent Tool Categories

| Category | Tools | Execution |
|----------|-------|-----------|
| Coordination | create_agent, send_message, view_graph, agent_finish | Local |
| Browser | open_page, click, fill, screenshot, etc. | Sandbox |
| Proxy | start_proxy, intercept, modify_request, etc. | Sandbox |
| Terminal | create_session, run_command, etc. | Sandbox |
| Python | execute_python | Sandbox |
| Files | read_file, write_file, edit_file | Sandbox |
| Notes | create_note, update_note, list_notes | Sandbox |
| Reporting | create_vulnerability_report | Local |
| Thinking | think, plan, analyze | Local |
| Search | web_search | Local |
| Finish | finish_scan | Local |

---

**End of CLAUDE.md**

*This documentation is current as of 2025-11-08 for Strix version 0.3.2*
