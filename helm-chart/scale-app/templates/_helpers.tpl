{{/*
Global service name for reuse in all helper functions
*/}}
{{- define "global.serviceName" -}}
{{- .Values.serviceName | default "defaultService" | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Expand the name of the service.
*/}}
{{- define "..name" -}}
{{- include "global.serviceName" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "..fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "global.serviceName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "..chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
API-specific selector labels
*/}}
{{- define "api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "..name" . }}-api
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: api
{{- end }}

{{/*
UI-specific selector labels
*/}}
{{- define "ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "..name" . }}-ui
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: ui
{{- end }}

{{/*
API-specific labels (includes common labels + API selector labels)
*/}}
{{- define "api.labels" -}}
helm.sh/chart: {{ include "..chart" . }}
{{ include "api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
UI-specific labels (includes common labels + UI selector labels)
*/}}
{{- define "ui.labels" -}}
helm.sh/chart: {{ include "..chart" . }}
{{ include "ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
API fullname
*/}}
{{- define "api.fullname" -}}
{{- if .Values.api.fullnameOverride }}
{{- .Values.api.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-api" .Release.Name (include "global.serviceName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
UI fullname
*/}}
{{- define "ui.fullname" -}}
{{- if .Values.ui.fullnameOverride }}
{{- .Values.ui.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-ui" .Release.Name (include "global.serviceName" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create the name of the ecr service account to use
*/}}
{{- define "..ecrserviceAccountName" -}}
{{- if .Values.ecrserviceAccount.create }}
{{- default (include "global.serviceName" .) .Values.ecrserviceAccount.name }}
{{- else }}
{{- default "default" .Values.ecrserviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the s3 service account to use
*/}}
{{- define "..s3serviceAccountName" -}}
{{- if .Values.s3serviceAccount.create }}
{{- default (include "global.serviceName" .) .Values.s3serviceAccount.name }}
{{- else }}
{{- default "default" .Values.s3serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the eso service account to use
*/}}
{{- define "..esoserviceAccountName" -}}
{{- if .Values.esoserviceAccount.create }}
{{- default (include "global.serviceName" .) .Values.esoserviceAccount.name }}
{{- else }}
{{- default "default" .Values.esoserviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the full name for the Issuer
*/}}
{{- define "issuerName" -}}
{{- if .Values.certManager.issuer.name }}
{{- .Values.certManager.issuer.name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "..fullname" . }}-issuer
{{- end }}
{{- end }}

{{/*
Return the private key secret name
*/}}
{{- define "issuerPrivateKeySecret" -}}
{{- if .Values.certManager.issuer.privateKeySecretName }}
{{- .Values.certManager.issuer.privateKeySecretName }}
{{- else }}
{{- include "issuerName" . }}-private-key
{{- end }}
{{- end }}

{{/*
Return the certificate secret name
*/}}
{{- define "certificateSecretName" -}}
{{- if .Values.certManager.certificate.secretName }}
{{- .Values.certManager.certificate.secretName }}
{{- else }}
{{- include "..fullname" . }}-tls
{{- end }}
{{- end }}

{{/*
Return the certificate Common Name
*/}}
{{- define "certificateCommonName" -}}
{{- if .Values.certManager.certificate.commonName }}
{{- .Values.certManager.certificate.commonName }}
{{- else if (and .Values.ingress.enabled (index .Values.ingress.hosts 0)) }}
{{- (index .Values.ingress.hosts 0).host }}
{{- else }}
example.com
{{- end }}
{{- end }}

{{/*
Return the certificate DNS Names
*/}}
{{- define "certificateDNSNames" -}}
{{- if .Values.certManager.certificate.dnsNames }}
{{- toYaml .Values.certManager.certificate.dnsNames }}
{{- else if .Values.ingress.enabled }}
{{- range .Values.ingress.hosts }}
- {{ .host }}
{{- end }}
{{- else }}
- example.com
{{- end }}
{{- end }}