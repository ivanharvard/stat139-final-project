# use in .Rmd files like this:
# ```
# source("https://raw.githubusercontent.com/ivanharvard/stat139-final-project/main/load_all.R")
# run_script("r/02_eda.R")
# ```

run_script = local({
    repo = "ivanharvard/stat139-final-project"

    # walk up from the working directory looking for this project's uvr.toml
    find_local_root = function() {
        dir = normalizePath(getwd())
        repeat {
            toml = file.path(dir, "uvr.toml")
            if (file.exists(toml) &&
                any(grepl('^name = "stat139-final-project"', readLines(toml, warn = FALSE)))) {
                return(dir)
            }
            parent = dirname(dir)
            if (parent == dir) return(NULL)
            dir = parent
        }
    }

    download_root = function() {
        tarball = tempfile(fileext = ".tar.gz")
        url = sprintf("https://github.com/%s/archive/main.tar.gz", repo)
        download.file(url, tarball, mode = "wb", quiet = TRUE)

        exdir = tempfile("stat139-")
        untar(tarball, exdir = exdir)
        list.dirs(exdir, recursive = FALSE)[1]
    }

    # install whatever uvr.toml lists under [dependencies] that isn't installed
    install_dependencies = function(root) {
        toml = trimws(readLines(file.path(root, "uvr.toml"), warn = FALSE))
        start = match("[dependencies]", toml)
        if (is.na(start)) return(invisible())

        rest = toml[-seq_len(start)]
        section_end = grep("^\\[", rest)
        if (length(section_end) > 0) rest = rest[seq_len(section_end[1] - 1)]

        pkgs = sub("^([A-Za-z0-9.]+)\\s*=.*$", "\\1", grep("^[A-Za-z0-9.]+\\s*=", rest, value = TRUE))
        missing = pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
        if (length(missing) == 0) return(invisible())

        repos = getOption("repos")
        if (is.null(repos) || !nzchar(repos["CRAN"]) || repos["CRAN"] == "@CRAN@") {
            repos = c(CRAN = "https://cloud.r-project.org")
        }
        message("Installing: ", paste(missing, collapse = ", "))
        install.packages(missing, repos = repos)
    }

    root = find_local_root()
    if (is.null(root)) root = download_root()
    install_dependencies(root)

    # path: a file relative to the repo root ("r/02_eda.R")
    function(path) {
        file = file.path(root, path)
        if (!file.exists(file)) stop("No file '", path, "' in ", root)

        old = setwd(root)
        on.exit(setwd(old), add = TRUE)
        source(file, local = globalenv())
    }
})
