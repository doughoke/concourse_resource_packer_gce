# concourse_resource_packer_gce

# Packer Build Resource for GCP based GCE

A Concourse CI resource to build new [Google Compute Images (Image) via Packer](https://www.packer.io/docs/builders/googlecompute.html)

This is spawned from

- https://github.com/jdub/packer-resource
- https://github.com/rjshep/packer-resource

## Source Configurations
- `project` (optional string): The project name the image is in (should be used when the account may not have permission to the default parent account)
- `region` (required string): The GCP region to work in
- `credentials` (required string): for GCP account
- `family` (optional string): used for check if you are triggering against an image family
- `debug` (optional string): defaults to false


## Behaviour

### `check`: Check for new versions of a GCE Image

Returns an ordered list of versions that match the criteria specified in the source.  This can be used to trigger a new build when a new version of a GCE Image is created.

### `in`: Get metadata about an AMI

Provides 3 files:
- `version.txt` - a text file containing the selected Image Name
- `version.json` - a JSON file containing the selected Image Name in the `image` field of the json parent version
- `image.json` - the GCE [metadata](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html) for the selected Image

### `out`: Build a new GCP Image

#### Parameters
- `template` (required string): The path to the packer template.
- `var_file` (optional string or list): The path or list of paths to a [external JSON variable file]
(https://www.packer.io/docs/templates/user-variables.html).

All other parameters will be passed through to packer as variables.

** source.project will not be read by out process only in and check. 'project' must be passed in the packer file or packer variable.

## Example

```yaml
resource_types:
- name: packer-gce
  type: docker-image
  source:
    repository: doughoke/packer-resource-gce

resources:
- name: base-gce-image
  type: packer-gce
  source:
    region: us-central1a
    credentials: (gce_json_key)
    family: centos

- name: created-image
  type: packer-gce
  source:
    region: us-central1a
    credentials: (gce_json_key)
    project: your-project

- name: my-packer-template-source
  type: git
  source:
    uri: https://github.com/packdemo/packergce

jobs:
- name: sample-gce-image
  plan:
  - get: my-packer-template-source
    trigger: true
  - get: base-gce-image
    trigger: true
  - put: created-image
    params:
      template: my-packer-template-source/packer_template.json
      var_file:
        - base-gce-image/version.json
        - my-packer-template-source/packer_params.json
  ```
