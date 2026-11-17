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

Use it like this:
```r
source("https://raw.githubusercontent.com/ivanharvard/stat139-final-project/main/load_all.R")
run_script("r/02_eda.R")
```



