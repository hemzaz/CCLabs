# Lab 12 - Custom Agents & Chat Extensions

## 01 - Introduction

* GitHub Copilot Chat can be extended using **Chat Extensions** (also known as Agents or Participants).
* These allow you to bring your own domain knowledge, tools, and workflows directly into the Copilot Chat interface.
* You interact with them using the `@` symbol (e.g., `@workspace`, `@azure`, `@my-agent`).

---

## 02 - Custom Agents Types

There are two main approaches to creating custom agents:

<div class="grid cards" markdown>

-   :material-file-document-outline:{ .lg .middle } **YAML-Based Agents (Declarative)**

    ---

    **Characteristics:**

    * Simple configuration files
    * Stored in `.github/agents/`
    * Define behavior through YAML
    * No coding required
    * Great for domain-specific experts
    * **Focus of this lab**

    **Best For:**

    * Domain knowledge experts
    * Template-based responses
    * Consistent formatting
    * Quick prototyping

-   :material-cog-outline:{ .lg .middle } **VS Code Extension Agents (Programmatic)**

    ---

    **Characteristics:**

    * Full VS Code extensions
    * Contributes `chatParticipants`
    * TypeScript/JavaScript required
    * More powerful and flexible
    * Execute commands & APIs
    * Real-time interactions

    **Best For:**

    * Complex workflows
    * API integrations
    * File system access
    * Dynamic behavior

</div>

---

## 03 - YAML-Based Agent

* YAML-based agents are defined in the `.github/agents/` folder of your repository.
* Each agent is a single YAML file that describes its behavior, expertise, and instructions.

#### Key Components of a YAML Agent:

| Component          | Description                                              |
|:-------------------|:---------------------------------------------------------|
| **`name`**         | Display name of the agent                                |
| **`description`**  | Brief explanation of what the agent does                 |
| **`agent`**        | AI model to use (e.g., `gpt-4o`, `gpt-4`, `gpt-3.5-turbo`) |
| **`instructions`** | Detailed system prompt that defines the agent's behavior |
| **`tools`**        | List of capabilities the agent has access to             |
| **`expertise`**    | Areas of knowledge and specialization                    |
| **`examples`**     | Sample interactions to guide the agent's responses       |

---

## 04 - Example: @agent-time

* **Example**: **The most advanced World Time Agent** located in `.github/agents/agent-time.yml`.
* Unique development made in **Elbit's** Secret Labs.
* Before continuing, check that you have the right classification for this lab: "YAML-Based Agents".

### Step 1: Define Purpose

The `@agent-time` agent is designed to:
* Display current time across different time zones
* Explain time zone differences between cities
* Handle daylight saving time (DST) considerations
* Provide time conversions between different zones
* Format time displays in various formats (24h, 12h, ISO)

### Step 2: Agent Structure

* #### Metadata

    The top section defines basic metadata:

    ```yaml
    name: World Time Specialist
    description: Expert in displaying current time across different time zones and major cities
    agent: gpt-4o
    ```

    | Field             | Description                                                    |
    |:------------------|:---------------------------------------------------------------|
    | **`name`**        | The friendly name shown when you invoke the agent              |
    | **`description`** | Helps users understand what the agent can do                   |
    | **`agent`**       | The AI model to use (e.g., `gpt-4o`, `gpt-4`, `gpt-3.5-turbo`) |

* #### Instructions Section

    The most important part is the `instructions` field, which contains the system prompt:

    ```yaml
    instructions: |
      You are a time zone expert that helps users understand and display current times
      across different cities and time zones around the world.
      
      ## Your Responsibilities
      
      - Display current time in multiple cities simultaneously
      - Explain time zone differences between cities
      - Handle daylight saving time (DST) considerations
      - Provide time conversions between different zones
      - Format time displays in various formats (24h, 12h, ISO)
    ```

    !!! tip "Instruction Details"
        * Use the `|` character to allow multi-line instructions
        * Clear role definition: "You are a time zone expert"
        * Specific responsibilities listed
        * Defines the scope and boundaries of the agent
    

* #### Default Behavior

    The agent's default behavior is specified in detail:

    ```markdown
    ## Default Cities to Display
    
    When asked to show the time in major cities, use these 4 by default:
    1. **New York** (America/New_York) - EST/EDT
    2. **London** (Europe/London) - GMT/BST
    3. **Tokyo** (Asia/Tokyo) - JST
    4. **Sydney** (Australia/Sydney) - AEDT/AEST
    ```
    
    !!! tip "Default Behavior"
        * Defines default cities for time display
        * Specifies time zones and abbreviations
        * Provides consistent, predictable behavior
        * Covers major time zones globally
        * Reduces ambiguity in user requests

