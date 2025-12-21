{{/*
Expand the name of the chart.
*/}}
{{- define "rag-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "rag-stack.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rag-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rag-stack.labels" -}}
helm.sh/chart: {{ include "rag-stack.chart" . }}
{{ include "rag-stack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rag-stack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rag-stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rag-stack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rag-stack.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Embedding Service fullname
*/}}
{{- define "rag-stack.embeddingService.fullname" -}}
{{- printf "%s-embedding-service" (include "rag-stack.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Embedding Service labels
*/}}
{{- define "rag-stack.embeddingService.labels" -}}
{{ include "rag-stack.labels" . }}
app.kubernetes.io/component: embedding-service
{{- end }}

{{/*
Embedding Service selector labels
*/}}
{{- define "rag-stack.embeddingService.selectorLabels" -}}
{{ include "rag-stack.selectorLabels" . }}
app.kubernetes.io/component: embedding-service
{{- end }}

{{/*
API Gateway fullname
*/}}
{{- define "rag-stack.apiGateway.fullname" -}}
{{- printf "%s-api-gateway" (include "rag-stack.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
API Gateway labels
*/}}
{{- define "rag-stack.apiGateway.labels" -}}
{{ include "rag-stack.labels" . }}
app.kubernetes.io/component: api-gateway
{{- end }}

{{/*
API Gateway selector labels
*/}}
{{- define "rag-stack.apiGateway.selectorLabels" -}}
{{ include "rag-stack.selectorLabels" . }}
app.kubernetes.io/component: api-gateway
{{- end }}

{{/*
Return the Qdrant host
*/}}
{{- define "rag-stack.qdrantHost" -}}
{{- if .Values.qdrant.enabled }}
{{- printf "%s-qdrant" .Release.Name }}
{{- else }}
{{- .Values.externalQdrant.host }}
{{- end }}
{{- end }}

{{/*
Return the Qdrant port
*/}}
{{- define "rag-stack.qdrantPort" -}}
{{- if .Values.qdrant.enabled }}
{{- .Values.qdrant.service.port | default 6333 }}
{{- else }}
{{- .Values.externalQdrant.port | default 6333 }}
{{- end }}
{{- end }}

{{/*
Redis fullname
*/}}
{{- define "rag-stack.redis.fullname" -}}
{{- printf "%s-redis" (include "rag-stack.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Redis labels
*/}}
{{- define "rag-stack.redis.labels" -}}
{{ include "rag-stack.labels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{/*
Redis selector labels
*/}}
{{- define "rag-stack.redis.selectorLabels" -}}
{{ include "rag-stack.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{/*
Return the Redis host
*/}}
{{- define "rag-stack.redisHost" -}}
{{- if .Values.redis.enabled }}
{{- include "rag-stack.redis.fullname" . }}
{{- else }}
{{- .Values.externalRedis.host }}
{{- end }}
{{- end }}

{{/*
Return the Redis port
*/}}
{{- define "rag-stack.redisPort" -}}
{{- if .Values.redis.enabled }}
{{- 6379 }}
{{- else }}
{{- .Values.externalRedis.port | default 6379 }}
{{- end }}
{{- end }}

{{/*
Return the Redis secret name
*/}}
{{- define "rag-stack.redis.secretName" -}}
{{- if .Values.redis.auth.existingSecret }}
{{- .Values.redis.auth.existingSecret }}
{{- else }}
{{- include "rag-stack.redis.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the Redis secret name (alias for backwards compatibility)
*/}}
{{- define "rag-stack.redisSecretName" -}}
{{- include "rag-stack.redis.secretName" . }}
{{- end }}

{{/*
Image pull secrets
*/}}
{{- define "rag-stack.imagePullSecrets" -}}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- end }}
