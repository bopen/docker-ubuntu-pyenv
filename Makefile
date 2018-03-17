
IMAGE := bopen/ubuntu-pyenv

%.txt: %.in
	pip-compile $(PIPCOMPILEFLAGS) -o $@ $^

requirements-setup.txt: PIPCOMPILEFLAGS += --allow-unsafe

image: requirements-setup.txt requirements-pytest.txt requirements-tox.txt
	docker build -t $(IMAGE) $(DOCKERBUILDFLAGS) .
