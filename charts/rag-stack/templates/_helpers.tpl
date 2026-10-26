{{/*
Expand the name of the chart.
*/}}
{{- define "rag-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name.
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

{{- define "rag-stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "rag-stack.labels" -}}
helm.sh/chart: {{ include "rag-stack.chart" . }}
{{ include "rag-stack.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "rag-stack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rag-stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: rag-api
{{- end }}

{{/*
Name of the rag-api resources: <release>-rag-api, or <fullnameOverride>-api.
*/}}
{{- define "rag-stack.ragApiName" -}}
{{- if .Values.fullnameOverride }}
{{- printf "%s-api" .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-rag-api" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "rag-stack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rag-stack.ragApiName" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Names of the subchart resources (same logic as the subcharts' fullname helpers).
*/}}
{{- define "rag-stack.subchartFullname" -}}
{{- $ctx := index . 0 }}{{- $name := index . 1 }}{{- $values := index . 2 }}
{{- if $values.fullnameOverride }}
{{- $values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $n := default $name $values.nameOverride }}
{{- if contains $n $ctx.Release.Name }}
{{- $ctx.Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $ctx.Release.Name $n | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "rag-stack.qdrantFullname" -}}
{{- include "rag-stack.subchartFullname" (list . "qdrant" .Values.qdrant) }}
{{- end }}

{{- define "rag-stack.ollamaFullname" -}}
{{- include "rag-stack.subchartFullname" (list . "ollama" .Values.ollama) }}
{{- end }}

{{- define "rag-stack.qdrantUrl" -}}
{{- if .Values.ragApi.qdrantUrl }}
{{- .Values.ragApi.qdrantUrl }}
{{- else if .Values.qdrant.enabled }}
{{- printf "http://%s:6333" (include "rag-stack.qdrantFullname" .) }}
{{- else }}
{{- fail "qdrant.enabled is false: set ragApi.qdrantUrl" }}
{{- end }}
{{- end }}

{{- define "rag-stack.ollamaUrl" -}}
{{- if .Values.ragApi.ollamaUrl }}
{{- .Values.ragApi.ollamaUrl }}
{{- else if .Values.ollama.enabled }}
{{- printf "http://%s:%v" (include "rag-stack.ollamaFullname" .) (.Values.ollama.service.port | default 11434) }}
{{- else }}
{{- fail "ollama.enabled is false: set ragApi.ollamaUrl" }}
{{- end }}
{{- end }}

{{/*
Secret with the Qdrant API key: the bundled Qdrant's Secret unless one is given.
Empty when Qdrant runs without an API key.
*/}}
{{- define "rag-stack.qdrantSecretName" -}}
{{- if .Values.ragApi.qdrantApiKey.secretName }}
{{- .Values.ragApi.qdrantApiKey.secretName }}
{{- else if and .Values.qdrant.enabled (or .Values.qdrant.apiKey .Values.qdrant.readOnlyApiKey) }}
{{- printf "%s-apikey" (include "rag-stack.qdrantFullname" .) }}
{{- end }}
{{- end }}

{{- define "rag-stack.apiKeySecretName" -}}
{{- default (include "rag-stack.ragApiName" .) .Values.ragApi.auth.existingSecret }}
{{- end }}
