FROM alpine
LABEL "repository"="https://github.com/hole19/git-tag-action"
LABEL "homepage"="https://github.com/hole19/git-tag-action"
LABEL "maintainer"="Hole19"

COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk add bash git curl jq

ENTRYPOINT ["/entrypoint.sh"]
