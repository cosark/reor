FROM ghcr.io/electron/build:latest

COPY . .
RUN npm install && npm run build

EXPOSE 3000
CMD ["npm", "run", "dev"]
