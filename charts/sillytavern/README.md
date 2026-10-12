# Sillytavern

<img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/sillytavern.png" align="right" width="92" alt="ssillytavern logo">


![Version: 0.1.19](https://img.shields.io/badge/Version-0.1.19-informational?style=flat)
![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat)
![AppVersion: 1.19.0](https://img.shields.io/badge/AppVersion-1.19.0-informational?style=flat)

LLM Frontend for Power Users

**Homepage:** <https://sillytavern.app>

**This chart is not maintained by the upstream project and any issues with the chart should be raised
[here](https://github.com/nadd3r/helm-charts/issues/new?assignees=nadd3r&labels=bug&template=bug_report.yaml&name=sillytavern&version=0.1.18)**

## Source Code

* <https://github.com/SillyTavern/SillyTavern>

## Requirements

Kubernetes: `>=1.37.0-0`

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