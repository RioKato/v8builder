all: builder cacher

builder/config.json: cacher/config.json
	cp $< $@

.PHONY: builder
builder: builder/config.json
	cd builder && docker build -t v8builder:builder .

.PHONY: cacher
cacher:
	cd cacher && docker build -t v8builder:cacher .

.PHONY: clean
clean:
	docker rmi v8builder:cacher
	docker rmi v8builder:builder
	rm builder/config.json
