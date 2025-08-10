FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y poppler-utils tesseract-ocr && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# Expose port
EXPOSE 8080

# Start the app
CMD ["python", "app.py"]
