image=cerit.io/ljocha/notebook-gmx
tag=13

push: build
	docker push ${image}:${tag}

build:
	docker build -t ${image}:${tag} .

bash:
	docker run --rm -v ${PWD}:/work -w /work -u $(shell id -u) -ti ${image}:${tag} bash

root:
	docker run --rm -v ${PWD}:/work -w /work -u 0 -ti ${image}:${tag} bash

jovyan:
	docker run --rm -v ${PWD}:/work -ti ${image}:${tag} bash
