all:
	echo OK

start-original:
	docker run -d --rm \
		-p 9115:9115 \
	  --name blackbox_exporter \
	  -v $$(pwd):/config \
	  quay.io/prometheus/blackbox-exporter:latest --config.file=/config/blackbox.yml

start:
	docker run -d --rm -p 9115:9115 --name blackbox_exporter \
		elicro/blackbox-exporter:latest --config.file=/config/blackbox.yml

stop:
	docker stop blackbox_exporter
build-test:
	docker build -t elicro/blackbox-exporter:latest .
build:
	bash download-latest.sh
	bash publish.sh

init-buildx: clean-buildx
	docker buildx create --name mybuilder
	docker buildx use mybuilder
	docker buildx inspect --bootstrap
	docker buildx ls
clean-buildx:
	docker buildx rm mybuilder;true
