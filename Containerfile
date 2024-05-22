# Build stage
FROM node:18-slim AS build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install Python, build-essential, and other required system packages
RUN apt-get update \
    && apt-get install -y python3 python3-pip python3-setuptools build-essential \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js dependencies (with force to avoid halt on peer dependencies)
RUN npm install --force

# Bundle the app source inside the Docker image
COPY . .

# Run the build scripts defined in your package.json
RUN npm run build

# Depending on your production needs, set up the production environment
# For a Node.js back-end server (if applicable):
FROM node:18-slim AS production

# Set the working directory
WORKDIR /app

# Copy built artifacts from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

# Your start command or runtime command here
# When using Electron, this may not be necessary as you'd be packaging the 
# Electron app instead of running a server.
CMD ["node", "./dist/server.js"]

# If you're not running a server and you just need to package the Electron app,
# you don't need the production stage. Instead, you'd create the package in the
# build stage and then copy it out of Docker to your host machine.
