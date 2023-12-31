FROM ghcr.io/qmk/qmk_cli:latest
RUN qmk setup -y -H /opt/qmk_firmware
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
