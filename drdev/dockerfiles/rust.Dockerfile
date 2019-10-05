ARG BASE_REPO=ageekinside
FROM ${BASE_REPO}/base

USER root
RUN wget -O /usr/local/share/ca-certificates/MITRE-BA-Root.crt http://pki.mitre.org/MITRE%20BA%20Root.crt
RUN wget -O /usr/local/share/ca-certificates/MITRE-BA-NPE-CA-3.crt "http://pki.mitre.org/MITRE%20BA%20NPE%20CA-3(1).crt"
RUN update-ca-certificates

ENV DEBIAN_FRONTEND=noninteractive

ARG DEV_USER=ageekinside
USER ${DEV_USER}
RUN curl -k --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#RUN wget --no-check-certificate -O - https://static.rust-lang.org/rustup.sh | rustup.sh
ENV PATH=/home/${DEV_USER}/.cargo/bin:$PATH

RUN rustup update \
    && rustup component add rls rust-analysis rust-src

USER root
RUN echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

RUN apt-get update \
    && apt-get -y install libpython2.7 libxml2

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.37.0

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        wget \
        ; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='a46fe67199b7bcbbde2dcbc23ae08db6f29883e260e23899a88b9073effc9076' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='6af5abbbae02e13a9acae29593ec58116ab0e3eb893fa0381991e8b0934caea1' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='51862e576f064d859546cca5f3d32297092a850861e567327422e65b60877a1b' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='91456c3e6b2a3067914b3327f07bc182e2a27c44bff473263ba81174884182be' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.18.3/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    rm -rf /var/lib/apt/lists/*;


USER ${DEV_USER}

RUN rustup install nightly \
    && rustup default nightly \
    && cargo install clippy rustfmt rustsym \
    && rustup component add rls-preview --toolchain nightly \
    && rustup component add rust-analysis --toolchain nightly \
    && rustup component add rust-src --toolchain nightly

USER ${DEV_USER}

