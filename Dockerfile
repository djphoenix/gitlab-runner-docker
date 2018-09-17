FROM debian:9-slim

RUN apt-get update ; \
    apt-get install -y apt-transport-https wget gnupg ca-certificates ; \
    { echo deb https://packagecloud.io/github/git-lfs/debian/ stretch main ; \
      echo deb-src https://packagecloud.io/github/git-lfs/debian/ stretch main ; \
    } > /etc/apt/sources.list.d/github_git-lfs.list ; \
    { echo deb https://packages.gitlab.com/runner/gitlab-runner/debian/ stretch main ; \
      echo deb-src https://packages.gitlab.com/runner/gitlab-runner/debian/ stretch main ; \
    } > /etc/apt/sources.list.d/runner_gitlab-runner.list ; \
    { echo Package: gitlab-runner ; \
      echo Pin: origin packages.gitlab.com ; \
      echo Pin-Priority: 1001 ; \
    } > /etc/apt/preferences.d/pin-gitlab-runner.pref ; \
    wget -q -O- 'https://packages.gitlab.com/runner/gitlab-runner/gpgkey' | apt-key add - ; \
    wget -q -O- 'https://packagecloud.io/github/git-lfs/gpgkey' | apt-key add - ; \
    apt-get update ; \
    apt-get install -y gitlab-runner git-lfs ; \
    git lfs install --system ; \
    rm -rf /var/apt/cache ; \
    echo 'gitlab-runner register --non-interactive --executor shell && gitlab-runner run' > /var/startup.sh ; \
    chmod 755 /var/startup.sh

ENTRYPOINT /var/startup.sh
