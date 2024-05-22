# Build stage
FROM node:16-slim AS build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install the app dependencies
# You can use --production flag if you don't install devDependencies
RUN npm ci

# Bundle the app source inside the Docker image
COPY . .

# Run the build scripts defined in your package.json
RUN npm run build

# Production stage for a hypothetical Node.js server that serves the production-built resources
# If you're just building the Electron app and not serving it with Node.js, 
# you can skip this stage and directly export your build artifacts in the previous stage
FROM node:16-slim AS production

WORKDIR /app

# Copy built node modules and compiled code from the build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

# Copy any other resources that your app needs at runtime
# COPY --from=build /app/public ./public
# COPY --from=build /app/src ./src
# etc.

# Your start command or runtime command here
CMD ["node", "./dist/server.js"]

# Note that CMD should not be 'npm run dev' in production
# but rather the command to start your Electron app or associated server
