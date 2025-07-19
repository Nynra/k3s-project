{{- if .Values.enabled }}{{- if .Values.namespace.enabled }}
kind: Namespace
apiVersion: v1
metadata:
  name: {{ .Values.namespace.name | default .Chart.Name | quote }}
  labels: 
    # Namespace labels
    {{- if .Values.namespace.labels }}
    {{- toYaml .Values.namespace.labels | nindent 4 }}
    {{- end }}
    # Global labels
    {{- if .Values.global.labels }}
    {{- toYaml .Values.global.labels | nindent 4 }}
    {{- end }}
  annotations:
    # Namespace annotations
    {{- if .Values.namespace.annotations }}
    {{- toYaml .Values.namespace.annotations | nindent 4 }}
    {{- end }}
    # Global annotations
    {{- if .Values.global.annotations }}
    {{- toYaml .Values.global.annotations | nindent 4 }}
    {{- end }}
    # Argocd wave
    argocd.argoproj.io/sync-wave: "-10"
    # Helm hook annotations to prevent deletion
    {{- if .Values.namespace.hooked }}
    helm.sh/hook: pre-install,post-delete
    helm.sh/hook-weight: "-10"
    helm.sh/hook-delete-policy: hook-failed
    argocd.argoproj.io/hook: PreSync
    argocd.argoproj.io/hook-delete-policy: HookFailed
    {{- end }}
{{- end }}
{{- end }}