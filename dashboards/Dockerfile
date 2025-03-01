ARG ALPINE_VERSION=3.21.3

FROM alpine:${ALPINE_VERSION} AS builder

# Install Go and git (required for go install)
RUN apk add --no-cache go git

# Install jsonnet-bundler using go install
ARG JSONNET_BUNDLER_VERSION=v0.6.0
RUN go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@${JSONNET_BUNDLER_VERSION}

# Install jsonnet
ARG JSONNET_VERSION=v0.20.0
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@${JSONNET_VERSION}

# Final stage
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache watchexec jq curl

# Copy only the jsonnet-bundler binary from builder
COPY --from=builder /root/go/bin/jb /usr/local/bin/jb
COPY --from=builder /root/go/bin/jsonnet /usr/local/bin/jsonnet

WORKDIR /src

ADD entrypoint.sh .
RUN chmod +x entrypoint.sh

ADD run.sh .
RUN chmod +x run.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["build"]