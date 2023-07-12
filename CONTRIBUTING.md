# Contributing

EximiaIT is a collection of **community maintained** charts.


## Versioning

Each chart's version follows the [semver standard](https://semver.org/).

New charts should start at version `1.0.0`, if it's considered stable. If it isn't considered stable, it must be released as `1.0.0-rc.x`.


### New Application Versions

When selecting new application versions ensure you make the following changes:

* `Chart.yaml`: Bump `version`


### Chart Versioning

Currently we require a chart version bump for every change to a chart.


#### Changelog

We require a changelog per new chart release.

Changes on a chart must be documented in a chart specific changelog in the `Chart.yaml` [Annotation Section](https://helm.sh/docs/topics/charts/#the-chartyaml-file).

A new `artifacthub.io/changes` needs to be written covering only the changes since the previous release.

Each change requires a new bullet point following the pattern. See more information [Artifact Hub annotations in Helm Chart.yaml file](https://artifacthub.io/docs/topics/annotations/helm/).

```yaml
- kind: {type}
  description: {description}
```

You can use the following template:

```yaml
name: openshift-secured-app
version: 1.0.0
...
annotations:
  artifacthub.io/changes: |
    - kind: added
      description: Something New was added
    - kind: changed
      description: Changed Something within this chart
    - kind: changed
      description: Changed Something else within this chart
    - kind: deprecated
      description: Something deprecated
    - kind: removed
      description: Something was removed
    - kind: fixed
      description: Something was fixed
    - kind: security
      description: Some Security Patch was included
```

## Testing

### Testing Charts

We run Helm's [Chart Testing](https://github.com/helm/chart-testing) tool.

Linting configuration can be found in [lint.yaml](./.github/configs/lint.yaml)

## Publishing Changes

Changes are automatically publish whenever a commit is merged to the `main` branch by the CI job (see `.github/workflows/release.yml`).