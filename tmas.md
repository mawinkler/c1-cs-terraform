# Trend Micro Artifact Scanning CLI

- [Trend Micro Artifact Scanning CLI](#trend-micro-artifact-scanning-cli)
  - [Get TMAS](#get-tmas)
  - [Cloud One](#cloud-one)
  - [Prepare an Image](#prepare-an-image)
  - [Environment](#environment)
  - [Test](#test)

## Get TMAS

- <https://cli.artifactscan.cloudone.trendmicro.com/tmas-cli/latest/tmas-cli_Linux_x86_64.tar.gz>
- <https://cli.artifactscan.cloudone.trendmicro.com/tmas-cli/latest/tmas-cli_Darwin_x86_64.zip>

```
Usage:
  tmas scan [artifact] [flags]

Aliases:
  scan, inspect, s

Examples:

Use this command to scan an artifact
tmas scan docker:yourrepo/yourimage:tag          |  use images from the Docker daemon
tmas scan podman:yourrepo/yourimage:tag          |  use images from the Podman daemon
tmas scan docker-archive:path/to/yourimage.tar   |  use a tarball from disk for archives created from \"docker save\"
tmas scan oci-archive:path/to/yourimage.tar      |  use a tarball from disk for OCI archives (from Skopeo or otherwise)
tmas scan oci-dir:path/to/yourimage              |  read directly from a path on disk for OCI layout directories (from Skopeo or otherwise)
tmas scan singularity:path/to/yourimage.sif      |  read directly from a Singularity Image Format (SIF) container on disk
tmas scan registry:yourrepo/yourimage:tag        |  pull image directly from a registry (no container runtime required)
tmas scan dir:path/to/yourproject                |  read directly from a path on disk (any directory)
tmas scan file:path/to/yourproject/file          |  read directly from a path on disk (any single file)

Flags:
  -h, --help            help for scan
  -r, --region string   cloud one region [au-1 ca-1 de-1 gb-1 in-1 jp-1 sg-1 trend-us-1 us-1] (optional) (default "us-1")
      --saveSBOM        Save SBOM in the local directory (optional)

Global Flags:
  -v, --verbose count   counted verbosity (-v = info, -vv = debug)
```

## Cloud One

In `Administration --> Roles` create a role with the following settings:

- Name: Scanner
- ID: scanner
- Privileges:
  - Service: Container Security
  - Permissions: Scanner

In `Container Security --> Artifact Scanner Installation` click on `Create "Scanner" role and generate API key.

Copy the key: xxxxxxxxxxxxxxxxxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

You can find a new API Key generated `Administration --> API Keys`

- API Key Alias: scanner key
- Role: Scanner

In `Container Security --> Policies --> Artifact Scanner Scan results` set

- Block images that are not scanned
- Block images with vulnerabilities whose severity is medium or higher

## Prepare an Image

Create a public repo on ECR

```sh
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/g1k6g7f0

docker pull ubuntu:latest
docker tag ubuntu:latest public.ecr.aws/g1k6g7f0/shell:latest
docker push public.ecr.aws/g1k6g7f0/shell:latest
```

## Environment

```sh
export CLOUD_ONE_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Test

```sh
kubectl run myshell -it --image=public.ecr.aws/g1k6g7f0/shell:latest --restart=Never -- bash
```

```
Error from server: admission webhook "trendmicro-admission-controller.trendmicro-system.svc" denied the request: 
- unscannedImage violated in container(s) "myshell" (block).
```

```sh
./tmas scan --endpoint https://artifactscan.us-1.staging-cloudone.trendmicro.com registry:public.ecr.aws/g1k6g7f0/shell:latest
```

```
Scan Complete
{
  "totalVulnCount": 21,
  "criticalCount": 0,
  "highCount": 0,
  "mediumCount": 6,
  "lowCount": 7,
  "negligibleCount": 8,
  "unknownCount": 0,
  "findings": {
...
```

```sh
kubectl run myshell -it --image=public.ecr.aws/g1k6g7f0/shell:latest --restart=Never -- bash
```

```
Error from server: admission webhook "trendmicro-admission-controller.trendmicro-system.svc" denied the request: 
- vulnerabilities violates rule with properties { max-severity:low } in container(s) "myshell" (block).
```

Turning `Block` to `Log` in the policy...

```sh
kubectl run myshell -it --image=public.ecr.aws/g1k6g7f0/shell:latest --restart=Never -- bash
```

```
If you don't see a command prompt, try pressing enter.
root@myshell:/# 
```
