# Research-Plan-Implement Framework for GitHub Copilot

Forked from the Claude Code specific version: https://github.com/brilliantconsultingdev/claude-research-plan-implement

A structured workflow framework for AI-assisted software development with **GitHub Copilot** — both in **VS Code** and in **Copilot CLI**. It emphasizes thorough research, detailed planning, and systematic implementation, with all context persisted as Markdown under `thoughts/`.

## 🚀 Quick Start

```bash
# Install the framework into a target repository
./setup.sh /path/to/your/repo

# Or, run it interactively
./setup.sh
```

After installation, open the target repo in VS Code (or `cd` into it and run `copilot`) and type `/` in chat to see the workflow prompts.

## 📁 What's Included

```
copilot-research-plan-implement/
├── .github/
│   ├── agents/                            # Custom subagents (.agent.md)
│   │   ├── codebase-locator.agent.md      # Finds WHERE code lives
│   │   ├── codebase-analyzer.agent.md     # Explains HOW code works
│   │   └── codebase-pattern-finder.agent.md  # Finds patterns to follow
│   └── prompts/                           # Workflow slash-commands (.prompt.md)
│       ├── 1_research_codebase.prompt.md
│       ├── 2_create_plan.prompt.md
│       ├── 3_validate_plan.prompt.md
│       ├── 4_implement_plan.prompt.md
│       ├── 5_save_progress.prompt.md
│       ├── 6_resume_work.prompt.md
│       ├── 7_research_cloud.prompt.md
│       └── 8_define_test_cases.prompt.md
├── thoughts/                              # Persistent context storage
│   └── shared/
│       ├── research/    # NNN_topic.md
│       ├── plans/       # NNN_feature.md
│       ├── sessions/    # NNN_feature.md
│       └── cloud/       # NNN_platform.md
├── AGENTS.md                              # Primary cross-tool instructions
├── PLAYBOOK.md                            # Full documentation
├── setup.sh                               # Installer
├── update.sh                              # Update wrapper
└── README.md                              # This file
```

## 🔄 Workflow Commands

The framework follows a structured workflow:

### 1️⃣ Research Codebase (`/1_research_codebase`)
**Purpose**: Deep dive into the codebase using parallel AI agents
**Usage**: Provide a research question or area to explore
**Output**: Comprehensive findings saved to `thoughts/shared/research/`
**Example**: "How does the authentication system work?"

### 2️⃣ Create Plan (`/2_create_plan`)
**Purpose**: Generate detailed, phased implementation plans
**Usage**: Describe the feature or change you want to implement
**Output**: Structured plan saved to `thoughts/shared/plans/`
**Example**: "Add OAuth2 integration to the authentication system"

### 3️⃣ Validate Plan (`/3_validate_plan`)
**Purpose**: Verify implementation matches the plan's success criteria
**Usage**: Automatically checks against the most recent plan
**Output**: Validation report confirming all phases are complete
**Example**: Just run `/3_validate_plan` after implementation

### 4️⃣ Implement Plan (`/4_implement_plan`)
**Purpose**: Execute a plan systematically, phase by phase
**Usage**: Provide path to a plan file or describe what to implement
**Output**: Code changes following the plan's specifications
**Example**: `thoughts/shared/plans/oauth2_integration.md`

### 5️⃣ Save Progress (`/5_save_progress`)
**Purpose**: Save current work session state for continuity
**Usage**: Creates a session summary documenting work progress
**Output**: Session file in `thoughts/shared/sessions/`
**Example**: Use when stopping work mid-task

### 6️⃣ Resume Work (`/6_resume_work`)
**Purpose**: Resume from a previously saved session
**Usage**: Loads context from a session file
**Output**: Restored context and work continuation
**Example**: `thoughts/shared/sessions/002_oauth2.md`

### 7️⃣ Research Cloud (`/7_research_cloud`)
**Purpose**: Analyze cloud infrastructure using READ-ONLY CLI operations
**Usage**: Specify cloud platform (Azure/AWS/GCP) and focus area
**Output**: Infrastructure analysis in `thoughts/shared/cloud/`
**Example**: "Analyze Azure production environment"

### 8️⃣ Define Test Cases (`/8_define_test_cases`)
**Purpose**: Design acceptance test cases using DSL approach with comment-first structure
**Usage**: Describe feature to test; agent researches existing test patterns first
**Output**: Test case definitions in comments + list of required DSL functions
**Example**: "Define test cases for partner enrollment workflow"

## 📖 Documentation

- **[PLAYBOOK.md](PLAYBOOK.md)** - Complete guide with examples and best practices
- **Command Files** - Each command file contains detailed instructions for that phase
- **Agent Files** - Define specialized AI agents for specific tasks

## 🎯 Key Benefits

- **📚 Knowledge Accumulation**: Research and plans persist in `thoughts/` directory
- **⚡ Parallel Processing**: Multiple AI agents work simultaneously during research
- **✅ Quality Assurance**: Built-in validation and success criteria
- **🔍 Deep Understanding**: Thorough research before implementation
- **📋 Clear Specifications**: Detailed plans prevent scope creep

## 🛠 Customization

After installation, customize for your project:

1. **Edit command files** to match your tooling (test commands, linting, etc.)
2. **Update CLAUDE.md** with project-specific conventions
3. **Modify agent tools** if needed
4. **Adjust directory paths** in commands

## 💡 Typical Workflow Example

```markdown
# 1. Research the existing codebase
/1_research_codebase
> How does the authentication system work?

# 2. Create a plan based on research
/2_create_plan
> Add OAuth2 integration to the authentication system

# 3. Implement the plan
/4_implement_plan
> thoughts/shared/plans/oauth2_integration.md

# 4. Validate implementation matches plan
/3_validate_plan

# 5. Save progress if needed to pause
/5_save_progress

# 6. Resume work later
/6_resume_work
> thoughts/shared/sessions/002_oauth2.md
```

## ☁️ Cloud Analysis Example

```markdown
# Analyze your cloud infrastructure (READ-ONLY)
/7_research_cloud
> Azure
> all
```

## 🧪 Test-Driven Development Example

```markdown
# 1. Define test cases for a new feature
/8_define_test_cases
> Partner enrollment workflow with kit orders

# 2. Implement the DSL functions and tests
# (Follow the patterns discovered by the agent)

# 3. Implement the actual feature to make tests pass
/4_implement_plan
> Implement partner enrollment logic
```

## 📝 License

This framework structure is provided as-is for use in your projects. Adapt and modify as needed for your specific requirements.
