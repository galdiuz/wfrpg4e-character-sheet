rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
CSS_SRC=$(call rwildcard,src/,*_Meta.elm)
CSS_TARGET=$(patsubst %_Meta.elm,%.css,$(CSS_SRC))


build:
	@./lib/elm-posix/shell/elm-cli src/GenerateProgram.elm --debug


.PHONY: $(CSS_SRC)
%.css: %_Meta.elm
	@./lib/elm-posix/shell/elm-cli $<
	@echo "Created $@ from $<."
