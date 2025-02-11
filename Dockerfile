FROM alpine:latest

ARG BUILDPLATFORM
ARG TARGETPLATFORM

RUN apk update && apk add --no-cache supervisor ca-certificates && \
	mkdir /config -p


ADD build-dir/${TARGETPLATFORM}/blackbox_exporter /bin/blackbox_exporter

COPY config.yaml /config/blackbox.yml

EXPOSE 9115

ENTRYPOINT ["/bin/blackbox_exporter"]

