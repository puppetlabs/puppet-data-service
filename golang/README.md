# PDS go client and cli

This directory contains:

* `pds_go_client`: the auto-generated golang client for the PDS API
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

This will result in a binary called `pds_cli` which you can run, it it self-documenting.
*NOTE* the cli is very much WIP.

Alternatively, you can run the cli by doing:

```bash
cd pds_cli
go run pds_cli/main
```
