{{- if .Values.enabled }}{{- if .Values.namespace.enabled }}
kind: Namespace
apiVersion: v1
metadata:
  name: {{ .Values.namespace.name | quote }}
  labels: 
    # Namespace labels
    {{- if .Values.namespace.labels }}
    {{- range $key, $value := .Values.namespace.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
    # Global labels
    {{- if .Values.global.labels }}
    {{- range $key, $value := .Values.global.labels }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    {{- end }}
  annotations:
    # Namespace annotations
    {{- range $key, $value := .Values.namespace.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
    # Global annotations
    {{- if .Values.global.annotations }}
    {{- range $key, $value := .Values.global.annotations }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
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