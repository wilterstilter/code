FROM ghcr.io/actions/actions-runner:2.331.0

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install base packages for GC SDK and PWSH (.NET core), and, then, install GC SDK and PWSH
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    openjdk-17-jdk-headless \
    software-properties-common \
    wget \
    && . /etc/os-release \
    && wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get update && apt-get install -y --no-install-recommends \
    google-cloud-cli \
    powershell \
    && rm packages-microsoft-prod.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Validate Google Cloud SDK Version
RUN gcloud_version=$(gcloud version --format='value(Google Cloud SDK)' 2>/dev/null | cut -d'.' -f1) && \
    if [ "$gcloud_version" -lt 416 ]; then \
        echo "ERROR: gcloud version must be >= 416.0.0, found $gcloud_version" && exit 1; \
    fi

# Install Go 1.19.5 for Bazel rules_go
ENV GO_VERSION=1.19.5
RUN wget -q https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go
ENV PATH="${GOROOT}/bin:${PATH}"

USER runner

# Verify installations
RUN git --version \
    && jq --version \
    && curl --version \
    && java --version \
    && gcloud --version \
    && go version \
    && pwsh -NoProfile -Command '$PSVersionTable'

WORKDIR /home/runner

CMD ["/home/runner/run.sh"]