# Use an official node image to build the React app
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage for running tests
FROM node:16-alpine AS test

WORKDIR /app

COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./
COPY --from=build /app/public ./
COPY --from=build /app/src ./src

# Use an official nginx image to serve the React app
FROM nginx:alpine

# Copy the built React app to the nginx html folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose the port the app runs on
EXPOSE 80

# Start the nginx server
CMD ["nginx", "-g", "daemon off;"]