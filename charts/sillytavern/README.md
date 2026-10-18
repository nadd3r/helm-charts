# Sillytavern

<img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/sillytavern.png" align="right" width="92" alt="ssillytavern logo">

![Version: 0.1.20](https://img.shields.io/badge/Version-0.1.20-informational?style=flat-square)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)
![AppVersion: 1.19.0](https://img.shields.io/badge/AppVersion-1.19.0-informational?style=flat-square)

LLM Frontend for Power Users

**Homepage:** <https://sillytavern.app>

**This chart is not maintained by the upstream project and any issues with the chart should be raised
[here](https://github.com/nadd3r/helm-charts/issues/new?assignees=nadd3r&labels=bug&template=bug_report.yaml&name=sillytavern&version=0.1.18)**

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| David Nader | <noreply@sud0.net> | <https://github.com/nadd3r> |

## Source Code

* <https://github.com/SillyTavern/SillyTavern/tree/release>
* <https://github.com/nadd3r/helm-charts>

## Installing the Chart

To install the chart with the release name `sillytavern`

### OCI

```console
helm install sillytavern oci://ghcr.io/nadd3r/helm-charts/sillytavern
```

### Uninstalling the Chart

To uninstall the `sillytavern` deployment

```console
helm uninstall sillytavern
```

The command removes all the Kubernetes components associated with the chart **including persistent volumes** and deletes the release.

## Configuration

Read through the [values.yaml](./values.yaml) file. It has several commented out suggested values.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

```console
helm install sillytavern \
  --set ingress.enabled=true \
    oci://ghcr.io/nadd3r/helm-charts/sillytavern
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart.

```console
helm install sillytavern oci://ghcr.io/nadd3r/helm-charts/sillytavern -f values.yaml
```

## Limitations

Sillytavern requires some form of authentication or whitelisting. Without these the pod will repeatedly crash unless `securityOverride` is set to `true`.
This means at least one of the following must be enabled:
- `basicAuthMode`
- `whiteListMode`
- `enableUserAccounts`

> [!Warning]
> If using `enableUserAccounts` then all admin users must have a password associated with them. If no password is associate with an admin user then `securityOverride` must be set to `true` to prevent crashing.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalVolumeMounts | list | `[]` |  |
| additionalVolumes | list | `[]` |  |
| affinity | object | `{}` |  |
| auth.adminUserPassword.existingSecret.key | string | `"password"` |  |
| auth.adminUserPassword.existingSecret.name | string | `nil` |  |
| auth.adminUserPassword.password | string | `"changeMe"` |  |
| auth.basicAuthUser.existingSecret.name | string | `nil` |  |
| auth.basicAuthUser.existingSecret.passwordKey | string | `"password"` |  |
| auth.basicAuthUser.existingSecret.usernameKey | string | `"user"` |  |
| auth.basicAuthUser.password | string | `"password"` |  |
| auth.basicAuthUser.username | string | `"user"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.allowKeysExposure | bool | `false` |  |
| config.backups.allowFullDataBackup | bool | `true` |  |
| config.backups.chat.checkIntegrity | bool | `true` |  |
| config.backups.chat.enabled | bool | `true` |  |
| config.backups.chat.maxTotalBackups | int | `-1` |  |
| config.backups.chat.throttleInterval | int | `10000` |  |
| config.backups.common.numberOfBackups | int | `50` |  |
| config.basicAuthMode | bool | `false` |  |
| config.cacheBuster.enabled | bool | `false` |  |
| config.cacheBuster.userAgentPattern | string | `""` |  |
| config.claude.cachingAtDepth | int | `-1` |  |
| config.claude.enableAdaptiveThinking | bool | `false` |  |
| config.claude.enableSystemPromptCache | bool | `false` |  |
| config.claude.extendedTTL | bool | `false` |  |
| config.cors.allowedHeaders | list | `[]` |  |
| config.cors.credentials | bool | `false` |  |
| config.cors.enabled | bool | `true` |  |
| config.cors.exposedHeaders | list | `[]` |  |
| config.cors.maxAge | string | `nil` |  |
| config.cors.methods[0] | string | `"OPTIONS"` |  |
| config.cors.origin[0] | string | `"null"` |  |
| config.dataRoot | string | `"./data"` |  |
| config.deepl.formality | string | `"default"` |  |
| config.disableCsrfProtection | bool | `false` |  |
| config.enableCorsProxy | bool | `false` |  |
| config.enableDiscreetLogin | bool | `false` |  |
| config.enableDownloadableTokenizers | bool | `true` |  |
| config.enableForwardedWhitelist | bool | `true` |  |
| config.enableKeepAlive | bool | `true` |  |
| config.enableServerPlugins | bool | `false` |  |
| config.enableServerPluginsAutoUpdate | bool | `true` |  |
| config.enableUserAccounts | bool | `false` |  |
| config.extensions.autoUpdate | bool | `true` |  |
| config.extensions.enabled | bool | `true` |  |
| config.extensions.models.autoDownload | bool | `true` |  |
| config.extensions.models.captioning | string | `"Xenova/vit-gpt2-image-captioning"` |  |
| config.extensions.models.classification | string | `"Cohee/distilbert-base-uncased-go-emotions-onnx"` |  |
| config.extensions.models.embedding | string | `"Cohee/jina-embeddings-v2-base-en"` |  |
| config.extensions.models.speechToText | string | `"Xenova/whisper-small"` |  |
| config.extensions.models.textToSpeech | string | `"Xenova/speecht5_tts"` |  |
| config.forwardedHeaders.cfConnectingIp | bool | `false` |  |
| config.forwardedHeaders.xForwardedFor | bool | `true` |  |
| config.forwardedHeaders.xRealIp | bool | `true` |  |
| config.gemini.apiVersion | string | `"v1beta"` |  |
| config.gemini.enableSystemPromptCache | bool | `false` |  |
| config.gemini.image.personGeneration | string | `"allow_adult"` |  |
| config.gemini.thoughtSignatures | bool | `true` |  |
| config.git.backend | string | `"auto"` |  |
| config.heartbeatInterval | int | `10` |  |
| config.logging.enableAccessLog | bool | `true` |  |
| config.logging.minLogLevel | int | `0` |  |
| config.mistral.enablePrefix | bool | `false` |  |
| config.ollama.batchSize | int | `-1` |  |
| config.ollama.keepAlive | int | `-1` |  |
| config.openai.captionSystemPrompt | string | `""` |  |
| config.openai.randomizeUserId | bool | `false` |  |
| config.perUserBasicAuth | bool | `false` |  |
| config.performance.lazyLoadCharacters | bool | `false` |  |
| config.performance.memoryCacheCapacity | string | `"100mb"` |  |
| config.performance.requestCompression.enabled | bool | `false` |  |
| config.performance.requestCompression.maxPayloadSize | string | `"8mb"` |  |
| config.performance.requestCompression.minPayloadSize | string | `"256kb"` |  |
| config.performance.requestCompression.timeout | int | `4000` |  |
| config.performance.useDiskCache | bool | `true` |  |
| config.port | int | `8000` |  |
| config.privateAddressWhitelist.allowUnresolvedHosts | bool | `false` |  |
| config.privateAddressWhitelist.allowedRanges[0] | string | `"127.0.0.0/8"` |  |
| config.privateAddressWhitelist.allowedRanges[1] | string | `"::1/128"` |  |
| config.privateAddressWhitelist.enabled | bool | `false` |  |
| config.privateAddressWhitelist.log.allowedRequests | bool | `false` |  |
| config.privateAddressWhitelist.log.blockedRequests | bool | `true` |  |
| config.promptPlaceholder | string | `"[Start a new chat]"` |  |
| config.rateLimiting.accountsLoginMaxAttempts | int | `5` |  |
| config.rateLimiting.accountsRecoverMaxAttempts | int | `5` |  |
| config.rateLimiting.basicAuthMaxAttempts | int | `5` |  |
| config.rateLimiting.preferRealIpHeader | bool | `false` |  |
| config.requestOverrides | list | `[]` |  |
| config.requestProxy.bypass[0] | string | `"localhost"` |  |
| config.requestProxy.bypass[1] | string | `"127.0.0.1"` |  |
| config.requestProxy.enabled | bool | `false` |  |
| config.requestProxy.url | string | `"socks5://username:password@example.com:1080"` |  |
| config.securityOverride | bool | `true` |  |
| config.sessionTimeout | int | `-1` |  |
| config.skipContentCheck | bool | `false` |  |
| config.ssl.certPath | string | `"./certs/cert.pem"` |  |
| config.ssl.enabled | bool | `false` |  |
| config.ssl.keyPassphrase | string | `""` |  |
| config.ssl.keyPath | string | `"./certs/privkey.pem"` |  |
| config.sso.autheliaAuth | bool | `false` |  |
| config.sso.authentikAuth | bool | `false` |  |
| config.sso.trustedProxies[0] | string | `"::1"` |  |
| config.sso.trustedProxies[1] | string | `"127.0.0.1"` |  |
| config.thumbnails.enabled | bool | `true` |  |
| config.thumbnails.format | string | `"jpg"` |  |
| config.thumbnails.quality | int | `95` |  |
| config.whitelistDockerHosts | bool | `true` |  |
| config.whitelistImportDomains[0] | string | `"localhost"` |  |
| config.whitelistImportDomains[1] | string | `"cdn.discordapp.com"` |  |
| config.whitelistImportDomains[2] | string | `"files.catbox.moe"` |  |
| config.whitelistImportDomains[3] | string | `"raw.githubusercontent.com"` |  |
| config.whitelistMode | bool | `false` |  |
| config.whitelist[0] | string | `"::1"` |  |
| config.whitelist[1] | string | `"127.0.0.1"` |  |
| deploymentAnnotations | object | `{}` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `""` |  |
| fullnameOverride | string | `""` |  |
| httpRoute | object | `{"annotations":{},"enabled":false,"hostnames":["sillytavern.example.com"],"parentRefs":[{"name":"gateway","sectionName":"http"}],"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]}` | Expose the service via gateway-api HTTPRoute Requires Gateway API resources and suitable controller installed within the cluster (see: https://gateway-api.sigs.k8s.io/guides/) |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/sillytavern/sillytavern"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"sillytavern.example.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| initContainers | list | `[]` | Extra initContainers (templated) added to the pod. |
| livenessProbe | string | `nil` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| persistence.enabled | bool | `true` | Persist the Sillytavern data, configs, plugins, etc. If not set defaults to an emptydir which will be wiped if the container rolls. |
| persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one; when set, no PVC is rendered. |
| persistence.size | string | `"1Gi"` | PVC size. |
| persistence.storageClass | string | `""` | StorageClass for the PVC; empty uses the cluster default. |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe | string | `nil` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| strategy | object | `{"type":"Recreate"}` | Deployment update strategy. Defaults to `Recreate` because gatus can be stateful: with `persistence` on (a single ReadWriteOnce PVC) a RollingUpdate would start the new pod before the old one releases the volume, which a RWO volume can't satisfy — deadlocking the rollout. Set `{type: RollingUpdate, rollingUpdate: {...}}` for a stateless deployment (persistence off, or an RWX volume). |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)