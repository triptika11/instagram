# Stage 1: Build React 
FROM node:18-alpine as build

WORKDIR /app

# Set the fix for OpenSSL issue
ENV NODE_OPTIONS=--openssl-legacy-provider

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install -g npm@11.3.0

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:stable-alpine as production

# Copy built React files to nginx html directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config (optional)
# COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
