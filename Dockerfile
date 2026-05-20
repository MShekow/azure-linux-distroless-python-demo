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
FROM ghcr.io/mshekow/python-azure-linux:3.12@sha256:aae2c16fbc7ff13b9aa02792c6311554c0fd03115d08eeef0b4d4101c2e31136 AS final
ARG VIRTUAL_ENV
WORKDIR /app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
COPY --from=builder /app /app
USER nonroot
ENTRYPOINT ["gunicorn", "--config", "gunicorn.conf.py", "app:app"]
