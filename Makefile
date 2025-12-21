.DEFAULT_GOAL := release

NAME     := peach
RAW      := ${NAME}.scss
EXPANDED := ${NAME}.css
MINIMAL  := ${NAME}.min.css
MAP      := ${NAME}.css.map

# https://developer.mozilla.org/en-US/docs/Glossary/Percent-encoding
define encode-svg
	awk 'ORS="";{
		gsub(/#/,  "%23");
		gsub(/\?/, "%3F");
		printf "%s",$$0
	}' $(1)
endef

# Replace svg("file.svg") calls with url('data:image/svg+xml,')
define inline-svg
$(subst svg("$(1)"),url('data:image/svg+xml,$(shell $(call encode-svg,$(1)))'),$(file < $(2)))
endef

# There should be a loop that 
inline:
	$(file > ${FILE},$(call inline-svg,${NAME}.svg,${FILE}))

release:
	$(MAKE) clean
	sass ${RAW} ${EXPANDED} --no-source-map --style expanded
	$(MAKE) inline FILE=${EXPANDED}
	sass ${RAW} ${MINIMAL}  --no-source-map --style compressed
	$(MAKE) inline FILE=${MINIMAL}

debug:
	sass ${RAW} ${EXPANDED} --no-source-map --style expanded --verbose
	$(MAKE) inline FILE=${EXPANDED}

clean:
	rm -f ${EXPANDED} ${MINIMAL} ${MAP}
