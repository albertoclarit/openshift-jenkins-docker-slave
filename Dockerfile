FROM openshift/jenkins-slave-maven-centos7

USER root

# Install docker
RUN yum install -y yum-utils device-mapper-persistent-data lvm2 && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    usermod -aG docker $(whoami)

# Install docker-compose (and upgrade Python)
RUN yum install -y epel-release && \
    yum install -y python-pip && \
    pip install docker-compose && \
    yum upgrade python*

# https://docs.docker.com/install/linux/linux-postinstall/
RUN systemctl enable docker

#VOLUME /var/lib/docker
#VOLUME /var/run/docker.sock


ENV GRADLE_VERSION=4.6 \
    GRADLE_HOME=/opt/gradle

ARG GRADLE_DOWNLOAD_SHA256=98bd5fd2b30e070517e03c51cbb32beee3e2ee1a84003a5a5d748996d4b1b915
RUN set -o errexit -o nounset \
    && INSTALL_PKGS="java-1.8.0-openjdk-devel.x86_64 java-1.8.0-openjdk-devel.i686" \
    && yum install -y --enablerepo=centosplus $INSTALL_PKGS \
	&& echo "Downloading Gradle" \
	&& wget -O gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
	\
	&& echo "Checking download hash" \
	&& echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum -c - \
	\
	&& echo "Installing Gradle" \
	&& unzip gradle.zip \
	&& rm gradle.zip \
	&& mkdir -p /opt \
	&& mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    && mkdir -p $HOME/.gradle \
    && rpm -V $INSTALL_PKGS \
    && yum clean all -y

ADD contrib/gradle/* $HOME/.gradle/


RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

# Back to the user in the FROM image...
USER 1001
