## Start from the official Jenkins LTS image
#FROM jenkins/jenkins:lts
#
## Switch to root to install tools
#USER root
#
## Install Docker CLI, Docker Compose, kubectl, and required dependencies
#RUN apt-get update && \
#    apt-get install -y \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg \
#    lsb-release \
#    software-properties-common \
#    sudo && \
#    # Install Docker CLI and Docker Compose
#    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
#    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#    apt-get update && \
#    apt-get install -y docker-ce-cli docker-compose-plugin && \
#    # Install kubectl for Kubernetes deployment
#    curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
#    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
#    rm kubectl && \
#    # Clean up unnecessary files to reduce image size
#    rm -rf /var/lib/apt/lists/* && \
#    apt-get clean
#
## Add Jenkins user to Docker group
#RUN usermod -aG docker jenkins
#
## Switch back to Jenkins user
#USER jenkins
#
## Optional: Pre-install Jenkins plugins (uncomment and modify if needed)
## COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
## RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
#
## Expose Jenkins web UI and agent ports
#EXPOSE 8080
#EXPOSE 50000
#
## Set the default command (optional, in case you want to ensure specific behavior)
#CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
#-----------------------------------------------------

FROM jenkins/jenkins:lts
# Install Docker, AWS CLI, and kubectl
USER root
RUN apt-get update && \
    apt-get install -y \
    docker.io \
    awscli \
    kubectl \
    curl \
    vim \
    git && \
    apt-get clean

USER jenkins
