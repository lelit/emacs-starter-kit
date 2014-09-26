# Simplify daily operations

.PHONY: all clean distclean update-elpa recompile-init

EMACS=emacs
EMAX=$(EMACS) --batch -l ~/.emacs.d/init.el

all: update-elpa recompile-init magit-next

clean:
	find . -name '*.elc' -print0 | xargs -r0 rm

distclean: clean
	rm -rf elpa/* elpa-to-submit/loaddefs.el*

update-elpa:
	$(EMAX) || $(EMAX)

recompile-init:
	$(EMAX) -f recompile-init

MAGIT_DIR := $(abspath elpa-to-submit/magit)
GIT_MODES_DIR := $(abspath elpa-to-submit/git-modes)
DASH_DIR := $(abspath $(wildcard elpa/dash-2*))

magit-next: $(GIT_MODES_DIR) $(MAGIT_DIR)
	(cd $(GIT_MODES_DIR) && git pull)
	make -C $(GIT_MODES_DIR) EFLAGS="-L $(DASH_DIR)" lisp
	(cd $(MAGIT_DIR) && git pull)
	make -C $(MAGIT_DIR) EFLAGS="-L $(GIT_MODES_DIR) -L $(DASH_DIR)" lisp

$(MAGIT_DIR):
	git clone --branch next https://github.com/magit/magit.git $@

$(GIT_MODES_DIR):
	git clone --branch next https://github.com/magit/git-modes.git $@
