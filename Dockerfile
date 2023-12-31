FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup -y
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
