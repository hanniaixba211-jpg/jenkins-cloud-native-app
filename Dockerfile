FROM jenkins/jenkins:lts

USER root

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Instalar Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.15.8/terraform_1.15.8_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

USER jenkins