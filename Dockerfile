# Dockerfile for building Flutter Web
FROM cirrusci/flutter:stable AS builder

WORKDIR /app

# Copy pubspec files
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code
COPY . .

# Build web
RUN flutter build web --release

# Use nginx to serve the built files
FROM nginx:alpine

# Copy built files from builder
COPY --from=builder /app/build/web /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

