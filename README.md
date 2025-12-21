# AI Solutions Camp - Helm Charts

Production-ready Helm charts for AI/ML stacks. One-shot installation with sensible defaults.

## Available Charts

| Chart | Description | Status |
|-------|-------------|--------|
| [rag-stack](./charts/rag-stack) | RAG stack with Qdrant, Redis, Embedding Service, API Gateway | Ready |
| [local-llm-stack](./charts/local-llm-stack) | Local LLM with Ollama, Open WebUI, API Gateway | Planned |
| [ai-agent-stack](./charts/ai-agent-stack) | AI Agent with PostgreSQL, Redis, Agent Runtime | Planned |

## Quick Start

```bash
# Add the Helm repository
helm repo add aisolutionscamp https://aisolutionscamp.github.io/helm-charts
helm repo update

# Install RAG Stack
helm install my-rag aisolutionscamp/rag-stack -n rag-system --create-namespace
```

## Installation from Source

```bash
# Clone the repository
git clone https://github.com/aisolutionscamp/helm-charts.git
cd helm-charts

# Add required repositories
helm repo add qdrant https://qdrant.github.io/qdrant-helm
helm repo update

# Build dependencies and install
helm dependency build charts/rag-stack
helm install my-rag charts/rag-stack -n rag-system --create-namespace
```

## Configuration

Each chart has comprehensive configuration options. See the `values.yaml` in each chart directory for available settings.

### Example: RAG Stack with custom settings

```bash
helm install my-rag charts/rag-stack \
  --set qdrant.persistence.size=50Gi \
  --set redis.persistence.size=5Gi \
  --set embeddingService.autoscaling.enabled=true \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=rag.example.com \
  -n rag-system --create-namespace
```

## License

Apache 2.0
