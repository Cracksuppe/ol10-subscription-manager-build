# subscription-manager Build for Oracle Linux 10

This repository provides a **Docker-based build environment** and script to compile the `subscription-manager` package for **Oracle Linux 10 (OL10)**.

The build process reuses the upstream sources from Red Hat's UBI 10 base image and produces RPMs that can be installed on Oracle Linux 10.

---

## How it works

- The `build.sh` script determines the latest available version of:
  - `subscription-manager`
  - `subscription-manager-rhsm-certificates`
- A temporary Docker image is built (`build-rhsm:ol10-<git-hash>`).
- The script runs a container, passing the detected version numbers as environment variables.
- The container builds the RPM packages and places them in the local `output/` directory.
- Optional: a GPG key can be provided via `gpg/` to sign the resulting RPMs.

---

## Requirements

- **Docker** (or Podman, if compatible with your setup)
- Git (used for tagging the build version, falls back to a timestamp otherwise)
- Internet access (to fetch upstream sources and dependencies)

---

## Usage

Clone the repository and run:

```bash
./build.sh
