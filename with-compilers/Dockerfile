FROM cskulab/isolate

ENV DEBIAN_FRONTEND=noninteractive

# TARGETARCH is provided by buildx (amd64 / arm64) and matches Go's naming.
ARG TARGETARCH

# ---------------------------------------------------------------------------
# Base tooling
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	&& rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Python 3.14 via uv (python-build-standalone) — made the default `python3`.
# Base image is Debian bookworm (no 3.14 in apt, deadsnakes is Ubuntu-only), so
# uv fetches a self-contained multi-arch build into a shared, world-readable dir.
# /usr/local/bin precedes /usr/bin on PATH, so submissions resolve
# `python3`/`python` to 3.14 while distro tooling keeps its own python.
# ---------------------------------------------------------------------------
ENV UV_PYTHON_INSTALL_DIR=/opt/python
RUN curl -LsSf https://astral.sh/uv/install.sh \
		| env UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh \
	&& uv python install 3.14 \
	&& ln -sf "$(uv python find 3.14)" /usr/local/bin/python3 \
	&& ln -sf "$(uv python find 3.14)" /usr/local/bin/python \
	&& chmod -R a+rX /opt/python

# ---------------------------------------------------------------------------
# C / C++ (C17 / C++17 capable — std selected by the task's build script)
# Java 17, NodeJS
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
	gcc \
	g++ \
	openjdk-17-jdk \
	nodejs \
	&& rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Go (latest stable, official tarball, multi-arch)
# ---------------------------------------------------------------------------
RUN GO_VERSION="$(curl -sSL https://go.dev/VERSION?m=text | head -n1)" \
	&& curl -sSL "https://go.dev/dl/${GO_VERSION}.linux-${TARGETARCH}.tar.gz" -o /tmp/go.tar.gz \
	&& rm -rf /usr/local/go \
	&& tar -C /usr/local -xzf /tmp/go.tar.gz \
	&& rm /tmp/go.tar.gz \
	&& ln -sf /usr/local/go/bin/go /usr/local/bin/go \
	&& ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
ENV PATH="/usr/local/go/bin:${PATH}"
# Writable, world-accessible GOCACHE so the sandbox user can build.
ENV GOCACHE=/tmp/go-cache GOPATH=/tmp/go

# ---------------------------------------------------------------------------
# Rust — installed to a shared location so the isolate sandbox user can run it.
# ---------------------------------------------------------------------------
ENV RUSTUP_HOME=/opt/rust CARGO_HOME=/opt/rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
	| sh -s -- -y --no-modify-path --profile minimal \
	&& chmod -R a+rX /opt/rust \
	&& for b in /opt/rust/bin/*; do ln -sf "$b" /usr/local/bin/; done
ENV PATH="/opt/rust/bin:${PATH}"

CMD ["/bin/bash", "-c", "tail -f > /dev/null"]
