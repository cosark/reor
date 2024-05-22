# Build stage
FROM node:18-slim AS build

# Set the working directory
WORKDIR /app

# Install system dependencies required for Node native addons
RUN apt-get update \
    && apt-get install -y python3 make g++ \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js dependencies
COPY package*.json ./
RUN npm install --force

# Bundle app source
COPY . .
RUN npm run dev
EXPOSE 3000
