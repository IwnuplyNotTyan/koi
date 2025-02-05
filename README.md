# Simple. Fast. Beautiful. - Koi

![koi](http://gachi.gay/0n7Yo)

``` bash
koi <example.md>
```

# Setting
```bash
export THEME=dark
```
*All default theme: dark, light, notty or dracula*
# Install

## Arch, buildpkg
``` bash
makepkg -si
```

## Build from source
``` bash
go mod tidy
go build -o koi main.go
```

## Custom Libery
[Glamour](https://github.com/charmbracelet/glamour)

[Logs](https://github.com/charmbracelet/log)
