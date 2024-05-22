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
RUN npm run build

# Production stage
FROM nginx:alpine AS production

# Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 to the Docker host, so we can access it
# from the outside.
EXPOSE 80

# The command to run when the container is started.
CMD ["nginx", "-g", "daemon off;"]
