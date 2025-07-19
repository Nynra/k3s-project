{{- if .Values.enabled }}{{- if .Values.serviceAccounts }}{{- if .Values.serviceAccounts.enabled -}}
{{ range .Values.serviceAccounts.list }}
---
kind: ServiceAccount
apiVersion: v1
metadata:
  name: {{ .name }}
  namespace: {{ .namespace }}
  labels:
    app.kubernetes.io/name: "{{ .name }}-sa"
    # Service Account labels
    {{- if $.Values.serviceAccounts.labels }}
    {{- range $key, $value := $.Values.serviceAccounts.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global labels
    {{- if $.Values.global.labels }}
    {{- range $key, $value := $.Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
  annotations:
    # Service Account annotations
    {{- if $.Values.serviceAccounts.annotations }}
    {{- range $key, $value := $.Values.serviceAccounts.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global annotations
    {{- if $.Values.global.annotations }}
    {{- range $key, $value := $.Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Argocd wave
    argocd.argoproj.io/sync-wave: "-15"
{{- if .imagePullSecrets }}
imagePullSecrets:
{{- range .imagePullSecrets }}
  - name: {{ .name }}
    {{- if .namespace }}
    namespace: {{ .namespace | quote }}
    {{- end }}
{{- end }}
{{- end }}

{{ end }}
{{- end -}}{{- end -}}{{- end }}