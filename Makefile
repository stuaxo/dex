NAME = dex
PREFIX = /usr/local
DOCPREFIX = $(PREFIX)/share/doc/$(NAME)
MANPREFIX = $(PREFIX)/man
VERSION = $(shell git tag | tail -n 1)
TAG = dex-$(VERSION)

build: man/dex.1

man/dex.1: man/dex.rst
	@echo building the manpage in man/
	@sphinx-build -b man -D version=$(TAG) -E man man

install: dex man/dex.1 README.rst LICENSE
	@echo installing executable file to $(DESTDIR)$(PREFIX)/bin
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@install -m 0755 $< $(DESTDIR)$(PREFIX)/bin/
	@echo installing docs to $(DESTDIR)$(DOCPREFIX)
	@mkdir -p $(DESTDIR)$(DOCPREFIX)
	@install -m 0644 -t $(DESTDIR)$(DOCPREFIX)/ README.rst LICENSE
	@echo installing manual page to $(DESTDIR)$(MANPREFIX)/man1
	@mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	@install -m 0644 -t $(DESTDIR)$(MANPREFIX)/man1 man/dex.1

tgz: source

source: dex man/dex.1 README.rst LICENSE Makefile CHANGELOG.md
	@echo "Creating source package: $(TAG).tar.gz"
	@mkdir $(TAG)
	@cp -t $(TAG) $+
	@tar czf $(TAG).tar.gz $(TAG)
	@rm -rf $(TAG)

clean:
	@rm -f $(TAG).tar.gz
	@rm -f man/dex.1

.PHONY: build install tgz source clean
