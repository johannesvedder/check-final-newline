FROM alpine/git:latest
COPY lint.sh /lint.sh
ENTRYPOINT ["/lint.sh"]
