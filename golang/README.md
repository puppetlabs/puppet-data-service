# PDS go client and cli

This directory contains:

* `pkg/pds_go_client`: the auto-generated golang client for the PDS API
* `pds_cli`: the cli tool for querying the api, `pds_cli`.

## Pre-requisites

You need a recent version of golang installed on your system. The software is tested with `go version go1.16.5 darwin/amd64`.

## Generating the go client library from the OpenAPI spec

```bash
go generate pkg/pds_go_client/doc.go
```

## Building the CLI tool

```bash
cd pds_cli
go build
```

This will result in a binary called `pds_cli` which you can run. If you run it with `--help`, it will explain how to use it.

To have a mock server to test the cli against, you can use `prism` - see [the API README](../docs/README.md) on instructions on how to use it.

Alternatively, you can run the cli by doing:

```bash
cd pds_cli
go run pds_cli/main
```

## Generating CLI docs

run `pds_cli doc <dir>` to generate cli's documentation in Markdown format into `<dir>`.
