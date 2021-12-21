# PDS go client and cli

This directory contains:

* `pkg/pds-go-client`: the auto-generated golang client for the PDS API
* `pds-cli`: the cli tool for querying the api, `pds-cli`.

## Pre-requisites

You need a recent version of golang installed on your system. The software is tested with `go version go1.16.5 darwin/amd64`.

## Generating the go client library from the OpenAPI spec

```bash
cd pds-cli
make generate
```

## Building the CLI tool

```bash
cd pds-cli
make build
```

This will result in a binary called `pds-cli` which you can run. If you run it with `--help`, it will explain how to use it.

To have a mock server to test the cli against, you can use `prism` - see [the API README](../docs/README.md) on instructions on how to use it.

Alternatively, you can run the cli by doing:

```bash
cd pds-cli
go run pds-cli/main
```

## Generating CLI docs

run `pds-cli doc -d <dir>` to generate cli's documentation in Markdown format into `<dir>`.

## Running a test suite

There is a simple test suite taking the cli through its paces (basically, calling all its commands and subcommands) against a proxy server.

```bash
cd pds-cli
make proxy # wait until the mock server and a proxy both start up - you will need prism to be installed for this to rowk
make test # this should all pass without errors
make killproxy # this will kill all node processes!
```

The `make proxy` target spins up two instance of `prism`:

* a normal prism mock API server on port 4011
* a `prism` proxy on port 4010, forwarding requests to the mock API server

This ensures that the proxy does its request and response validation while using the mock api server as the proxy backend.