* #### Output 

    Define the desired output format:

    ```markdown
    ## Time Display Format
    
    When displaying times, use this format:
    
    🌍 Current Time in Major Cities
    ================================
    
    🗽 New York:    HH:MM AM/PM (Time Zone Abbreviation)
    🇬🇧 London:     HH:MM (Time Zone Abbreviation)
    🗼 Tokyo:       HH:MM (Time Zone Abbreviation)
    🦘 Sydney:      HH:MM (Time Zone Abbreviation)
    
    📅 Date: YYYY-MM-DD
    ⏰ UTC Time: HH:MM:SS
    ```
    

    !!! tip "Time Display Format"
        * Defines exact output format
        * Uses emojis for visual clarity
        * Ensures consistency across all responses

* #### Implementation Guidelines

    Instruct the agent on how to implement time functionality:

    ````markdown
      ## Implementation Approach
      
      When asked to implement time display functionality:
      
      1. **Use Python's datetime and zoneinfo modules:**
        ```python
        from datetime import datetime
        from zoneinfo import ZoneInfo
        
        def get_city_time(timezone_name):
            return datetime.now(ZoneInfo(timezone_name))
        ```
    ````
    
    !!! tip "Implementation Guidelines"
        * Provides code templates and best practices
        * Specifies which libraries to use
        * Shows implementation patterns

* #### Tools & Expertise

    Describe the agent's capabilities and knowledge:

    ```yaml
    tools:
      - datetime_manipulation
      - timezone_conversion
      - time_display
      - scheduling_assistant

    expertise:
      - Python datetime module
      - zoneinfo module
      - Time zone databases (IANA)
      - DST rules and transitions
      - ISO 8601 formatting
    ```

    | Field           | Description                               |
    |:----------------|:------------------------------------------|
    | **`tools`**     | Capabilities the agent claims to have     |
    | **`expertise`** | Knowledge domains the agent is trained in |

---

#### Examples Section

```yaml
examples:
  - prompt: "Show me the current hour in 4 major cities"
    response: |
      I'll display the current hour in New York, London, Tokyo, and Sydney:
      
      ```python
      from datetime import datetime
      from zoneinfo import ZoneInfo
      
      cities = {
          '🗽 New York': 'America/New_York',
          '🇬🇧 London': 'Europe/London',
          '🗼 Tokyo': 'Asia/Tokyo',
          '🦘 Sydney': 'Australia/Sydney'
      }
      
      print("Current Hour in Major Cities:")
      print("=" * 40)
      
      for city, tz in cities.items():
          now = datetime.now(ZoneInfo(tz))
          hour_24 = now.hour
          hour_12 = now.strftime('%I %p')
          print(f"{city}: {hour_24:02d}:00 ({hour_12})")
      ```
```

* Provides concrete examples of agent interactions
* Demonstrates the expected input/output format
* Helps guide the LLM's responses

---

## 05 - Hands-On

### 01: Examine the Agent File

1. Navigate to [.github/agents/agent-time.yml](.github/agents/agent-time.yml)
2. Read through the entire YAML file
3. Identify each section:
   - Name and description
   - Instructions
   - Tools
   - Expertise
   - Examples

**Discussion Questions:**
* What makes the instructions clear and effective?
* How do the examples help guide the agent's behavior?
* What tools and expertise are declared?

---

### 02: Using the @agent-time Agent

1. Open the GitHub Copilot Chat panel
2. Type `@agent-time` to invoke the World Time Specialist
3. Try these prompts:

      **Prompt 1: Basic Time Query**
      ```
      @agent-time Show me the current hour in 4 major cities
      ```

      **Prompt 2: Implementation Request**
      ```
      @agent-time Create a Python script to display world times
      ```

      **Prompt 3: Specific Cities**
      ```
      @agent-time What time is it in Paris, Berlin, and Moscow?
      ```

      **Prompt 4: Time Conversion**
      ```
      @agent-time If it's 3 PM in New York, what time is it in Tokyo?
      ```

    !!! success "Observe the Responses"
        * Does the agent follow the specified format?
        * Does it use the default cities when appropriate?
        * Does it provide code snippets using `datetime` and `zoneinfo`?
        * How well does it handle DST explanations?

---

### 03: Testing Agent Behavior

Let's test how well the agent follows its instructions:

1. **Test Default Cities:**
   ```
   @agent-time show time
   ```
   * Does it show New York, London, Tokyo, and Sydney by default?

