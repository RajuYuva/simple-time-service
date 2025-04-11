# Use a small base image
FROM node:23-alpine

# Create a non-root user and set permissions
RUN addgroup app && adduser -S -G app app
USER app

# Set working directory
WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Copy application files
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]

