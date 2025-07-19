{{- if .Values.enabled }}{{- if .Values.rbac }}{{- if .Values.rbac.enabled -}}
{{- $scope := .Values.context.scope -}}
{{- $ns := .Values.project.name | default .Chart.Name -}} 
{{ range .Values.rbac.roles }}
{{- $cscope := "Role" -}} 
{{- if .type }}{{- if eq .type "cluster" }}
{{- $cscope = "ClusterRole" -}} 
{{- end }}{{- end }}
--- 
kind: {{ $cscope | quote }}
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: "{{ .id }}"
  {{- if ne .type "cluster" }}
  namespace: "{{- .namespace | default $ns -}}"
  {{- end }}
  labels:
    app.kubernetes.io/name: "{{ .id }}-role"
    # Rbac labels
    {{- if $.Values.rbac.labels }}
    {{- range $key, $value := $.Values.rbac.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
    # Global labels
    {{- if $.Values.global.labels }}
    {{- range $key, $value := $.Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
  annotations:
    # Rbac annotations
    {{- if $.Values.rbac.annotations }}
    {{- range $key, $value := $.Values.rbac.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
    # Global annotations
    {{- if $.Values.global.annotations }}
    {{- range $key, $value := $.Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
rules:
  {{- toYaml .rules | nindent 2 }}
{{ end }}
{{- end -}}{{- end -}}{{- end }}