{{- if not ( and .Values.kanbn.authSecret.existingSecret.secretName .Values.kanbn.database.existingSecret.secretName .Values.kanbn.s3.accessKey.existingSecret.secretName ( and .Values.kanbn.oidc.client.existingSecret.secretName ( eq .Values.kanbn.oidc.enabled true)))}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "kanbn.fullname" . }}-secrets
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "kanbn.labels" . | nindent 4 }}
type: Opaque
data:
  {{- if not .Values.kanbn.database.existingSecret.secretName }}
  uri: {{ .Values.kanbn.database.url | b64enc | quote }}
  {{- end }}
  {{- if not .Values.kanbn.authSecret.existingSecret.secretName }}
  authSecret: {{ .Values.kanbn.authSecret.value | b64enc | quote }}
  {{- end }}
  {{- if not .Values.kanbn.s3.accessKey.existingSecret.secretName }}
  accessKeyId: {{ .Values.kanbn.s3.accessKey.id | b64enc | quote }}
  secretAccessKey: {{ .Values.kanbn.s3.accessKey.secret | b64enc | quote }}
  {{- end }}
  {{- if not .Values.kanbn.oidc.client.existingSecret.secretName }}
  clientId: {{ .Values.kanbn.oidc.client.id | b64enc | quote }}
  clientSecret: {{ .Values.kanbn.oidc.client.secret | b64enc | quote }}
  {{- end }}
{{- end }}