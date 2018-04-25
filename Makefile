# Development targets

IMAGE := bopen/ubuntu-pyenv
DOCKERBUILDFLAGS := --pull

REQUIREMENTS_TXT := requirements-setup.txt requirements-test.txt requirements-ci.txt

%.txt: %.in
	pip-compile $(PIPCOMPILEFLAGS) -o $@ $^

requirements-setup.txt: PIPCOMPILEFLAGS += --allow-unsafe

image: $(REQUIREMENTS_TXT)
	docker build -t $(IMAGE) $(DOCKERBUILDFLAGS) .

shell:
	docker run --rm -ti -v$$(pwd):/src -w/src $(DOCKERFLAGS) $(IMAGE)

clean:
	$(RM) $(REQUIREMENTS_TXT)
