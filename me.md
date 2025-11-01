# 🚀 Secure Pipeline Demo

A hands-on project to build a **secure CI/CD pipeline** with GitHub Actions, Docker, and Kubernetes.
This repo is part of my **3-Month DevSecOps Journey**.

---

## 🔄 Pipeline Architecture

![Pipeline Diagram](pipeline.png)

---

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=leelee222_secure-pipeline-demo&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=leelee222_secure-pipeline-demo)
[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=leelee222_secure-pipeline-demo&metric=security_rating)](https://sonarcloud.io/summary/new_code?id=leelee222_secure-pipeline-demo)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=leelee222_secure-pipeline-demo&metric=sqale_rating)](https://sonarcloud.io/summary/new_code?id=leelee222_secure-pipeline-demo)


## 📅 Roadmap Progress

### ✅ Week 1 – CI/CD Security Basics

* [x] Setup Node.js/Python app repo
* [x] GitHub Actions CI/CD (build + test)
* [x] SonarQube static analysis
* [x] Trivy/Snyk dependency scanning
* [x] GitLeaks secret detection
* [x] Pipeline fails on vulnerabilities
* [x] Document pipeline in README

---

### ✅ Week 2 – Container Security

* [x] Dockerize the app with a secure Dockerfile
* [x] Scan image with Trivy/Clair
* [x] Fix vulnerabilities and harden image
* [x] Push image to DockerHub
* [x] Document Docker security practices

---

### ✅ Week 3 – Pipeline Automation

* [x] Connect CI/CD to Docker build
* [x] Add automated tests before build
* [x] Add automated security scans after build
* [x] Configure pipeline to fail on vulnerabilities
* [x] Deploy to Minikube

---

### 🔄 Week 4 – Mini Project *(in progress)*

* [x] Integrate all components (app + CI/CD + Docker + security)
* [x] Test full workflow
* [x] Write final README + diagrams
* [x] Create short demo video

---

## ⚙️ Tech Stack

* **Language**: Node.js / Python
* **CI/CD**: GitHub Actions
* **Security Tools**: SonarQube, Trivy, Snyk, GitLeaks
* **Containerization**: Docker (with security best practices)
* **Orchestration (later)**: Kubernetes (Minikube)

---

## Docker & Container Security

This project follows container security best practices:

### Image build
- Multi-stage build to keep dev artifacts out of the final image.
- Base image: `node:18-alpine` (minimal, small attack surface).
- Only production dependencies installed in runtime image (`NODE_ENV=production`).

### Runtime hardening
- App runs as a non-root user (`USER node`) to minimize privileges.
- `.dockerignore` excludes local artifacts: `node_modules`, `coverage`, `.git`.
- Port exposed: `3000` (configurable via `PORT` env var).

### Vulnerability scanning
- Images scanned with **Trivy** in CI for HIGH and CRITICAL vulnerabilities.
- Dependencies scanned with **Snyk** / **Trivy FS** and `npm audit` locally.
- CI pipeline fails the build if HIGH/CRITICAL vulnerabilities or secrets are detected.

### Signing & provenance
- Images are tagged with commit SHAs for immutability (`ilham/secure-pipeline-demo:<commit-sha>`).
- (Optional) Images can be signed with **cosign** to guarantee provenance.

### How to reproduce locally
```bash
# build
docker build -t ilham/secure-pipeline-demo:local .

# run
docker run -p 3000:3000 ilham/secure-pipeline-demo:local

# scan
trivy image --severity HIGH,CRITICAL ilham/secure-pipeline-demo:local

---

# Quick troubleshooting & tips

- If Trivy finds issues in the **base image**, try upgrading to a newer base image (e.g., `node:18.20-alpine` or `node:20-alpine`).
- If vulnerabilities come from npm packages, prefer upgrading the specific package rather than `npm audit fix --force`.
- Re-run `trivy` after each fix until HIGH/CRITICAL are gone.
- Use pinned dependency versions in `package.json` (no `^`/`~` if you want strict reproducibility).
- For production deployment, use image scanning as a required gate (CI fails if vulnerability thresholds are exceeded).

---

If you want I can:
- produce the exact small change diff for your repo (Dockerfile + .dockerignore + workflow snippet),
- or generate a ready-to-copy `workflow` YAML you can drop into `.github/workflows/docker-publish.yml`.

Which do you prefer — **full file(s) ready to paste**, or **a git diff** you can apply?
