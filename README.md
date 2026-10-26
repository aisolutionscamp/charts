# AI Solutions Camp - Helm Charts

Production-ready Helm charts for AI/ML stacks. One-shot installation with sensible defaults.

## Available Charts

| Chart | Description |
|-------|-------------|
| [rag-stack](./charts/rag-stack) | Retrieval-augmented generation: Qdrant, Ollama and the rag-api service ([source](https://github.com/aisolutionscamp/stacks/tree/main/stacks/rag-pipeline)) |

The other stacks on [aisolutionscamp.io](https://aisolutionscamp.io/stacks) use maintained upstream charts; their Helm setup lives in [aisolutionscamp/stacks](https://github.com/aisolutionscamp/stacks).

## Quick Start

```bash
helm repo add aisolutionscamp https://aisolutionscamp.github.io/charts
helm repo update
helm install rag aisolutionscamp/rag-stack -n rag --create-namespace
```

## Installation from Source

```bash
git clone https://github.com/aisolutionscamp/charts.git
cd charts
helm dependency build charts/rag-stack
helm install rag charts/rag-stack -n rag --create-namespace
```

## Configuration

Each chart has comprehensive configuration options. See the `values.yaml` in each chart directory for available settings.

### Example: RAG Stack with custom settings

```bash
helm install rag aisolutionscamp/rag-stack \
  --set qdrant.persistence.size=50Gi \
  --set ingress.enabled=true \
  -n rag --create-namespace
```

See [charts/rag-stack/README.md](./charts/rag-stack/README.md) for all values.

## License

Apache 2.0
