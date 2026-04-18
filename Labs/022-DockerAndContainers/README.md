# Lab 022 - Docker and Containers with Copilot

!!! hint "Overview"

    - In this lab, you will use GitHub Copilot to write Dockerfiles, Docker Compose configurations, and multi-stage builds.
    - Copilot has deep knowledge of containerization best practices including image layering, caching, and security hardening.
    - You will also use Copilot to debug container runtime errors, interpret logs, and fix networking and volume issues.
    - By the end of this lab, you will be able to rely on Copilot as a knowledgeable container engineering assistant.

## Prerequisites

- Completed [Lab 021 - API Design](../021-APIDesign/README.md)
- Docker installed locally

## What You Will Learn

- How to generate optimized Dockerfiles for different runtimes
- How to create multi-stage builds for minimal image sizes
- How to write Docker Compose configurations
- How to debug container networking and volume issues
- How to generate Kubernetes manifests from Compose files

---

## Lab Steps

## Step 1 - Generate an Optimized Dockerfile

```
Create a production-optimized Dockerfile for a Node.js 20 Express API with:
- Multi-stage build (builder + production stage)
- Non-root user for security
- Layer caching optimized (dependencies before source code)
- Health check endpoint
- Environment variable for PORT (default 3000)
- Final image based on node:20-alpine
```

Expected output structure:

```dockerfile
# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Production
FROM node:20-alpine AS production
...
```

## Step 2 - Optimize an Existing Dockerfile

Paste this bloated Dockerfile:

```dockerfile
FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y nodejs npm
COPY . .
RUN npm install
EXPOSE 3000
CMD node server.js
```

Ask:

```
This Dockerfile has several problems: large image size, security issues,
and poor layer caching. Rewrite it following best practices:
- Use a minimal base image
- Pin versions
- Run as non-root
- Optimize layer caching
- Use .dockerignore
```

## Step 3 - Create a Docker Compose Stack

```
Write a Docker Compose file for a full-stack application with:
- Next.js frontend (port 3000)
- Node.js Express API (port 4000)
- PostgreSQL 16 database (with persistent volume)
- Redis for session storage (port 6379)
- Nginx reverse proxy (ports 80, 443)

Include:
- Health checks for all services
- Depends-on with service_healthy conditions
- Environment variables via .env file
- Named volumes for persistence
- A separate `docker-compose.dev.yml` override for development
```

## Step 4 - Debug Container Issues

```
My Docker container keeps restarting. Here's the output of `docker logs myapp`:

[paste log output]

What's causing the restart loop and how do I fix it?
```

Or:

```
Two containers (api and db) can't communicate.
Here's my docker-compose.yml:

[paste compose file]

What's wrong with the networking configuration?
```

## Step 5 - Write a .dockerignore File

```
#file:package.json
#file:.gitignore

Generate a .dockerignore file for this Node.js project.
Exclude everything that shouldn't be in the build context:
dev dependencies, test files, documentation, local configs, etc.
```

## Step 6 - Convert Compose to Kubernetes

```
#file:docker-compose.yml

Convert this Docker Compose file to Kubernetes manifests:
- Deployment for each service
- Service objects (ClusterIP for internal, LoadBalancer for public)
- ConfigMap for environment variables
- Secret for sensitive values
- PersistentVolumeClaim for the database

Generate separate YAML files per resource.
```

## Step 7 - Scan for Container Security Issues

```
#file:Dockerfile

Review this Dockerfile for security vulnerabilities:
- Running as root
- Exposed secrets in ENV layers
- Use of latest tags
- Unnecessary packages installed
- Missing HEALTHCHECK
- Sensitive files copied into image
```

---

## Docker Best Practices Quick Reference

| Practice                   | Why                                                      |
| :------------------------- | :------------------------------------------------------- |
| Use Alpine/distroless base | Smaller attack surface and image size                    |
| Multi-stage builds         | Keep build tools out of production image                 |
| Non-root USER              | Reduce privilege escalation risk                         |
| Pin image versions         | Reproducible builds                                      |
| COPY package.json first    | Better layer caching                                     |
| Use .dockerignore          | Faster builds, no secrets in context                     |
| Add HEALTHCHECK            | Container orchestration can restart unhealthy containers |

---

## Summary

Copilot dramatically speeds up container work - from writing Dockerfiles to debugging multi-service networking issues - while consistently applying security and performance best practices.

## Next Steps

Continue with [Lab 023 - CI Workflows](../023-CIWorkflows/README.md)

---

## Tasks

## Task 01 - Generate an Optimized Dockerfile

**Scenario:** Create a production Dockerfile for a Node.js app with multi-stage build.

**Hint:** Describe the language, version, and requirements.

??? success "Solution"

    `     Create a production-optimized Dockerfile for a Node.js 20 Express API:
    - Multi-stage build (builder + production)
    - Non-root user
    - Layer caching optimized (dependencies before source)
    - Health check
    - Based on node:20-alpine
    `

---

## Task 02 - Improve an Existing Dockerfile

**Scenario:** Optimize a bloated Dockerfile that uses Ubuntu as a base.

**Hint:** Paste the Dockerfile and ask for improvements.

??? success "Solution"

    Paste:

    ```dockerfile
    FROM ubuntu:latest
    RUN apt-get update && apt-get install -y nodejs npm
    COPY . .
    RUN npm install
    EXPOSE 3000
    CMD node server.js
    ```

    Ask: "Optimize this Dockerfile: use a minimal base image, pin versions, non-root user, optimize layer caching."

---

## Task 03 - Write a Docker Compose Stack

**Scenario:** Generate a Compose file for a full-stack app with a database and cache.

**Hint:** List all services you need with port requirements.

??? success "Solution"

    `     Write a docker-compose.yml for:
    - Next.js frontend (port 3000)
    - Node.js API (port 4000)
    - PostgreSQL 16 with persistent volume
    - Redis 7
    - Nginx reverse proxy (ports 80/443)
    Include health checks and depends_on with service_healthy.
    `

---

## Task 04 - Debug Container Networking

**Scenario:** Two containers can't communicate. Diagnose the issue using Copilot.

**Hint:** Show the Compose file and the error message.

??? success "Solution"

    ```
    My API container can't reach the DB container. Here's the error and my compose file:
    Error: connect ECONNREFUSED 127.0.0.1:5432

    [paste docker-compose.yml]

    What's wrong with the network configuration?
    ```

---

## Task 05 - Generate a .dockerignore File

**Scenario:** Speed up builds by excluding files that don't belong in the Docker context.

**Hint:** Reference your project files.

??? success "Solution"

    ```
    #file:package.json
    #file:.gitignore

    Generate a .dockerignore file for this Node.js project.
    Exclude: dev dependencies, test files, local configs, docs, coverage reports.
    ```

---

## Task 06 - Scan a Dockerfile for Security Issues

**Scenario:** Review a Dockerfile for common security vulnerabilities.

**Hint:** Reference the Dockerfile and ask for a security audit.

??? success "Solution"

    ```
    #file:Dockerfile

    Review this Dockerfile for security issues:
    - Running as root
    - Latest tags
    - Exposed secrets in ENV
    - Unnecessary packages
    - Missing HEALTHCHECK
    - Sensitive files in the image
    ```
