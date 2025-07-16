# Use Python 3.12 slim image for smaller size
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for some Python packages
RUN apt-get update && apt-get install -y \
    gcc \
    libmagic1 \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    calibre \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements files
COPY requirements.txt optional-requirements.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt -r optional-requirements.txt

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
