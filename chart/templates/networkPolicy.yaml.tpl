{{- if .Values.enabled }}{{- if .Values.networkpolicy }}{{- if .Values.networkpolicy.enabled -}}
{{ range .Values.networkpolicy.rules }} 
---
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: "{{ .id }}"
  namespace: "{{- .Values.namespace.name | default .Chart.Name -}}"
  labels:
    app.kubernetes.io/name: "{{ .id }}-networkpolicy"
    # NetworkPolicy labels
    {{- if $.Values.networkpolicy.labels }}
    {{- range $key, $value := $.Values.networkpolicy.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global labels
    {{- if $.Values.global.labels }}
    {{- range $key, $value := $.Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
  annotations:
    {{- if $.Values.networkpolicy.annotations }}
    {{- range $key, $value := $.Values.networkpolicy.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global annotations
    {{- if $.Values.global.annotations }}
    {{- range $key, $value := $.Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
spec: 
  {{- .spec | nindent 2 }}
{{ end }}
{{- end }}{{- end }}{{- end }}