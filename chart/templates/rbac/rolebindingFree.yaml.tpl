{{- if .Values.enabled }}{{- if .Values.rbac }}{{- if .Values.rbac.enabled -}}
{{ range .Values.rbac.rolesbinding }}
{{- $cscope := "Role" -}} 
{{- $cbscope := "RoleBinding" -}} 
{{- if .type }}{{- if eq .type "cluster" }}
{{- $cscope = "ClusterRole" -}} 
{{- $cbscope = "ClusterRoleBinding" -}} 
{{- end }}{{- end }}
{{- if .typeRole }}{{- if eq .typeRole "cluster" }}
{{- $cscope = "ClusterRole" -}} 
{{- end }}{{- end }}
---
kind: {{ $cbscope | quote }}
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: "{{ .id }}"
  {{- if ne .type "cluster" }}
  namespace: "{{- .namespace | default $.Values.namespace.name | default .Chart.Name -}}"
  {{- end }}
  labels:
    app.kubernetes.io/name: "{{ .id }}-role"
    # Rbac labels
    {{- if $.Values.rbac.labels }}
    {{- range $key, $value := $.Values.rbac.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global labels
    {{- if $.Values.global.labels }}
    {{- range $key, $value := $.Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
  annotations:
    {{- if $.Values.rbac.annotations }}
    {{- range $key, $value := $.Values.rbac.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
    # Global annotations
    {{- if $.Values.global.annotations }}
    {{- range $key, $value := $.Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}{{- end }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: {{ $cscope | quote }}
  name: {{ .role | default "view" | quote }}
subjects:
  {{- toYaml .subjects | nindent 2 }}
{{ end }}
{{- end -}}{{- end -}}{{- end }}