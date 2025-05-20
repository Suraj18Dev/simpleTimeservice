FROM python:3.13-slim

# Create non-root user
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Copy files
COPY main.py /app/

# Install dependencies
RUN pip install flask

# Change to non-root user
USER appuser

# Expose port and run the app
EXPOSE 8080
CMD ["python", "main.py"]