## Lab 12 - Custom Agents Hands-On

## 01 - Agent Types Overview

??? question "Task: Compare Agent Types"

    Review the two approaches to creating custom agents:

    1. **YAML-Based Agents** - declarative, stored in `.github/agents/`, no coding required.
    2. **VS Code Extension Agents** - programmatic, TypeScript/JavaScript, more powerful.

    - Which approach would you choose for a domain-specific expert? Why?
    - Which approach would you choose for a workflow that integrates with external APIs?

---

## 02 - Examine the @agent-time Agent

??? question "Task: Read the Agent File"

    1. Navigate to `.github/agents/agent-time.yml` in the project.
    2. Read through the entire YAML file and identify each section:
        - **Metadata** - name, description, agent model
        - **Instructions** - system prompt with responsibilities
        - **Tools** - capabilities declared
        - **Expertise** - knowledge domains
        - **Examples** - sample interactions
    3. Answer:
        - What default cities does the agent display?
        - What output format does it use?
        - Which Python modules does it recommend?

---

## 03 - Use the @agent-time Agent

??? question "Task: Test the Agent"

    1. Open the **GitHub Copilot Chat** panel.
    2. Type `@agent-time` to invoke the World Time Specialist.
    3. Try each of these prompts and observe the responses:

        **Prompt 1 - Basic Time Query:**
        ```text
        @agent-time Show me the current hour in 4 major cities
        ```

        **Prompt 2 - Implementation Request:**
        ```text
        @agent-time Create a Python script to display world times
        ```

        **Prompt 3 - Specific Cities:**
        ```text
        @agent-time What time is it in Paris, Berlin, and Moscow?
        ```

        **Prompt 4 - Time Conversion:**
        ```text
        @agent-time If it's 3 PM in New York, what time is it in Tokyo?
        ```

    4. For each response, verify:
        - Does it follow the emoji format from the YAML?
        - Does it use `datetime` and `zoneinfo`?
        - Does it include UTC time?

---

## 04 - Test Agent Behavior

??? question "Task: Verify Instruction Compliance"

    Test how strictly the agent follows its instructions:

    1. **Default Cities** - Type `@agent-time show time`. Does it show New York, London, Tokyo, Sydney?
    2. **Output Format** - Type `@agent-time display world clock`. Does it use emojis and include UTC?
    3. **Implementation** - Type `@agent-time write a function to get city time`. Does it use the code patterns from the YAML?
    4. **DST Knowledge** - Type `@agent-time Explain daylight saving time for New York`. Does it demonstrate DST expertise?

---

## 05 - Build a Test Generator Agent

??? question "Task: Create Your Own Agent"

    Follow these steps to create a **Python Test Generator** agent from scratch:

    1. Create the folder `.github/agents/` if it doesn't exist.
    2. Create a new file: `.github/agents/test-generator.yml`
    3. Add the metadata:
        ```yaml
        name: Python Test Generator
        description: Expert in creating comprehensive pytest tests following best practices
        agent: gpt-4o
        ```
    4. Write the `instructions` section. Include:
        - Role definition ("You are a Python testing expert...")
        - Testing principles (Arrange-Act-Assert, descriptive names, parametrize)
        - Default test structure with code template
        - Coverage goals (happy path, edge cases, error cases)
    5. Add `tools` and `expertise` sections.
    6. Add at least 2 `examples` with prompt/response pairs.
    7. Test the agent: `@test-generator Generate tests for my Calculator class`

---

## 06 - Best Practices Checklist

??? question "Task: Review Your Agent"

    Use this checklist to validate your test-generator agent:

    - [ ] **Clear role** - Does the instructions section define who the agent is?
    - [ ] **Specific responsibilities** - Are tasks listed explicitly?
    - [ ] **Code patterns** - Does it include template code in instructions?
    - [ ] **Examples** - At least 2 example interactions included?
    - [ ] **Tools & expertise** - Capabilities and knowledge areas listed?
    - [ ] **Consistent format** - Follows the same structure as @agent-time?
    - [ ] **Tested** - Tried with at least 3 different prompts?
