FROM python:3.11.9 AS builder

ENV PYTHONBUFFERED=1
ENV PATH="/root/.local/bin:$PATH"

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

WORKDIR /app
COPY uv.lock pyproject.toml /app/

RUN uv sync

FROM python:3.11.9-slim

ENV PYTHONBUFFERED=1
ENV PATH="/root/.local/bin:$PATH"
ENV PYTHONPATH="/app/.venv/lib/python3.11/site-packages:${PYTHONPATH}"
ENV VIRTUAL_ENV="/app/.venv"

WORKDIR /app
COPY --from=builder /app /app
COPY ./app /app

EXPOSE 8000

ENTRYPOINT ["python", "-m", "main"]