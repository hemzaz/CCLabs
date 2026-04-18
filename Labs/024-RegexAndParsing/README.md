# Lab 024 - Regex and Text Parsing with Copilot

!!! hint "Overview"

    - Writing regular expressions is notoriously difficult, but GitHub Copilot excels at generating and explaining them.
    - In this lab, you will use Copilot to create regex patterns for validation, extraction, and transformation tasks.
    - You will also build text parsers and data transformation pipelines by describing the input and output formats in plain English.
    - By the end of this lab, you will have a reliable strategy for tackling regex and parsing challenges with Copilot's help.

## Prerequisites

- Completed [Lab 023 - CI Workflows](../023-CIWorkflows/README.md)

## What You Will Learn

- How to generate regex patterns from plain-English descriptions
- How Copilot explains existing regex patterns line by line
- How to build text parsers and log analyzers
- How to write data transformation pipelines

---

## Lab Steps

## Step 1 - Generate Regex from Description

Instead of writing regex manually, describe what you need:

```
Write a regex pattern that matches:
- A valid IPv4 address
- Each octet is 0-255 (no leading zeros for multi-digit numbers)
- Example matches: 192.168.1.1, 10.0.0.1, 255.255.255.0
- Example non-matches: 256.1.1.1, 192.168.1, 192.168.1.1.1
```

```
Write a regex to extract all URLs from a text block, including:
- http and https
- Optional www
- Domain with TLD
- Optional path, query string, and fragment
- Do NOT match URLs inside HTML attribute values like href="..."
```

## Step 2 - Explain Existing Regex

Paste a cryptic pattern:

```
Explain this regex pattern step by step:
^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$
```

## Step 3 - Log File Parser

```
Write a Python function to parse Apache access log lines into structured data.

Example log line:
192.168.1.100 - frank [10/Oct/2024:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326

Return a dict with: ip, user, timestamp (as datetime), method, path,
http_version, status_code, bytes_sent
```

## Step 4 - Build a Config File Parser

```
Write a parser for this custom config format:

[database]
host = localhost
port = 5432
name = myapp_db

[cache]
host = redis://localhost
ttl = 3600

# This is a comment
[api]
base_url = https://api.example.com
timeout = 30

Parse it into a nested Python dict. Support comments (lines starting with #),
sections ([name]), and key=value pairs. Strip whitespace around keys and values.
```

## Step 5 - CSV/TSV Data Transformation

```
Write a Python script to transform this CSV data:
- Input: raw_orders.csv with columns: order_id, customer_email, product_code, quantity, unit_price, order_date
- Clean: trim whitespace, validate emails (skip invalid rows with a warning),
  convert dates to ISO 8601
- Enrich: add a total_price column (quantity * unit_price)
- Output: cleaned_orders.csv and a summary report with: row count, skipped rows,
  total revenue
```

## Step 6 - JSON Log Analyzer

```
Write a script that:
1. Reads a JSONL (one JSON object per line) log file
2. Filters for log entries where level is "ERROR" or "CRITICAL"
3. Groups errors by their `error_code` field
4. Sorts by frequency (most common first)
5. Outputs a markdown report with: error code, count, first/last occurrence,
   sample message
```

## Step 7 - Markdown to HTML Converter

````
Write a simple Markdown to HTML converter (without using a library) that handles:
- Headings (# through ######)
- Bold (**text**) and italic (*text*)
- Inline code (`code`)
- Code blocks (```language ... ```)
- Unordered lists (- item)
- Links ([text](url))
- Paragraphs (separated by blank lines)
````

---

## Summary

Copilot removes the pain from regex and text parsing - just describe what you need in English, and let Copilot handle the pattern matching syntax.

## Next Steps

Continue with [Lab 025 - Shell Scripting](../025-ShellScripting/README.md)

---

## Tasks

## Task 01 - Generate a Regex from Description

**Scenario:** Generate a pattern to match valid IPv4 addresses.

**Hint:** Describe the constraints: octet range 0-255, no leading zeros.

??? success "Solution"

    `     Write a regex that matches only valid IPv4 addresses:
    - Each octet 0-255 (no leading zeros for multi-digit numbers)
    - Matches: 192.168.1.1, 10.0.0.1
    - Does NOT match: 256.1.1.1, 192.168.1, 999.0.0.1
    Explain each part of the regex.
    `

---

## Task 02 - Explain a Cryptic Regex

**Scenario:** You inherit a complex password-validation regex. Ask Copilot to explain it.

**Hint:** Paste the pattern and ask for a step-by-step explanation.

??? success "Solution"

    `     Explain this regex step by step:
    ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$
    `

---

## Task 03 - Parse a Log File

**Scenario:** Parse Apache access log lines into structured Python dicts.

**Hint:** Show a sample log line and ask for a parser function.

??? success "Solution"

    ```
    Write a Python function to parse this Apache access log line into a dict:
    192.168.1.100 - frank [10/Oct/2024:13:55:36 -0700] "GET /index.html HTTP/1.0" 200 1234

    Return: ip, user, timestamp (as datetime), method, path, protocol, status_code, bytes_sent.
    ```

---

## Task 04 - Build a Config File Parser

**Scenario:** Parse an INI-style config file into a nested Python dictionary.

**Hint:** Show the config format and the expected output structure.

??? success "Solution"

    ```
    Write a parser for this config format:

    [database]
    host = localhost
    port = 5432

    # comment
    [api]
    base_url = https://api.example.com

    Parse into: {"database": {"host": "localhost", "port": "5432"}, "api": {...}}
    Support comments (# prefix) and strip whitespace.
    ```

---

## Task 05 - Transform CSV Data

**Scenario:** Clean and enrich CSV data: validate emails, convert dates, add calculated columns.

**Hint:** Describe the input format, transformations, and output format.

??? success "Solution"

    `     Write a Python script to transform orders.csv (columns: order_id, customer_email,
    product_code, quantity, unit_price, order_date):
    - Trim whitespace from all fields
    - Validate emails (skip invalid rows with a warning)
    - Convert order_date to ISO 8601
    - Add total_price column (quantity * unit_price)
    - Output: cleaned_orders.csv and a summary report
    `

---

## Task 06 - Explain an `awk` Command

**Scenario:** Understand a complex awk one-liner for log analysis.

**Hint:** Paste the awk command and ask for an explanation plus a Python equivalent.

??? success "Solution"

    ```
    Explain this awk command step by step and rewrite it in Python:
    awk '{print $1}' access.log | sort | uniq -c | sort -rn | head -20

    Also: write an awk command to count requests per status code from an access log.
    ```
