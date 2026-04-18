# Lab 025 - Shell Scripting with Copilot

!!! hint "Overview"

    - Copilot is an excellent shell scripting assistant that understands Bash, Zsh, and POSIX shell idioms.
    - In this lab, you will use Copilot to write automation scripts, explain cryptic one-liners, and debug shell errors.
    - You will tackle real DevOps scenarios including log processing, deployment automation, and environment setup scripts.
    - By the end of this lab, you will be able to write and maintain robust shell scripts with AI assistance, even for advanced cases.

## Prerequisites

- Completed [Lab 024 - Regex and Parsing](../024-RegexAndParsing/README.md)

## What You Will Learn

- How to generate Bash scripts from requirements
- How Copilot explains complex shell one-liners
- How to write robust scripts with error handling
- How to automate DevOps tasks with shell + Copilot

---

## Lab Steps

## Step 1 - Explain a Complex One-Liner

Ask Copilot to explain this pipeline:

```bash
find . -name "*.log" -mtime +30 -exec gzip {} \; 2>/dev/null | \
  xargs -I{} aws s3 cp {} s3://my-bucket/archive/ && \
  find . -name "*.log.gz" -mtime +30 -delete
```

```
Explain this shell command step by step. What does each part do?
Is there a safer or more reliable way to write this?
```

## Step 2 - Generate a Deployment Script

```
Write a production deployment bash script for a Node.js app that:
1. Checks that required environment variables are set (exit 1 if missing)
2. Runs git pull to get latest code
3. Installs dependencies (npm ci)
4. Runs database migrations
5. Builds the app (npm run build)
6. Performs a rolling restart using PM2 (no downtime)
7. Runs a health check (curl the /health endpoint, retry 5 times)
8. Sends a Slack webhook notification with deploy status (success/fail)
9. On failure: rolls back to previous version and notifies

Include set -euo pipefail, colored output, and a timestamped log file.
```

## Step 3 - Write a Backup Script

```
Write a bash script that:
- Backs up a PostgreSQL database using pg_dump
- Compresses with gzip
- Names files with timestamp: backup_YYYY-MM-DD_HH-MM.sql.gz
- Uploads to an S3 bucket
- Keeps only the last 30 backups locally
- Keeps only the last 90 backups in S3
- Sends email on failure using sendmail
- Runs via cron (add the cron entry as a comment)
```

## Step 4 - Debug a Script Error

```
#terminalLastCommand

This Bash script is failing. Explain the error and fix it.
```

Common errors Copilot can fix:

- `unbound variable` → missing `set -u` guard or uninitialized variable
- `command not found` → PATH issue or missing dependency check
- `permission denied` → missing `chmod +x`
- Quoting issues with spaces in filenames

## Step 5 - Write a System Health Check Script

```
Write a bash script that checks system health and outputs a report:
- CPU usage (alert if > 80%)
- Memory usage (alert if > 90%)
- Disk usage for all mounted filesystems (alert if > 85%)
- Check if required services are running: nginx, postgresql, redis
- Check if key ports are listening: 80, 443, 5432, 6379
- Check SSL certificate expiry (alert if < 30 days)
- Output: colored terminal report + JSON file for monitoring systems
```

## Step 6 - Process Management Script

```
Write a bash script to manage a set of worker processes:
- Start N workers (N passed as argument, default 4)
- Write each PID to /var/run/workers/worker-N.pid
- Trap SIGTERM to gracefully shut down all workers
- Restart any worker that dies unexpectedly
- Log start/stop/restart events with timestamps
```

## Step 7 - Explain `awk` and `sed` One-Liners

```
Explain what this awk command does and rewrite it in Python for readability:
awk -F: '$3 >= 1000 {printf "%-20s%s\n", $1, $7}' /etc/passwd
```

```
Write an awk command to:
- Parse an Nginx access log
- Count requests per IP address
- Show the top 20 IPs sorted by request count
```

---

## Bash Scripting Best Practices

```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, unset var, pipe failure
IFS=$'\n\t'        # Safer word splitting

# Always quote variables
echo "$variable"
cp "$source" "$destination"

# Check dependencies at startup
command -v docker >/dev/null 2>&1 || { echo "docker required"; exit 1; }

# Use local in functions
my_function() {
    local result
    result=$(some_command)
    echo "$result"
}
```

---

## Summary

Copilot transforms shell scripting from a painful, error-prone process into a natural conversation - just describe what you need and review the generated script.

## Next Steps

Continue with [Lab 026 - Copilot in CLI](../026-CopilotInCLI/README.md)

---

## Tasks

## Task 01 - Explain a Shell One-Liner

**Scenario:** Understand a complex pipe chain before using it in production.

**Hint:** Paste the command and ask for a step-by-step explanation.

??? success "Solution"

    ```
    Explain this command step by step:
    find . -name "_.log" -mtime +30 | xargs gzip && find . -name "_.log.gz" -mtime +30 -delete

    Is there a safer version?
    ```

---

## Task 02 - Write a Deployment Script

**Scenario:** Create a bash deployment script with health checks and rollback.

**Hint:** Describe the deployment steps and failure behavior.

??? success "Solution"

    `     Write a bash deployment script that:
    1. Checks required env vars (exit 1 if missing)
    2. git pull && npm ci && npm run build
    3. Rolling restart with PM2
    4. Health check (curl /health, retry 5 times)
    5. On failure: rollback to previous version
    6. Send Slack webhook notification
    Use set -euo pipefail and colored output.
    `

---

## Task 03 - Create a Backup Script

**Scenario:** Generate a PostgreSQL backup script that runs via cron.

**Hint:** Describe storage, retention, and notification requirements.

??? success "Solution"

    `     Write a bash script that:
    - Backs up PostgreSQL with pg_dump, compressed with gzip
    - Filename: backup_YYYY-MM-DD_HH-MM.sql.gz
    - Uploads to S3
    - Keeps last 30 locally, last 90 in S3
    - Sends email on failure
    - Include the cron entry as a comment
    `

---

## Task 04 - Debug a Script Error

**Scenario:** A bash script fails with an unbound variable error.

**Hint:** Show the error and the script.

??? success "Solution"

    ```
    #terminalLastCommand

    This bash script is failing. Explain and fix:
    bash: line 5: DATABASE_URL: unbound variable
    ```

---

## Task 05 - Write a System Health Check

**Scenario:** Create a script that monitors CPU, memory, disk, and service status.

**Hint:** Describe the thresholds and output format.

??? success "Solution"

    `     Write a bash health check script that:
    - Checks CPU (alert > 80%), memory (alert > 90%), disk (alert > 85%)
    - Checks if nginx, postgresql, redis are running
    - Checks SSL cert expiry (alert < 30 days)
    - Outputs: colored terminal report + JSON file
    `

---

## Task 06 - Write an `awk` Log Analyzer

**Scenario:** Use awk to find the top 20 IPs from an Nginx access log.

**Hint:** Ask for an awk command that parses the access log format.

??? success "Solution"

    `     Write an awk command to:
    - Parse an Nginx access log
    - Count requests per IP address
    - Show the top 20 IPs sorted by request count descending
    Also: what does awk -F: '$3 >= 1000 {print $1}' /etc/passwd do?
    `
