{{- if .Values.enabled }}{{- if .Values.quotas }}{{- if .Values.quotas.enabled -}}
kind: ResourceQuota
apiVersion: v1
metadata:
  name: "{{- .Values.namespace.name | default .Chart.Name -}}-quotas"
  namespace: "{{- .Values.namespace.name | default .Chart.Name -}}"
  labels:
    {{- if .Values.quotas.labels }}
    {{- range $key, $value := .Values.quotas.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    {{- if .Values.global.labels }}
    {{- range $key, $value := .Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
  annotations:
    {{- if .Values.quotas.annotations }}
    {{- range $key, $value := .Values.quotas.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    {{- if .Values.global.annotations }}
    {{- range $key, $value := .Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
spec: 
  {{- .Values.quotas.rules | nindent 2 }}
{{- end }}{{- end }}{{- end }}