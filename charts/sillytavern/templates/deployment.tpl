apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "sillytavern.fullname" . }}
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "sillytavern.labels" . | nindent 4 }}
{{- with .Values.deploymentAnnotations }}
  annotations:
    {{- tpl (toYaml .) $ | nindent 4 }}
{{- end }}
spec:
{{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
{{- end }}
{{- with .Values.strategy }}
  strategy:
    {{- toYaml . | nindent 4 }}
{{- end}}
  selector:
    matchLabels:
      {{- include "sillytavern.selectorLabels" . | nindent 6 }}
  template:
    metadata:
{{- with .Values.podAnnotations }}
      annotations:
        {{- tpl (toYaml .) $ | nindent 8 }}
{{- end }}
      labels:
        {{- include "sillytavern.labels" . | nindent 8 }}
{{- with .Values.podLabels }}
        {{- tpl (toYaml .) $ | nindent 8 }}
{{- end }}
    spec:
{{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
{{- end }}
      serviceAccountName: {{ include "sillytavern.serviceAccountName" . }}
{{- with .Values.podSecurityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.dnsPolicy }}
      dnsPolicy: {{ tpl . $ | quote }}
{{- end }}
{{- with .Values.dnsConfig }}
      dnsConfig:
        {{- tpl (toYaml .) $ | nindent 8 }}
{{- end }}
{{- with .Values.resources }}
      resources:
        {{- tpl (toYaml .) $ | nindent 8 }}
{{- end }}
      containers:
        - name: {{ .Chart.Name }}
{{- with .Values.securityContext }}
          securityContext:
            {{- toYaml . | nindent 12 }}
{{- end }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.service.port }}
              protocol: TCP
{{- with .Values.livenessProbe }}
          livenessProbe:
            {{- toYaml . | nindent 12 }}
{{- end }}
{{- with .Values.readinessProbe }}
          readinessProbe:
            {{- toYaml . | nindent 12 }}
{{- end }}
{{- with .Values.resources }}
          resources:
            {{- toYaml . | nindent 12 }}
{{- end }}
          envFrom:
          - configMapRef:
              name: {{ include "sillytavern.fullname" . }}-env
{{- if .Values.config.basicAuthMode }}
          - secretRef:
              name: {{ include "sillytavern.fullname" . }}-secrets
{{- end }}
          volumeMounts:
          - mountPath: /home/node/app/config
            name: sillytavern-data
            subPath: config
          - mountPath: /home/node/app/data
            name: sillytavern-data
            subPath: data
          - mountPath: /home/node/app/plugins
            name: sillytavern-data
            subPath: plugins
          - mountPath: /home/node/app/public/scripts/extensions/third-party
            name: sillytavern-data
            subPath: extensions
{{- with .Values.additionalVolumeMounts }}
            {{- toYaml . | nindent 12 }}
{{- end }}
      volumes:
{{- if .Values.persistence.enabled }}
      - name: sillytavern-data
        persistentVolumeClaim:
          claimName: {{ .Values.persistence.existingClaim | default ( include "sillytavern.fullname" . ) }}
{{- end }}
{{- if not .Values.persistence.enabled}}
      - name: sillytavern-data
        emptyDir: {}
{{- end }}
{{- with .Values.additionalVolumes }}
        {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
{{- end }}
