sprites=$(addprefix ./sprites/, tilesA.aseprite)
jsons=$(addprefix ./build/, $(notdir $(sprites:.aseprite=.json)))
atlas=./atlas.png
aseprite=~/.steam/steam/steamapps/common/Aseprite/aseprite
texatlas_script=../im_stack.py

all: create_build_dirs $(atlas)

$(atlas): $(jsons)
	@python $(texatlas_script) $(^:.json=.png) $(atlas)

build/%.json: sprites/%.aseprite
	@$(aseprite) -b $< --sheet $(@:.json=.png) --data $@ \
	           --list-slices --format json-array\
	           --list-tags

create_build_dirs:
	@mkdir -p build

debug:
	echo $(jsons)

clean:
	@rm -rf build
	@rm -f $(atlas)
