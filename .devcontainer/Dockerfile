# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.0
FROM ghcr.io/rails/devcontainer/images/ruby:$RUBY_VERSION

# Switch to root user to allow package installation
USER root

# Install Selenium and Chrome dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg2 \
    libnss3 \
    libgconf-2-4 \
    chromium \
    chromium-driver \
    xvfb \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Return to the default user (if applicable)
USER vscode

# Set ChromeDriver path
ENV PATH="/usr/lib/chromium:/usr/lib/chromium/chromedriver:$PATH"