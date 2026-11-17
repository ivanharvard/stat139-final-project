# Instructions

## Install dependencies

First, install `uvr`.

1. Linux/MacOS
```bash
curl -fsSL https://raw.githubusercontent.com/nbafrank/uvr/main/install.sh | sh
```
2. Windows
```pwsh
irm https://raw.githubusercontent.com/nbafrank/uvr/main/install.ps1 | iex
```

Then, sync with the project.
```bash
uvr sync
```

> If you'd like to add a new dependency, use
> ```
> uvr add PackageNameGoesHere
> ```

## Running Scripts

Run with:
```
uvr run r/FileNameGoesHere
```

## Using in .Rmd files

`source()` is a function that runs other `.R` and `.Rmd` files. 



