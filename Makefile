DIALYZER_APPS = kernel stdlib sasl erts ssl tools os_mon runtime_tools crypto inets \
	public_key mnesia syntax_tools compiler
COMBO_PLT = $(HOME)/.cuttlefish_combo_dialyzer_plt

REBAR := $(shell which rebar3)

.PHONY: all
all: $(REBAR) compile
	echo $(REBAR)

.PHONY: deps
deps:
	$(REBAR) get-deps

.PHONY: distclean
docsclean:
	@rm -rf doc/*.png doc/*.html doc/*.css doc/edoc-info

.PHONY: compile
compile: deps
	$(REBAR) compile

## Environment variable CUTTLEFISH_ESCRIPT is shared with rebar.config
.PHONY: escript
escript: export CUTTLEFISH_ESCRIPT = true
escript: $(REBAR)
	$(REBAR) as escript escriptize

.PHONY: clean
clean: distclean

.PHONY: distclean
distclean:
	@rm -rf _build cuttlefish erl_crash.dump rebar3.crashdump rebar.lock

.PHONY: eunit
eunit: compile
	$(REBAR) eunit verbose=true

cover:
	$(REBAR) cover

.PHONY: dialyzer
dialyzer:
	$(REBAR) dialyzer
