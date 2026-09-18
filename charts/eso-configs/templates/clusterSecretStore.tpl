{{- if .Values.clusterSecretStore }}
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: {{ .Values.clusterSecretStore.global.name }}
spec:
  {{- if .Values.clusterSecretStore.global.conditions }}
  conditions:
    {{- with .Values.clusterSecretStore.global.conditions }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
  provider:
    {{ .Values.clusterSecretStore.global.provider }}:
    {{- if eq .Values.clusterSecretStore.global.provider "gitlab" }}
      url: {{ .Values.clusterSecretStore.global.url }}
      projectID: {{ .Values.clusterSecretStore.gitlab.projectID | quote }}
      {{- $quoted := list }}
      {{- range .Values.clusterSecretStore.gitlab.groupIDs }}
      {{- $quoted = append $quoted (quote .) }}
      {{- end }}
      groupIDs: {{ printf "[%s]" (join ", " $quoted) }}
      environment: {{ .Values.clusterSecretStore.gitlab.environment }}
      auth:
        SecretRef:
          accessToken:
            {{- if .Values.accessToken }}
            name: {{ .Values.accessToken.name }}
            {{- end }}
            {{- if not .Values.accessToken }}
            name: {{ .Values.clusterSecretStore.gitlab.accessToken.name }}
            {{- end }}
            key: {{ .Values.clusterSecretStore.gitlab.accessToken.key }}
      {{- if .Values.clusterSecretStore.global.caProvider }}
      caProvider:
        key: {{ .Values.clusterSecretStore.global.caProvider.key }}
        name: {{ .Values.clusterSecretStore.global.caProvider.name }}
        namespace: {{ .Values.clusterSecretStore.global.caProvider.namespace }}
        type: {{ .Values.clusterSecretStore.global.caProvider.type | default "Secret" }}
      {{- end }}
    {{- end }}


    {{- if eq .Values.clusterSecretStore.global.provider "vault" }}
      server: {{ .Values.clusterSecretStore.global.url }}
      path: {{ .Values.clusterSecretStore.vault.path | default "kv" }}
      version: {{ .Values.clusterSecretStore.vault.version | default "v2"}}
    {{- if .Values.clusterSecretStore.global.caProvider }}
      caProvider:
        key: {{ .Values.clusterSecretStore.global.caProvider.key }}
        name: {{ .Values.clusterSecretStore.global.caProvider.name }}
        namespace: {{ .Values.clusterSecretStore.global.caProvider.namespace }}
        type: {{ .Values.clusterSecretStore.global.caProvider.type | default "Secret" }}
    {{- end }}
      auth:
        {{ .Values.clusterSecretStore.vault.authMethod }}:
        {{- if eq .Values.clusterSecretStore.vault.authMethod "kubernetes" }}
        mountPath: {{ .Values.clusterSecretStore.vault.kubernetesAuth.mountPath }}
        role: {{ .Values.clusterSecretStore.vault.kubernetesAuth.role }}
        serviceAccountRef:
          name: {{ .Values.clusterSecretStore.vault.kubernetesAuth.serviceAccount.name }}
          namespace: {{ .Values.clusterSecretStore.vault.kubernetesAuth.serviceAccount.namespace }}
        {{- end }}
    {{- end }}
{{- end }}