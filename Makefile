LUAROCKS ?=
CHECK = luarocks install luacheck
DISCOUNT = luarocks install lua-discount
LDOC = luarocks install ldoc

all: clean global

clean:
	@rm -rf ./docs

local:
	$(CHECK) --local
	$(DISCOUNT) --local && $(LDOC) --local
	@make $(LUAROCKS) run

global:
	$(CHECK)
	$(DISCOUNT) && $(LDOC)
	@make run

run:
	$(LUAROCKS)luacheck .
	$(LUAROCKS)ldoc Lib -c ./.luadoc