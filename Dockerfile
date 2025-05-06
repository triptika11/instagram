# Stage 1: Build React App
FROM node:20.17.0-alpine AS build

WORKDIR /app

# Set fix for OpenSSL compatibility (for older React tooling)
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy dependency files and install dependencies
COPY package.json package-lock.json ./
RUN npm install -g npm@10.8.2 && npm install

# Copy the rest of the source code and build
COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:stable-alpine AS production

# Copy built React files to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx configuration for React Router support
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
