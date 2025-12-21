# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI Solutions Camp Helm Charts - A collection of production-ready Helm charts for AI/ML stacks. These are umbrella charts designed for one-shot installation and publishing to ArtifactHub via GitHub Pages.

## Commands

```bash
# Add required Helm repositories
helm repo add qdrant https://qdrant.github.io/qdrant-helm
helm repo add ollama https://otwld.github.io/ollama-helm
helm repo update

# Build dependencies for a chart
helm dependency build charts/rag-stack

# Lint a chart
helm lint charts/rag-stack

# Template render test
helm template test charts/rag-stack --debug

# Install a chart locally
helm install my-rag charts/rag-stack -n rag-system --create-namespace

# Run chart-testing (requires ct installed)
ct lint --config ct.yaml
```

## Architecture

```
charts/
├── rag-stack/           # RAG stack: Qdrant + Redis + Embedding Service + API Gateway
├── local-llm-stack/     # Local LLM: Ollama + Open WebUI + API Gateway
└── ai-agent-stack/      # AI Agent: PostgreSQL + Redis + Agent Runtime + Tool Executor

.github/workflows/
├── lint.yaml            # Chart linting with chart-testing
├── release.yaml         # Chart Releaser for GitHub Pages publishing
└── test.yaml            # Template tests and kind cluster integration tests
```

## Chart Structure

Each chart follows the umbrella chart pattern:
- `Chart.yaml`: apiVersion v2, dependencies with version constraints
- `values.yaml`: Documented defaults, secrets as references
- `templates/_helpers.tpl`: Common template helpers
- `templates/NOTES.txt`: Post-install instructions

## Coding Standards

- Labels: `app.kubernetes.io/name`, `app.kubernetes.io/instance`, `app.kubernetes.io/component`
- All values with `{{ .Values.x | default "y" }}`
- Resource limits always defined
- Health checks (liveness/readiness) for all pods
- Security contexts: runAsNonRoot, readOnlyRootFilesystem
- Conditions for optional components: `{{- if .Values.component.enabled -}}`

## Important

- Do not use Bitnami charts or images (Broadcom licensing). Use official Docker Hub images with custom templates instead.
- Redis: `redis:7.4-alpine` (official image)
- PostgreSQL: `postgres:16-alpine` (official image)
