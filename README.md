# Isolate Dockerfile

This repo builds [ioi/isolate](https://github.com/ioi/isolate/tree/master) into a Docker image.

Two images are produced:

| Image | Dockerfile | Contents |
|-------|------------|----------|
| `cskulab/isolate` | `base/Dockerfile` | isolate binary on Debian bookworm-slim |
| `cskulab/isolate-with-compilers` | `with-compilers/Dockerfile` | isolate **+ language toolchains** (used by go-grader) |

## Build & run

1. Build the image

```sh
docker build -t <tag-name> .
```

2. Run the container

```sh
docker run -v ./config:/usr/local/etc/isolate -it <tag-name>
```

Releases are automated: a `feat:`/`fix:` commit on `main` cuts a semver tag via
semantic-release, which triggers `with-compilers-workflow.yaml` to build and
push the multi-arch (`amd64` + `arm64`) image and bump go-grader's base image.

---

## Supported languages

Installed in `with-compilers/Dockerfile`:

| Language | Version | Command(s) | Install source |
|----------|---------|-----------|----------------|
| Python | 3.14 | `python3`, `python` | [uv](https://docs.astral.sh/uv/) (python-build-standalone) |
| Go | latest stable | `go` | official tarball |
| Rust | stable | `rustc`, `cargo` | rustup (`/opt/rust`) |
| Java | 17 | `javac`, `java` | apt `openjdk-17-jdk` |
| C | gcc 12 | `gcc` | apt |
| C++ | g++ 12 | `g++` | apt |
| Node.js | 18 | `node` | apt |

### How isolate runs each language

go-grader executes two scripts per submission inside the sandbox:

- **`build_script.sh`** — compile step. isolate is invoked with a fixed
  `PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`, **no
  `HOME`**, **no network**, and the sandbox box directory as a writable CWD.
- **`run_script.sh`** — run step. Executes the built artifact against test input.

Two constraints follow, and drive the setup below:

1. **Every compiler must resolve on that PATH.** `gcc`/`g++`/`java`/`node`/`python3`
   live in `/usr/bin`. Go and Rust install outside it, so the image symlinks
   `go`, `gofmt`, `rustc`, `cargo`, … into `/usr/local/bin`. Don't rely on
   `/usr/local/go/bin` or `/opt/rust/bin` being on the sandbox PATH — they are not.
2. **No `HOME` and no network at compile time.** Toolchains that want a cache
   dir or a package registry must be pointed at the writable box CWD, and
   anything needing network (e.g. `cargo` fetching crates) will fail unless the
   grader shares the network. Single-file compiles need neither.

### Per-language build / run scripts

Interpreted — no compile step needed:

```sh
# Python 3.14
# build_script.sh: (nothing)
# run_script.sh:
python3 main.py

# Node.js
# run_script.sh:
node main.js
```

Compiled:

```sh
# C  (choose the standard with -std)
# build_script.sh:
gcc -std=c17 -O2 -o main main.c
# run_script.sh:
./main

# C++
# build_script.sh:
g++ -std=c++17 -O2 -o main main.cpp
# run_script.sh:
./main

# Java 17
# build_script.sh:
javac Main.java
# run_script.sh:
java Main

# Go — set a writable GOCACHE (no HOME in the sandbox)
# build_script.sh:
export GOCACHE="$(pwd)/.gocache"
go build -o main main.go
# run_script.sh:
./main

# Rust — single file via rustc (cargo needs network, unavailable by default)
# build_script.sh:
rustc -O -o main main.rs
# run_script.sh:
./main
```

### Adding / changing a language

Edit `with-compilers/Dockerfile`, then:

- If the toolchain installs outside `/usr/bin`, **symlink its binaries into
  `/usr/local/bin`** so the sandbox PATH can see them.
- Install to a **world-readable** location (`chmod -R a+rX`) — the sandbox runs
  as an unprivileged `isolate_user`, not root.
- Keep it multi-arch: use `$TARGETARCH` (`amd64`/`arm64`) for any arch-specific
  download.
