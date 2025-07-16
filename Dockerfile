# Use Python 3.12 slim image for smaller size
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for some Python packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libldap2-dev \
    libsasl2-dev \
    python3-dev \
    imagemagick \
    ghostscript \
    libsasl2-2 \
    libxi6 \
    libxslt1.1 \
    python3-venv \
    sqlite3 \
    xdg-utils \
    calibre \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements files
COPY requirements.txt optional-requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt -r optional-requirements.txt

# Clean up unnecessary packages to reduce image size
RUN   echo "**** cleanup ****" && \
  apt-get -y purge \
    build-essential \
    libldap2-dev \
    libsasl2-dev \
    python3-dev && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

# Copy application code
COPY . .

# Create directories for data
RUN mkdir -p /app/config /app/books

# Expose the default port
EXPOSE 8083

# Set environment variables
ENV PYTHONPATH=/app

# Run the application
CMD ["python", "cps.py"]
