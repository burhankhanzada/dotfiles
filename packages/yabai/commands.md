# Commands

## Disable System Integrity Protection

```sh
csrutil enable --without fs --without debug --without nvram
```

## Stop services

```sh
brew services stop skhd
```

## View mistakes in skhdrc file

```sh
skhd -V
```
