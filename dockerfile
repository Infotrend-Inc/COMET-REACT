# Use an official node image for testing
FROM node:16-alpine AS test

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .

# Run tests inside the container
RUN npm test


# Use an official node image for building the React app
FROM node:16-alpine AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Use an official nginx image to serve the React app
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
