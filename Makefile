.PHONY: build docker/login push

REGION=ap-southeast-1
REGISTRY:=277152405283.dkr.ecr.ap-southeast-1.amazonaws.com
IMAGE:=mgmt/liquibase
LIQUIBASE_TAG:=0.1.0
LIQUIBASE_VERSION:=3.8.1
TAG:=$(LIQUIBASE_TAG)-$(LIQUIBASE_VERSION)

build: Dockerfile
	docker build \
		--build-arg LIQUIBASE_VERSION=$(LIQUIBASE_VERSION) \
		-t $(IMAGE):$(TAG) .

docker/login:
	$$(aws ecr get-login --no-include-email --region $(REGION))

push: docker/login
	docker tag $(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):$(TAG)
	docker push $(REGISTRY)/$(IMAGE):$(TAG)