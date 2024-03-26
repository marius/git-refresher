# Git Repository refresher

## Setup

Generate a key and add the public key to your repository as a deploy key with write permission:

`ssh-keygen -t ed25519 -f id_ed25519 -C "Git Repository Refresher deploy key"`

Run the container (make sure to use the SSH URL for your repository (e.g. `git@github.com:YOUR_REPO.git`)):

`docker run -it --rm --name git-refresher -e GIT_REPOSITORY=YOUR_REPO git-refresher`

or use `docker-compose`:

```
version: '3'

secrets:
  postfix-sendgrid_deploy_key:
    file: /tank/docker/secrets/postfix-sendgrid-deploy-key

services:
  git-refresher:
    image: git-refresher
    environment:
      - GIT_REPOSITORY=YOUR_REPO
    secrets:
      - postfix-sendgrid_deploy_key
```