2. **Test Output Format:**
   ```
   @agent-time display world clock
   ```
   * Does it use the emoji format specified?
   * Does it include UTC time?

3. **Test Implementation Guidance:**
   ```
   @agent-time write a function to get city time
   ```
   * Does it use `datetime` and `zoneinfo`?
   * Does it follow the code patterns in the YAML?

4. **Test DST Knowledge:**
   ```
   @agent-time Explain daylight saving time for New York
   ```
   * Does it demonstrate expertise in DST?

---

## 06 - Building Agent

Now let's create a custom agent from scratch!

#### Step-by-Step Guide

#### Step 1: DefineAgent's Purpose

Think about a domain or task where you want specialized assistance:

   * **Code reviewer** for a specific language or framework
   * **Documentation writer** for your project's style
   * **Test generator** following your testing patterns
   * **Database expert** for SQL optimization
   * **API designer** following REST best practices

For this exercise, let's create a **Python Test Generator** agent.

#### Step 2: Create the Agent File

1. Create `.github/agents/` folder if it doesn't exist
2. Create a new file: `.github/agents/test-generator.yml`

#### Step 3: Define Basic Metadata

```yaml
name: Python Test Generator
description: Expert in creating comprehensive pytest tests following best practices
agent: gpt-4o
```

#### Step 4: Write the Instructions

```yaml
instructions: |
  You are a Python testing expert specializing in pytest framework.
  
  ## Your Responsibilities
  
  - Generate comprehensive test cases for Python functions and classes
  - Follow pytest best practices and conventions
  - Include edge cases and error handling tests
  - Use appropriate fixtures and parametrization
  - Write clear test names that describe what is being tested
  
  ## Testing Principles
  
  1. **Arrange-Act-Assert Pattern**: Structure all tests clearly
  2. **One Assertion Per Test**: Keep tests focused and simple
  3. **Descriptive Names**: Use `test_<function>_<scenario>_<expected_result>`
  4. **Fixtures**: Use pytest fixtures for setup and teardown
  5. **Parametrize**: Use `@pytest.mark.parametrize` for multiple test cases
  
  ## Default Test Structure
  
  ```python
  import pytest
  from module import function_to_test
  
  def test_function_with_valid_input():
      # Arrange
      input_data = "valid_value"
      expected = "expected_result"
      
      # Act
      result = function_to_test(input_data)
      
      # Assert
      assert result == expected
  
  def test_function_with_invalid_input():
      # Arrange
      invalid_input = None
      
      # Act & Assert
      with pytest.raises(ValueError):
          function_to_test(invalid_input)
  ```
  
  ## Code Quality Guidelines
  
  - Import only what's needed
  - Use type hints in test functions
  - Add docstrings for complex test scenarios
  - Group related tests in classes
  - Use meaningful fixture names
  
  ## Coverage Goals
  
  For each function, generate tests for:
  - Happy path (normal operation)
  - Edge cases (boundary conditions)
  - Error cases (exceptions)
  - Type validation
  - Null/None handling
```

#### Step 5: Add Tools and Expertise

```yaml
tools:
  - test_generation
  - code_analysis
  - pytest_framework
  - fixture_creation

expertise:
  - pytest framework
  - unittest and mock
  - Test-Driven Development (TDD)
  - Code coverage analysis
  - Python testing best practices
```

#### Step 6: Provide Examples

```yaml
examples:
  - prompt: "Generate tests for a calculator add function"
    response: |
      I'll create comprehensive pytest tests for an add function:
      
      ```python
      import pytest
      from calculator import add
      
      def test_add_positive_numbers():
          """Test addition of two positive numbers."""
          assert add(2, 3) == 5
      
      def test_add_negative_numbers():
          """Test addition of two negative numbers."""
          assert add(-2, -3) == -5
      
      def test_add_mixed_signs():
          """Test addition of positive and negative numbers."""
          assert add(5, -3) == 2
      
      @pytest.mark.parametrize("a,b,expected", [
          (0, 0, 0),
          (1, 0, 1),
          (0, 1, 1),
          (100, 200, 300),
      ])
      def test_add_parametrized(a, b, expected):
          """Test addition with various inputs."""
          assert add(a, b) == expected
      
      def test_add_type_error():
          """Test that add raises TypeError for non-numeric inputs."""
          with pytest.raises(TypeError):
              add("1", 2)
      ```
```

---

## 07 - Complete Example Agent File

Here's the complete `test-generator.yml` file:

<details>
<summary>Click to view complete YAML agent</summary>

