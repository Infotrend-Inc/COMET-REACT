# Use an official Node.js image for testing and building
FROM node:16-alpine AS build

WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Run tests before proceeding
RUN npm test

# Build the application
RUN npm run build

# Use an official Nginx image to serve the React app
FROM nginx:alpine

# Copy the built React app to the nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]
