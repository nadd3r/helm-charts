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
| deploymentAnnotations | object | `{}` |  |
| dnsConfig | object | `{}` |  |
| dnsPolicy | string | `""` |  |
| extraEnv | list | `[]` | Extra environment variables. |
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
| livenessProbe | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| persistence.accessMode | string | `"ReadWriteOnce"` | PVC access mode. |
| persistence.enabled | bool | `false` | Persist the Sillytavern data, configs, plugins, etc. If not set defaults to an emptydir which will be wiped if the container rolls. |
| persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one; when set, no PVC is rendered. |
| persistence.size | string | `"1Gi"` | PVC size. |
| persistence.storageClass | string | `""` | StorageClass for the PVC; empty uses the cluster default. |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe | list | `[]` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| sillytavern.allowKeysExposure | bool | `false` |  |
| sillytavern.backups.allowFullDataBackup | bool | `true` |  |
| sillytavern.backups.chat.checkIntegrity | bool | `true` |  |
| sillytavern.backups.chat.enabled | bool | `true` |  |
| sillytavern.backups.chat.maxTotalBackups | int | `-1` |  |
| sillytavern.backups.chat.throttleInterval | int | `10000` |  |
| sillytavern.backups.common.numberOfBackups | int | `50` |  |
| sillytavern.basicAuthMode | bool | `false` |  |
| sillytavern.basicAuthUser.existingSecret.name | string | `nil` |  |
| sillytavern.basicAuthUser.existingSecret.passwordKey | string | `nil` |  |
| sillytavern.basicAuthUser.existingSecret.usernameKey | string | `nil` |  |
| sillytavern.basicAuthUser.password | string | `"changeMe"` |  |
| sillytavern.basicAuthUser.username | string | `"admin"` |  |
| sillytavern.cacheBuster.enabled | bool | `false` |  |
| sillytavern.cacheBuster.userAgentPattern | string | `""` |  |
| sillytavern.claude.cachingAtDepth | int | `-1` |  |
| sillytavern.claude.enableAdaptiveThinking | bool | `false` |  |
| sillytavern.claude.enableSystemPromptCache | bool | `false` |  |
| sillytavern.claude.extendedTTL | bool | `false` |  |
| sillytavern.deepl.formality | string | `"default"` |  |
| sillytavern.defaultUser.existingSecret.key | string | `"password"` |  |
| sillytavern.defaultUser.existingSecret.name | string | `nil` |  |
| sillytavern.defaultUser.password | string | `"changeMe"` |  |
| sillytavern.disableCsrfProtection | bool | `false` |  |
| sillytavern.enableDiscreetLogin | bool | `false` |  |
| sillytavern.enableDownloadableTokenizers | bool | `true` |  |
| sillytavern.enableForwardedWhitelist | bool | `true` |  |
| sillytavern.enableKeepAlive | bool | `false` |  |
| sillytavern.enableServerPlugins | bool | `false` |  |
| sillytavern.enableServerPluginsAutoUpdate | bool | `true` |  |
| sillytavern.enableUserAccounts | bool | `false` |  |
| sillytavern.extensions.autoUpdate | bool | `true` |  |
| sillytavern.extensions.enabled | bool | `true` |  |
| sillytavern.extensions.models.autoDownload | bool | `true` |  |
| sillytavern.extensions.models.captioning | string | `"Xenova/vit-gpt2-image-captioning"` |  |
| sillytavern.extensions.models.classification | string | `"Cohee/distilbert-base-uncased-go-emotions-onnx"` |  |
| sillytavern.extensions.models.embedding | string | `"Cohee/jina-embeddings-v2-base-en"` |  |
| sillytavern.extensions.models.speechToText | string | `"Xenova/whisper-small"` |  |
| sillytavern.extensions.models.textToSpeech | string | `"Xenova/speecht5_tts"` |  |
| sillytavern.forwardedHeaders.cfConnectingIp | bool | `false` |  |
| sillytavern.forwardedHeaders.xForwardedFor | bool | `true` |  |
| sillytavern.forwardedHeaders.xRealIp | bool | `true` |  |
| sillytavern.gemini.apiVersion | string | `"v1beta"` |  |
| sillytavern.gemini.enableSystemPromptCache | bool | `false` |  |
| sillytavern.gemini.image.personGeneration | string | `"allow_adult"` |  |
| sillytavern.gemini.thoughtSignatures | bool | `true` |  |
| sillytavern.git.backend | string | `"auto"` |  |
| sillytavern.hostWhitelist.enabled | bool | `false` |  |
| sillytavern.hostWhitelist.hosts[0] | string | `"sillytavern.example.com"` |  |
| sillytavern.hostWhitelist.scan | bool | `true` |  |
| sillytavern.logging.enableAccessLog | bool | `true` |  |
| sillytavern.logging.minLogLevel | int | `0` |  |
| sillytavern.mistral.enablePrefix | bool | `false` |  |
| sillytavern.ollama.batchSize | int | `-1` |  |
| sillytavern.ollama.keepAlive | int | `-1` |  |
| sillytavern.openai.captionSystemPrompt | string | `""` |  |
| sillytavern.openai.randomizeUserId | bool | `false` |  |
| sillytavern.perUserBasicAuth | bool | `false` |  |
| sillytavern.performance.lazyLoadCharacters | bool | `false` |  |
| sillytavern.performance.memoryCacheCapacity | string | `"100mb"` |  |
| sillytavern.performance.requestCompression.enabled | bool | `false` |  |
| sillytavern.performance.requestCompression.maxPayloadSize | string | `"8mb"` |  |
| sillytavern.performance.requestCompression.minPayloadSize | string | `"256kb"` |  |
| sillytavern.performance.requestCompression.timeout | int | `4000` |  |
| sillytavern.performance.useDiskCache | bool | `true` |  |
| sillytavern.privateAddressWhitelist.allowUnresolvedHosts | bool | `false` |  |
| sillytavern.privateAddressWhitelist.allowedRanges[0] | string | `"127.0.0.0/8"` |  |
| sillytavern.privateAddressWhitelist.allowedRanges[1] | string | `"::1/128"` |  |
| sillytavern.privateAddressWhitelist.enabled | bool | `true` |  |
| sillytavern.privateAddressWhitelist.log.allowedRequests | bool | `false` |  |
| sillytavern.privateAddressWhitelist.log.blockedRequests | bool | `true` |  |
| sillytavern.promptPlaceholder | string | `"[Start a new chat]"` |  |
| sillytavern.rateLimiting.accountsLoginMaxAttempts | int | `5` |  |
| sillytavern.rateLimiting.accountsRecoverMaxAttempts | int | `5` |  |
| sillytavern.rateLimiting.accountsResetMaxAttempts | int | `5` |  |
| sillytavern.rateLimiting.basicAuthMaxAttempts | int | `5` |  |
| sillytavern.rateLimiting.preferRealIpHeader | bool | `false` |  |
| sillytavern.requestOverrides | list | `[]` |  |
| sillytavern.securityOverride | bool | `false` |  |
| sillytavern.sessionTimeout | int | `-1` |  |
| sillytavern.skipContentCheck | bool | `false` |  |
| sillytavern.sso.autheliaAuth | bool | `false` |  |
| sillytavern.sso.authentikAuth | bool | `false` |  |
| sillytavern.sso.trustedProxies[0] | string | `"::1"` |  |
| sillytavern.sso.trustedProxies[1] | string | `"127.0.0.1"` |  |
| sillytavern.thumbnails.dimensions | string | `"'bg': [160, 90], 'avatar': [96, 144], 'persona': [96, 144]"` |  |
| sillytavern.thumbnails.enabled | bool | `true` |  |
| sillytavern.thumbnails.format | string | `"jpg"` |  |
| sillytavern.thumbnails.quality | int | `95` |  |
| sillytavern.whitelistImportDomains[0] | string | `"localhost"` |  |
| sillytavern.whitelistImportDomains[1] | string | `"cdn.discordapp.moe"` |  |
| sillytavern.whitelistImportDomains[2] | string | `"files.catbox.moe"` |  |
| sillytavern.whitelistImportDomains[3] | string | `"raw.githubusercontent.com"` |  |
| sillytavern.whitelistMode | bool | `false` |  |
| sillytavern.whitelist[0] | string | `"::1"` |  |
| sillytavern.whitelist[1] | string | `"127.0.0.1"` |  |
| strategy | object | `{"type":"Recreate"}` | Deployment update strategy. Defaults to `Recreate` because gatus can be stateful: with `persistence` on (a single ReadWriteOnce PVC) a RollingUpdate would start the new pod before the old one releases the volume, which a RWO volume can't satisfy — deadlocking the rollout. Set `{type: RollingUpdate, rollingUpdate: {...}}` for a stateless deployment (persistence off, or an RWX volume). |
| tolerations | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)