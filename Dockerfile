ARG VIRTUAL_ENV=/app/.venv
FROM mcr.microsoft.com/azurelinux/base/python:3 AS builder
ARG VIRTUAL_ENV
WORKDIR /app

RUN python3 -m venv $VIRTUAL_ENV
COPY requirements.txt .
RUN $VIRTUAL_ENV/bin/pip install --no-cache-dir -r requirements.txt

COPY . .

# Whenever a new build of the ghcr.io/mshekow/python-azure-linux:3.12 image is available, a tool like Renovate Bot
# can update the sha256 digest
FROM ghcr.io/mshekow/python-azure-linux:3.12@sha256:a99ef6b3cccd951744ae0759fc374363dd448a25b3fece15f1e5347d5baf1694 AS final
ARG VIRTUAL_ENV
WORKDIR /app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
COPY --from=builder /app /app
USER nonroot
ENTRYPOINT ["gunicorn", "--config", "gunicorn.conf.py", "app:app"]
