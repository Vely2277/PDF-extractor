# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Install system dependencies for OCR and PDF processing
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        tesseract-ocr \
        poppler-utils \
        gcc \
        libgl1 \
        libglib2.0-0 \
        && rm -rf /var/lib/apt/lists/*

# (Optional) Show Tesseract version in build logs for debugging
RUN tesseract --version

# Set work directory
WORKDIR /opt/render/project/src

# Copy requirements first for better Docker caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of your app code
COPY . .

# Expose the port your Flask app runs on
EXPOSE 5000

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_ENV=production

# Run the Flask app
CMD ["flask", "run"]
