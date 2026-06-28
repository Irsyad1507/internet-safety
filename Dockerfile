FROM python:3.14-slim

WORKDIR /app

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.9.16 /uv /uvx /bin/

# Copy project files
COPY pyproject.toml pyproject.toml
COPY uv.lock uv.lock
COPY .python-version .python-version

# Install dependencies using uv with lock file for reproducible builds
RUN uv sync --frozen

# Copy application code
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    FLASK_APP=run.py \
    FLASK_ENV=production \
    FLASK_DEBUG=0

# Create non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port (Render uses dynamic ports, but Flask defaults to 5000)
EXPOSE 5000

# Run with gunicorn for production
CMD ["uv", "run", "gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--worker-class", "sync", "--timeout", "60", "--access-logfile", "-", "--error-logfile", "-", "run:app"]