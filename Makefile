SITE_DIR = $(HOME)/Repos/site/sgm/tohf

.PHONY: build site

SOURCES := $(wildcard src/*.coffee)

build: $(SOURCES)
	coffee -co lib/ src/
	@echo "coffee sources were compiled"

FILES = index.html lib README.md

site: build $(FILES)
	rsync -r $(FILES) $(SITE_DIR)
	@echo "files copied to $(SITE_DIR)"
	cd $(SITE_DIR); git commit -am 'make leap viewer'; git push origin master
