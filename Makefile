.PHONY: test
deps:
	pip install -r requirements.txt
	pip install -r test_requirements.txt
lint:
	flake8 hello_word test
run:
	python main.py

test_cov:
	PYTHONPATH=. py.test --verbose -s --cov=.
test_xunit:
	PYTHONPATH=. py.test -s --cov=. --junit-xml=test_results.xml
test:
	PYTHONPATH=. py.test
	PYTHONPATH=. py.test  --verbose -s
	
docker_build:
	docker build -t hello-world-printer .

docker_run: docker_build
	docker run \
	--name hello-world-printer-dev \
	-p 5000:5000 \
	-d hello-world-printer

USERNAME=masteratom
TAG=$(USERNAME)/hello-world-printer

docker_push: docker_build
	@docker login --username $(USERNAME) --password $${DOCKER_PASSWORD}; \
	docker tag hello-world-printer $(TAG); \
	docker tag hello-world-printer:$$(cat VERSION); \
	docker push $(TAG); \
	docker push hello-world-printer:$$(cat VERSION); \
	docker logout;
