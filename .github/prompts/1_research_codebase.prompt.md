---
description: Deep codebase exploration with parallel subagents
argument-hint: A research question or area of interest
tools: ['search', 'read/readFile', 'edit/editFiles', 'agent/runSubagent', 'todos']
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer the user's question by dispatching parallel subagents and synthesizing their findings.

## Initial Setup

If the user did not include a research question in the prompt invocation, respond with:
```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```
Then wait for the user's research query.

## Steps to follow after receiving the research query

1. **Read any directly mentioned files first:**
   - If the user mentions specific files, read them FULLY first (no offset/limit)
   - Read these files yourself in the main context before dispatching any subagents

2. **Analyze and decompose the research question:**
   - Break down the user's query into composable research areas
   - Identify specific components, patterns, or concepts to investigate
   - Use the `todos` tool to track all subtasks
   - Consider which directories, files, or architectural patterns are relevant

3. **Dispatch parallel subagents for comprehensive research:**
   - Use the `agent` tool to invoke the following custom agents (defined in `.github/agents/`) **in parallel** when they have independent work:
     - `codebase-locator` — to find WHERE relevant code lives
     - `codebase-analyzer` — to understand HOW components work
     - `codebase-pattern-finder` — to find similar implementations to model after
   - Each subagent invocation should be focused and specific
   - Run multiple subagents concurrently whenever their tasks don't depend on one another

4. **Wait for all subagents to complete and synthesize findings:**
   - Wait for ALL subagent results before proceeding
   - Compile all results
   - Connect findings across different components
   - Include specific file paths and line numbers for reference
   - Highlight patterns, connections, and architectural decisions

5. **Generate research document:**
   Structure the document with YAML frontmatter followed by content:
   ```markdown
   ---
   date: [Current date and time in ISO format]
   researcher: GitHub Copilot
   topic: "[User's Question/Topic]"
   tags: [research, codebase, relevant-component-names]
   status: complete
   ---

   # Research: [User's Question/Topic]

   ## Research Question
   [Original user query]

   ## Summary
   [High-level findings answering the user's question]

   ## Detailed Findings

   ### [Component/Area 1]
   - Finding with reference (file.ext:line)
   - Connection to other components
   - Implementation details

   ### [Component/Area 2]
   ...

   ## Code References
   - `path/to/file.py:123` - Description of what's there
   - `another/file.ts:45-67` - Description of the code block

   ## Architecture Insights
   [Patterns, conventions, and design decisions discovered]

   ## Open Questions
   [Any areas that need further investigation]
   ```

6. **Save and present findings:**
   - Check existing research files to determine next sequence number
   - Save to `thoughts/shared/research/NNN_topic.md` where NNN is a 3-digit sequential number (001, 002, etc.)
   - Present a concise summary of findings to the user
   - Include key file references for easy navigation

## Important notes:
- Always dispatch parallel subagents to maximize efficiency when their work is independent
- Focus on finding concrete file paths and line numbers
- Research documents should be self-contained with all necessary context
- Each subagent prompt should be specific and focused
- Consider cross-component connections and architectural patterns
