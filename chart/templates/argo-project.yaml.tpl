{{- if .Values.enabled }}{{- if .Values.appProject.enabled }}
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: {{ .Values.appProject.name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    # App Project annotations
    {{- range $key, $value := .Values.appProject.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    # Global annotations
    {{- if .Values.global.annotations }}
    {{- range $key, $value := .Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{-  if .Values.appProject.hooked }}
    # Helm hook annotations to prevent deletion
    helm.sh/hook: pre-install,post-delete
    helm.sh/hook-weight: "-11"
    helm.sh/hook-delete-policy: hook-failed
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookFailed
    {{- end }}
  labels:
    # App Project labels
    {{- range $key, $value := .Values.appProject.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    # Global labels
    {{- if .Values.global.labels }}
    {{- range $key, $value := .Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  {{- if .Values.appProject.description }}
  description: {{ .Values.appProject.description | quote }}
  {{- else }}
  description: "Project for {{ .Values.appProject.name }}"
  {{- end }}
  {{- if .Values.appProject.sourceRepos }}
  sourceRepos:
    {{- range .Values.appProject.sourceRepos }}
    - {{ . | quote }}
    {{- end }}
  {{- else }}
  sourceRepos: []
  {{- end }}
  destinations:
    {{- if .Values.appProject.destinations }}
    {{- range .Values.appProject.destinations }}
    - namespace: {{ .Values.namespace | quote }}
      server: {{ .Values.appProject.server | quote }}
    {{- else }}
    # Default destination is the current namespace on the local cluster
    - namespace: {{ .Values.namespace | quote }}
      server: https://kubernetes.default.svc
    {{- end }}
  clusterResourceWhitelist:
    {{- if .Values.appProject.resourceWhitelist }}
    {{- range .Values.appProject.resourceWhitelist }}
    - group: {{ .group | quote }}
      kind: {{ .kind | quote }}
    {{- end }}
    {{- else }}
    # Deny all cluster-scoped resources from being created, except for Namespace
    - group: ''
      kind: Namespace
    {{- end }}
  namespaceResourceBlacklist:
    {{- if .Values.appProject.namespaceResourceBlacklist }}
    {{- range .Values.appProject.namespaceResourceBlacklist }}
    - group: {{ .group | quote }}
      kind: {{ .kind | quote }}
    {{- end }}
    {{- else }}
    # Allow all namespaced-scoped resources to be created, except for ResourceQuota, LimitRange, NetworkPolicy
    - group: ''
      kind: ResourceQuota
    - group: ''
      kind: LimitRange
    - group: ''
      kind: NetworkPolicy
    {{- end }}
  {{- if .Values.appProject.monitoring }}
  {{- if .Values.appProject.monitoring.enabled }}
  orphanedResources:
    warn: {{ .Values.appProject.monitoring.warnOrphaned }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}
