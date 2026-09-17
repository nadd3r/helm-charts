{{- if .Values.secretStore }}
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: {{ .Values.secretStore.name }}
spec:
  {{- if .Values.secretStore.conditions }}
  conditions:
    {{- with .Values.secretStore.conditions }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  provider:
    {{ .Values.secretStore.provider }}:
    {{- if eq .Values.secretStore.provider "gitlab" }}
      url: {{ .Values.secretStore.url }}
      projectID: {{ .Values.secretStore.projectID | quote }}
      {{- $quoted := list }}
      {{- range .Values.secretStore.groupIDs }}
      {{- $quoted = append $quoted (quote .) }}
      {{- end }}
      groupIDs: {{ printf "[%s]" (join ", " $quoted) }}
      environment: {{ .Values.secretStore.environment }}
      auth:
        SecretRef:
          accessToken:
            {{- if .Values.accessToken }}
            name: {{ .Values.accessToken.name }}
            {{- end }}
            {{- if not .Values.accessToken }}
            name: {{ .Values.secretStore.accessToken.name }}
            {{- end }}
            key: {{ .Values.secretStore.accessToken.key }}
      {{- if .Values.secretStore.caProvider }}
      caProvider:
        key: {{ .Values.secretStore.caProvider.key }}
        name: {{ .Values.secretStore.caProvider.name }}
        namespace: {{ .Values.secretStore.caProvider.namespace }}
        type: {{ .Values.secretStore.caProvider.type | default "Secret" }}
      {{- end }}
    {{- end }}
{{- end }}