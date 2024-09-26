{{/*
Expand the name of the chart.
*/}}
{{- define "gateway-microservice-demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gateway-microservice-demo.docker-secret.prefix" -}}
docker-secret
{{- end -}}

{{- define "gateway-microservice-demo.docker-secret.name" -}}
{{- $prefix := include "gateway-microservice-demo.docker-secret.prefix" . -}}
{{- $defaultName := default (include "gateway-microservice-demo.name" .) .Values.docker.secretName -}}
{{- printf "%s-%s" $prefix $defaultName -}}
{{- end -}}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway-microservice-demo.fullname" -}}
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
{{- define "gateway-microservice-demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gateway-microservice-demo.labels" -}}
helm.sh/chart: {{ include "gateway-microservice-demo.chart" . }}
{{ include "gateway-microservice-demo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gateway-microservice-demo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway-microservice-demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gateway-microservice-demo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gateway-microservice-demo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
