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
FROM ghcr.io/mshekow/python-azure-linux:3.12@sha256:856402fc549e174ad1d58a76f7aca69e75d2daef444ab5babd6f449aa30a6926 AS final
ARG VIRTUAL_ENV
WORKDIR /app
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONUNBUFFERED=1
EXPOSE 8000
COPY --from=builder /app /app
USER nonroot
ENTRYPOINT ["gunicorn", "--config", "gunicorn.conf.py", "app:app"]
