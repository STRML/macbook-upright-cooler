OPENSCAD ?= openscad
SRC := cad/upright_v1/upright_macbook_140mm_pressure_dock_v1.scad
BUILD := build
STL := $(BUILD)/upright_macbook_140mm_pressure_dock_v1.stl
PNG := $(BUILD)/upright_macbook_140mm_pressure_dock_v1.png
V2_SRC := cad/upright_v2/upright_macbook_140mm_pressure_dock_v2.scad
V2_BUILD := $(BUILD)/upright_v2
V2_PARTS := shell base cartridge lid cradle insert_blank insert_open gasket foot
V2_STLS := $(addprefix $(V2_BUILD)/,$(addsuffix .stl,$(V2_PARTS)))
PYTHON ?= python3

.PHONY: all stl preview stl-v2 check-v2 preview-v2 clean

all: stl

$(BUILD):
	mkdir -p $(BUILD)

stl: $(BUILD)
	$(OPENSCAD) -o $(STL) $(SRC)

preview: $(BUILD)
	$(OPENSCAD) --imgsize=1400,1000 --autocenter --viewall -o $(PNG) $(SRC)

$(V2_BUILD):
	mkdir -p $@

$(V2_BUILD)/%.stl: $(V2_SRC) | $(V2_BUILD)
	$(OPENSCAD) --hardwarnings -D 'PART="$*"' -o $@ $<

stl-v2: $(V2_STLS)

check-v2: stl-v2
	$(PYTHON) tools/check_mesh.py $(V2_STLS)

preview-v2: | $(V2_BUILD)
	$(OPENSCAD) --hardwarnings --imgsize=1600,1200 --autocenter --viewall --projection=o --colorscheme=Tomorrow -D 'PART="assembly"' -o $(V2_BUILD)/assembly.png $(V2_SRC)
	$(OPENSCAD) --hardwarnings --imgsize=1600,1200 --autocenter --viewall --projection=o --colorscheme=Tomorrow -D 'PART="assembly"' -D 'EXPLODE=20' -D 'SHOW_REFERENCE=false' -o $(V2_BUILD)/exploded.png $(V2_SRC)

clean:
	rm -rf $(BUILD)
