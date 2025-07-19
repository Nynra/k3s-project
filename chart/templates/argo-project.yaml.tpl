{{- if .Values.enabled }}{{- if .Values.appProject.enabled }}
{{- $defaultns := .Values.namespace.name | quote }}
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: {{ .Values.appProject.name | quote }}
  annotations:
    argocd.argoproj.io/sync-wave: "1"
    # App Project annotations
    {{- if .Values.appProject.annotations }}
    {{- toYaml .Values.appProject.annotations | nindent 4 }}
    {{- end }}
    # Global annotations
    {{- if .Values.global.annotations }}
    {{- toYaml .Values.global.annotations | nindent 4 }}
    {{- end }}
    {{-  if .Values.appProject.hooked }}
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookFailed
    {{- end }}
  labels:
    # App Project labels
    {{- if .Values.appProject.labels }}
    {{- toYaml .Values.appProject.labels | nindent 4 }}
    {{- end }}
    # Global labels
    {{- if .Values.global.labels }}
    {{- toYaml .Values.global.labels | nindent 4 }}
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
    - namespace: {{ .Values.namespace | default $defaultns | quote }}
      server: {{ .Values.appProject.server | default "https://kubernetes.default.svc" | quote }}
    {{- end }}
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
{{- end }}{{- end }}
