.DEFAULT_GOAL := release

name = peach

release:
	$(MAKE) clean
	sass peach.scss peach.css --no-source-map --style expanded
	sass peach.scss peach.min.css --no-source-map --style compressed

debug:
	sass peach.scss peach.css --no-source-map --style expanded --verbose

clean:
	rm ${name}.css ${name}.css.map
