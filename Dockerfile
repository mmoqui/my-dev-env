FROM ubuntu:latest

MAINTAINER Miguel Moquillon "miguel.moquillon@gmail.com"
LABEL name="My Development Environment" description="Dev env to work on my my-app-view project"

ARG DEFAULT_LOCALE=fr_FR.UTF-8
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG NODEJS_VERSION=20

ENV TERM=xterm
ENV TZ=Europe/Paris
ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked apt-get update \
	&& apt-get install -y tzdata \
	&& apt-get install -y --no-install-recommends \
        software-properties-common \
        locales \
        curl \
        wget \
        vim \
    	  psmisc \
		    iputils-ping \
    	  procps \
    	  net-tools \
        htop \
        git \
        openssh-client \
        gnupg \
    	  zip \
    	  unzip \
        bzip2 \
        openssl \
    	  ca-certificates \
        bash-completion \
        language-pack-en \
        language-pack-fr

RUN set -e; \
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor \
        | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg; \
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
        | tee /etc/apt/sources.list.d/vscodium.list; \
    curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash -;

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked apt-get update \
    && apt-get install -y nodejs codium \
    && rm -rf /var/lib/apt/lists/*

RUN set -e; \
    update-ca-certificates -f; \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen; \
    locale-gen; \
    update-locale LANG=${DEFAULT_LOCALE} LANGUAGE=${DEFAULT_LOCALE} LC_ALL=${DEFAULT_LOCALE}; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    groupadd -g ${GROUP_ID} mygroup; \
    useradd -u ${USER_ID} -g ${GROUP_ID} -G users \
        -d /home/myuser -s /bin/bash -m myuser;
    

ENV LANG ${DEFAULT_LOCALE}
ENV LANGUAGE ${DEFAULT_LOCALE}
ENV LC_ALL ${DEFAULT_LOCALE}

COPY src/inputrc /root/.inputrc
COPY --chown=${USER_ID}:${GROUP_ID} src/inputrc /home/myuser/.inputrc
COPY --chown=${USER_ID}:${GROUP_ID} src/bash_aliases /home/myuser/.bash_aliases
COPY --chown=${USER_ID}:${GROUP_ID}  src/git_completion_profile /home/myuser/.git_completion_profile

USER myuser:mygroup
WORKDIR /home/myuser

RUN set -e; \
    git clone https://github.com/mmoqui/my-app-view.git; \
    mkdir my-app-view/dist; \
    cd my-app-view; \
    npm install;

VOLUME ["/home/myuser/.ssh", "/home/myuser/.gnupg", "/home/myuser/my-app-view/dist"]

