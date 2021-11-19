## Linting the OpenAPI spec

```
npm install -g @stoplight/spectral-cli
spectral lint api.yml
```

Note that `spectral` needs a rule to do the linting, a default rule (basically repeating a built-in rule) is in `.spectral.yaml`.

## Spinning up a mock API

```
npm install -g prism
prism mock api.yml
```

