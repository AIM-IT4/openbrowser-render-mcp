FROM python:3.12-bookworm

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    OPENBROWSER_BROKER_HOST=0.0.0.0 \
    OPENBROWSER_BROKER_PORT=10000 \
    OPENBROWSER_BROKER_ROOT=/data/openbrowser-broker \
    OPENBROWSER_BROWSER_POOL_DIR=/data/openbrowser-pool

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/openbrowser
RUN git clone --depth=1 https://github.com/floomhq/openbrowser.git . \
    && pip install -e . \
    && playwright install --with-deps chromium

COPY start_openbrowser.sh /usr/local/bin/start-openbrowser
RUN chmod +x /usr/local/bin/start-openbrowser \
    && mkdir -p /data/openbrowser-broker /data/openbrowser-pool /data/openbrowser-authenticated

EXPOSE 10000
CMD ["/usr/local/bin/start-openbrowser"]
