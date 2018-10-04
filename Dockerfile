# To download the MySQL Community Server Image
FROM mysql/mysql-server:latest

# Set the working directory to /app
WORKDIR /app

# Copy the current directory content into the container at /app
COPY . /app