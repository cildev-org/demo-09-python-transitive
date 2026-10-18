# syntax=docker/dockerfile:1
FROM python:3.11-slim@sha256:e88e9763f943ec1834f992a4b51e0f24500486803e8bc534e5767af9ea65f6ce
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY server.py .
COPY static/ static/
# A file two directories above the static root (/app/static -> / -> /srv),
# standing in for what a real app keeps outside its web root.
RUN mkdir -p /srv && echo "BO-LAB-MARKER-cve-2024-23334" > /srv/marker.txt
USER 65534:65534
EXPOSE 8080
CMD ["python", "server.py"]
