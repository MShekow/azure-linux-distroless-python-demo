# azure-linux-distroless-python-demo

Demonstrates how to build a minimal Flask-based Python application using a self-built Azure Linux Distroless Python image. 


This repository demonstrates how to build a minimal Flask-based Python application using a self-built [Azure Linux](https://github.com/microsoft/azurelinux) Distroless Python image.

This repo creates a daily re-build of the Python3.12 Distroless base image (see [workflow](.github/workflows/build-python-base-image.yml)), and pushes it in case the contained packages were changed.

The [Dockerfile](Dockerfile) demonstrates how to use a multi-stage build and make corrections for the Python interpreter path.

To start the demo app, run `docker run --rm -p 8000:8000 ghcr.io/mshekow/python-az-distroless-demo-app:latest` and access it on http://localhost:8000/.
