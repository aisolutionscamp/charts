# rag-stack

Retrieval-augmented generation on Kubernetes:

| Component | Source | Purpose |
|---|---|---|
| rag-api | this chart, image `ghcr.io/aisolutionscamp/rag-api` ([source](https://github.com/aisolutionscamp/stacks/tree/main/stacks/rag-pipeline/app)) | `POST /ingest`, `POST /query`, `DELETE /documents`, `GET /health` |
| Qdrant | subchart [qdrant/qdrant](https://github.com/qdrant/qdrant-helm) 1.20.0 | vector store (StatefulSet + PVC) |
| Ollama | subchart [otwld/ollama](https://github.com/otwld/ollama-helm) 1.92.0 | embedding and chat models (Deployment + PVC) |

The same stack as Docker Compose, Terraform and AWS: [aisolutionscamp/stacks, rag-pipeline](https://github.com/aisolutionscamp/stacks/tree/main/stacks/rag-pipeline).

## Install

```bash
helm repo add aisolutionscamp https://aisolutionscamp.github.io/charts
helm repo update aisolutionscamp
helm upgrade --install rag aisolutionscamp/rag-stack --version 1.0.0 -n rag --create-namespace
kubectl -n rag rollout status deploy/rag-rag-api --timeout=30m   # first start pulls the models
```

API key and a first request:

```bash
KEY=$(kubectl -n rag get secret rag-rag-api -o jsonpath='{.data.api-key}' | base64 -d)
kubectl -n rag port-forward svc/rag-rag-api 8000:8000 &
curl -s -X POST localhost:8000/ingest -H "X-API-Key: $KEY" -F files=@notes.md
curl -s -X POST localhost:8000/query -H "X-API-Key: $KEY" -H 'Content-Type: application/json' \
  -d '{"question":"What are the notes about?"}'
```

## Defaults

- rag-api requires an API key; the chart generates one into the Secret `<release>-rag-api` (kept on upgrades) unless you set `ragApi.auth.existingSecret`.
- Qdrant requires an API key (`qdrant.apiKey: true`, Secret `<release>-qdrant-apikey`); rag-api reads it from there.
- NetworkPolicies allow traffic to Qdrant and Ollama only from rag-api.
- All pods run as non-root with a read-only root filesystem and no capabilities (the Qdrant subchart's own defaults for Qdrant).
- Models: `nomic-embed-text:v1.5` and `llama3.2:3b`, pulled by rag-api on first start into the Ollama volume (30Gi).
- No Ingress by default. Enable `ingress` with TLS for access from outside the cluster.

All options are documented in [values.yaml](values.yaml).

## helm test

`helm test` runs a health check against rag-api plus the subcharts' tests. The Qdrant chart's test sends the literal `qdrant.apiKey` value as the key, so with the default `apiKey: true` that one test fails although Qdrant works. It passes when `qdrant.apiKey` is set to an explicit key.

## Upgrading from 0.x

1.0.0 is a rewrite. The 0.x chart deployed Redis, an embedding service and an API gateway; those are gone. Uninstall the 0.x release and install 1.0.0; Qdrant data from 0.x is not migrated.
