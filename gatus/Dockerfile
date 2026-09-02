# Build the go application into a binary
FROM golang:alpine AS builder
RUN apk --update add ca-certificates
WORKDIR /app
# Builder stage

# Pull golang and alpine base image using image digests
FROM golang:alpine3.24 AS builder

# Creating working space.
WORKDIR /app

# Copy dependencies to the container first to optimise Docker layer cache.
COPY go.mod go.sum ./

# Download dependencies.
RUN go mod download

# Copy application to app.
COPY . .

# Build the application as a standalone static Go binary and save it as app-gatus.
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o app-gatus .

# Runtime stage
FROM gcr.io/distroless/static-debian13:nonroot

COPY --from=builder /app/app-gatus /app-gatus
COPY --from=builder /app/config.yaml /config/config.yaml

ENV GATUS_CONFIG_PATH=/config/config.yaml

EXPOSE 8080

ENTRYPOINT ["/app-gatus"]





