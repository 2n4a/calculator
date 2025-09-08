# Multi-stage build for Flutter web app served by Nginx (optimized & pinned)
# ---------------------------------------------------------------------------
# Build Stage
ARG FLUTTER_VERSION=3.35.3
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS build

# Build arguments (override at build time)
ARG BACKEND_URL=http://127.0.0.1:8000
ARG BUILD_NUMBER=0

# Expose at build for dart-define; also write into ENV if any scripts read it
ENV BACKEND_URL=${BACKEND_URL}
WORKDIR /app

# Enable web & precache to avoid network during build steps later
RUN flutter config --enable-web \
 && flutter precache --web \
 && flutter --version

# Copy only dependency resolution inputs first (dependency layer caching)
COPY pubspec.yaml pubspec.lock ./
# Path dependency (openapi) minimal subset
COPY openapi/pubspec.yaml openapi/pubspec.yaml
COPY openapi/lib openapi/lib

# Resolve dependencies
RUN flutter pub get

# Now copy the remainder of the source tree
COPY . .

# Re-run pub get in case additional local packages / assets appeared
RUN flutter pub get

# Optional: fail fast on analysis issues (can be commented out to speed builds)
# RUN flutter analyze --no-fatal-infos --no-fatal-warnings

# Build release web bundle with dart defines
RUN echo "Building Flutter web with BACKEND_URL=${BACKEND_URL}" && \
    flutter build web \
      --release \
      --dart-define=BACKEND_URL=${BACKEND_URL} \
      --dart-define=BUILD_NUMBER=${BUILD_NUMBER}

# Runtime Stage ----------------------------------------------------------------
ARG FLUTTER_VERSION=3.35.3
FROM nginx:1.27-alpine AS runtime
ARG FLUTTER_VERSION

LABEL org.opencontainers.image.title="calculator-frontend" \
      org.opencontainers.image.description="Flutter web build served via Nginx" \
      org.opencontainers.image.source="https://github.com/2n4a/calculator" \
      org.opencontainers.image.version="${FLUTTER_VERSION}" \
      org.opencontainers.image.licenses="MIT"

# Remove default site
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy external nginx config (moved from heredoc)
COPY nginx.conf /etc/nginx/conf.d/flutter.conf

# Copy compiled artifacts
COPY --from=build /app/build/web /usr/share/nginx/html

# Optional: run as non-root (uncomment if infra permits)
# RUN adduser -D app && chown -R app:app /usr/share/nginx/html /var/cache/nginx /var/run
# USER app

EXPOSE 80

# Simple container healthcheck (adjust interval/timeouts as desired)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -q -O - http://127.0.0.1/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]

# Usage ------------------------------------------------------------------------
# Build (default backend URL):
#   docker build -t calculator-web:latest frontend/
# Custom backend URL & build number:
#   docker build --build-arg BACKEND_URL=https://api.example.com --build-arg BUILD_NUMBER=42 -t calculator-web:prod frontend/
# Run:
#   docker run -p 8080:80 calculator-web:latest
# Visit: http://localhost:8080
