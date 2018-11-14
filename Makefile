# Simplify daily operations

EMACS=emacs
BATCH=$(EMACS) --batch -Q
EDIR=~/.emacs.d
EMAX=$(BATCH) -l $(EDIR)/init.el
ELPA=$(BATCH) -l $(EDIR)/esk/elpa.el$(if $(wildcard $(EDIR)/$(USER)/elpa.el), -l $(EDIR)/$(USER)/elpa.el,)
UPLD=$(BATCH) -l $(EDIR)/esk/update-loaddefs.el
ESKDIR=esk
ESKELS=$(wildcard $(ESKDIR)/*.el)
ETSDIR=elpa-to-submit
ETSAL=$(ETSDIR)/loaddefs.el
ETSELS=$(filter-out $(ETSAL),$(wildcard $(ETSDIR)/*.el))
USERELS=$(wildcard $(EDIR)/$(USER)/*.el) $(wildcard $(EDIR)/$(USER)/gnus/.gnus.el)
ALLELS=$(ESKELS) $(ETSELS) $(USERELS) $(wildcard *.el) $(wildcard overrides/*.el)
ESKLOG=/tmp/$(USER)-emacs-starter-kit.log
BCTIMESTAMP=.byte-compile-timestamp

.PHONY: all
all: update-elpa $(ETSAL) compile

.PHONY: clean
clean:
	rm -f $(ALLELS:.el=.elc) $(BCTIMESTAMP)

.PHONY: distclean
distclean: clean
	rm -rf elpa/* $(ETSAL)

$(ETSAL): $(ETSELS)
	@echo "Generating $@..."
	@cd $(ETSDIR) && $(UPLD) >>$(ESKLOG) 2>/dev/null

$(BCTIMESTAMP): $(ALLELS)
	@echo "Compiling $?..."
	@$(EMAX) -f batch-byte-compile $? >>$(ESKLOG) 2>&1
	@touch $@

.PHONY: compile
compile: $(BCTIMESTAMP)

.PHONY: update-elpa
update-elpa:
	@echo "Installing missing packages from ELPA..."
	$(ELPA) -f package-refresh-contents -f esk/install-packages

.PHONY: upgrade-elpa
upgrade-elpa:
	@echo "Upgrading packages from ELPA..."
	$(ELPA) -f package-refresh-contents -f esk/upgrade-packages
