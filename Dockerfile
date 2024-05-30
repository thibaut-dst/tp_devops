# Use the official PostgreSQL image from the Docker Hub
FROM postgres:14.1-alpine

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=db \
   POSTGRES_USER=usr \
   POSTGRES_PASSWORD=pwd

# Copy initialization scripts to the Docker entry point directory
COPY ./SQLscript/* /docker-entrypoint-initdb.d/