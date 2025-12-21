.DEFAULT_GOAL := release

name     := peach
raw      := ${name}.scss
inlined  := ${name}.bundle.scss
expanded := ${name}.css
minimal  := ${name}.min.css
map      := ${name}.css.map

define sanitize
	awk '{
		gsub(/#/,  "%23");
		gsub(/\?/, "%3F");
		printf "%s",$$0
	}
	END { if(NR>0) printf "\n" }'
	$(1)
endef

define inline-svg
	$(subst svg("$(1)"),url('data:image/svg+xml,$(shell $(call sanitize,$(1)))'),$(file < $(2)))
endef

inline:
	$(file > ${inlined},$(call inline-svg,${name}.svg,${raw}))

release:
	$(MAKE) clean
	$(MAKE) inline
	sass ${inlined} ${expanded} --no-source-map --style expanded
	sass ${inlined} ${minimal}  --no-source-map --style compressed

debug:
	$(MAKE) inline
	sass ${inlined} ${expanded} --no-source-map --style expanded --verbose

clean:
	rm -f ${inlined} ${expanded} ${minimal} ${map}
