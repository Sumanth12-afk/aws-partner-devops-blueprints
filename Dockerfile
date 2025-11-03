###############################################
# Builder stage: compile tiny Go HTTP server  #
###############################################
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Build cache optimization: initialize module layer first
RUN printf "module demo\n\ngo 1.22\n" > go.mod && \
    touch go.sum && \
    go mod download

# Create a tiny static file server on the fly to avoid adding app code
RUN cat > main.go <<'EOF'
package main

import (
    "log"
    "net/http"
    "os"
    "net"
)

func main() {
    // If invoked as a healthcheck, perform a local TCP probe and exit.
    if len(os.Args) > 1 && os.Args[1] == "healthcheck" {
        conn, err := net.Dial("tcp", "127.0.0.1:8080")
        if err != nil { os.Exit(1) }
        _ = conn.Close()
        os.Exit(0)
    }
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }
    // Serve static content from /app/site
    fs := http.FileServer(http.Dir("site"))
    http.Handle("/", fs)
    http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request){ w.WriteHeader(http.StatusOK) })
    log.Printf("listening on :%s", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        log.Fatal(err)
    }
}
EOF

# Prepare demo site content from README
RUN mkdir -p site && \
    echo "<meta charset=\"utf-8\"><pre>" > site/index.html && \
    sed 's/&/&amp;/g;s/</&lt;/g' /dev/stdin >> site/index.html <<'DOC' && \
    echo "</pre>" >> site/index.html
This container serves the repository README as a demo site.
DOC

# Build static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server .

###############################################
# Runtime stage: distroless, non-root image   #
###############################################
FROM gcr.io/distroless/static-debian12:nonroot

ARG SITE_DIR=site

COPY --from=builder /app/server /server
COPY --from=builder /app/${SITE_DIR} /site

EXPOSE 8080

USER nonroot
ENTRYPOINT ["/server"]

# Healthcheck using the same binary (no shell/curl in distroless)
HEALTHCHECK CMD ["/server", "healthcheck"]

# OCI metadata labels
LABEL org.opencontainers.image.title="AWS Partner DevOps Demo Server" \
      org.opencontainers.image.description="A minimal static Go HTTP server for Terraform & CI/CD showcase" \
      org.opencontainers.image.source="https://github.com/Sumanth12-afk/terraform-aws-startup-infrastructure" \
      org.opencontainers.image.licenses="MIT" \
      maintainer="sumanthnallandhigal@gmail.com"


