FROM python:3.14-slim

# Copy the uv binary from the official Astral image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Environment settings
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

# Step 1: Install dependencies first (leveraging Docker layer caching)
COPY pyproject.toml uv.lock ./

# Sync dependencies without installing the project itself yet
RUN uv sync --frozen --no-dev --no-install-project

# Step 2: Copy the rest of the application code
COPY . .

# Step 3: Finalize the sync (installs the project if configured as a package)
RUN uv sync --frozen --no-dev

EXPOSE 8000

# Run gunicorn directly from the virtual environment created by uv
CMD ["/app/.venv/bin/gunicorn", "--bind", "0.0.0.0:8000", "edenthought.wsgi:application", "--workers=3"]