```yaml
name: Python Test Generator
description: Expert in creating comprehensive pytest tests following best practices
agent: gpt-4o

instructions: |
  You are a Python testing expert specializing in pytest framework.
  
  ## Your Responsibilities
  
  - Generate comprehensive test cases for Python functions and classes
  - Follow pytest best practices and conventions
  - Include edge cases and error handling tests
  - Use appropriate fixtures and parametrization
  - Write clear test names that describe what is being tested
  
  ## Testing Principles
  
  1. **Arrange-Act-Assert Pattern**: Structure all tests clearly
  2. **One Assertion Per Test**: Keep tests focused and simple
  3. **Descriptive Names**: Use `test_<function>_<scenario>_<expected_result>`
  4. **Fixtures**: Use pytest fixtures for setup and teardown
  5. **Parametrize**: Use `@pytest.mark.parametrize` for multiple test cases
  
  ## Default Test Structure
  
  ```python
  import pytest
  from module import function_to_test
  
  def test_function_with_valid_input():
      # Arrange
      input_data = "valid_value"
      expected = "expected_result"
      
      # Act
      result = function_to_test(input_data)
      
      # Assert
      assert result == expected
  
  def test_function_with_invalid_input():
      # Arrange
      invalid_input = None
      
      # Act & Assert
      with pytest.raises(ValueError):
          function_to_test(invalid_input)
  ```
  
  ## Code Quality Guidelines
  
  - Import only what's needed
  - Use type hints in test functions
  - Add docstrings for complex test scenarios
  - Group related tests in classes
  - Use meaningful fixture names
  
  ## Coverage Goals
  
  For each function, generate tests for:
  - Happy path (normal operation)
  - Edge cases (boundary conditions)
  - Error cases (exceptions)
  - Type validation
  - Null/None handling

tools:
  - test_generation
  - code_analysis
  - pytest_framework
  - fixture_creation

expertise:
  - pytest framework
  - unittest and mock
  - Test-Driven Development (TDD)
  - Code coverage analysis
  - Python testing best practices

examples:
  - prompt: "Generate tests for a calculator add function"
    response: |
      I'll create comprehensive pytest tests for an add function:
      
      ```python
      import pytest
      from calculator import add
      
      def test_add_positive_numbers():
          """Test addition of two positive numbers."""
          assert add(2, 3) == 5
      
      def test_add_negative_numbers():
          """Test addition of two negative numbers."""
          assert add(-2, -3) == -5
      
      def test_add_mixed_signs():
          """Test addition of positive and negative numbers."""
          assert add(5, -3) == 2
      
      @pytest.mark.parametrize("a,b,expected", [
          (0, 0, 0),
          (1, 0, 1),
          (0, 1, 1),
          (100, 200, 300),
      ])
      def test_add_parametrized(a, b, expected):
          """Test addition with various inputs."""
          assert add(a, b) == expected
      
      def test_add_type_error():
          """Test that add raises TypeError for non-numeric inputs."""
          with pytest.raises(TypeError):
              add("1", 2)
      ```
  
  - prompt: "Create fixture for database testing"
    response: |
      I'll create a pytest fixture for database testing:
      
      ```python
      import pytest
      from database import Database
      
      @pytest.fixture
      def db():
          """Create a test database instance."""
          # Setup
          database = Database(":memory:")  # Use in-memory DB for testing
          database.create_tables()
          
          yield database
          
          # Teardown
          database.close()
      
      @pytest.fixture
      def db_with_data(db):
          """Create database with sample data."""
          db.insert("users", {"name": "Alice", "age": 30})
          db.insert("users", {"name": "Bob", "age": 25})
          return db
      
      def test_query_users(db_with_data):
          """Test querying users from database."""
          users = db_with_data.query("SELECT * FROM users")
          assert len(users) == 2
      ```
```

</details>

---

## 08 - Best Practices

### 1. Clear Instructions
* Define a clear role and persona
* Be specific about responsibilities
* Include examples of what TO DO and what NOT to do

### 2. Consistent Format
* Use a standard structure for all agents
* Include sections: Responsibilities, Principles, Guidelines, Examples
* Use Markdown formatting for readability

### 3. Provide Examples
* Include at least 2-3 example interactions
* Show both simple and complex use cases
* Demonstrate expected code style and patterns

### 4. Define Expertise
* List specific technologies and frameworks
* Specify version numbers when relevant
* Indicate level of knowledge (basic, intermediate, expert)

### 5. Specify Tools
* List capabilities the agent can perform
* Be realistic about what the agent can access
* Align tools with the agent's purpose

### 6. Test Thoroughly
* Try edge cases and ambiguous prompts
* Verify the agent follows the format
* Test with different phrasing of the same request

