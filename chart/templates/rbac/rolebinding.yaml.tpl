{{- if .Values.enabled }}{{- if .Values.rbac }}{{- if .Values.rbac.enabled -}}
# Groups manifests
{{ range .Values.rbac.groups }}
{{- $cscope := "RoleBinding" -}} 
{{- if .type }}{{- if eq .type "cluster" }}
{{- $cscope = "ClusterRoleBinding" -}} 
{{- end }}{{- end }}
---
kind: {{ $cscope | quote }}
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: "{{ .id }}"
  {{- if ne .type "cluster" }}
  namespace: {{- .namespace }}
  {{- end }}
  labels:
    app.kubernetes.io/name: "{{ .id }}-rolebinding"
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
    # Rbac annotations
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
  kind: ClusterRole
  name: {{ .role | default "view" | quote }}
subjects:
  - kind: Group
    apiGroup: rbac.authorization.k8s.io
    name: {{ .name | quote }}
{{ end }}
# User manifests
{{ range .Values.rbac.users }}
{{- $cscope := "RoleBinding" -}} 
{{- if .type }}{{- if eq .type "cluster" }}
{{- $cscope = "ClusterRoleBinding" -}} 
{{- end }}{{- end }}
---
kind: {{ $cscope | quote }}
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: "{{ .id }}"
  {{- if ne .type "cluster" }}
  namespace: {{- .namespace }}
  {{- end }}
  labels:
    app.kubernetes.io/name: "{{ .id }}-rolebinding"
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
    # Rbac annotations
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
  kind: ClusterRole
  name: {{ .role | default "view" | quote }}
subjects:
  - kind: User
    apiGroup: rbac.authorization.k8s.io
    name: {{ .name | quote }}
{{ end }}
# ServiceAccount manifests
{{ range .Values.rbac.sa }}
{{- $cscope := "RoleBinding" -}} 
{{- if .type }}{{- if eq .type "cluster" }}
{{- $cscope = "ClusterRoleBinding" -}} 
{{- end }}{{- end }}
---
kind: {{ $cscope | quote }}
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: "{{ .id }}"
  {{- if ne .type "cluster" }}
  namespace: {{- .namespace }}
  {{- end }}
  labels:
    app.kubernetes.io/name: "{{ .id }}-rolebinding"
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
    # Rbac annotations
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
  kind: ClusterRole
  name: {{ .role | default "view" | quote }}
subjects:
  - kind: ServiceAccount
    name: {{ .name | quote }}
    namespace: {{- .namespace }}
{{ end }}
{{- end -}}{{- end -}}{{- end }}