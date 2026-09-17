{{- if .Values.secretStore }}
apiVersion: external-secrets.io/v1
kind: SecretStore
metadata:
  name: {{ .Values.secretStore.name }}
spec:
  provider:
    {{ .Values.secretStore.provider }}:
    {{- if eq .Values.secretStore.provider "gitlab" }}
      url: {{ .Values.secretStore.url }}
      projectID: {{ .Values.secretStore.projectID }}
      groupIDs: {{ .Values.secretStore.groupIDs }}
      environment: {{ .Values.secretStore.environment }}
      auth:
        secretRef:
          accessToken:
            {{- if .Values.accessToken }}
            name: {{ .Values.accessToken.name }}
            {{- end }}
            {{- if not .Values.accessToken }}
            name: {{ .Values.secretStore.accessToken.name }}
            {{- end }}
            key: {{ .Values.secretStore.accessToken.key }}
    {{- end }}
{{- end }}