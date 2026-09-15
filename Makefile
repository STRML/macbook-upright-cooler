OPENSCAD ?= openscad
SRC := cad/upright_v1/upright_macbook_140mm_pressure_dock_v1.scad
BUILD := build
STL := $(BUILD)/upright_macbook_140mm_pressure_dock_v1.stl
PNG := $(BUILD)/upright_macbook_140mm_pressure_dock_v1.png
V2_SRC := cad/upright_v2/upright_macbook_140mm_pressure_dock_v2.scad
V2_BUILD := $(BUILD)/upright_v2
V2_PARTS := shell base cartridge lid cradle insert_blank insert_open gasket foot
V2_STLS := $(addprefix $(V2_BUILD)/,$(addsuffix .stl,$(V2_PARTS)))
V12_SRC := cad/upright_v2/v12_validation/upright_v2_v12_validation.scad
V12_BUILD := $(BUILD)/v12_validation
V12_GAUGES := gauge_ne gauge_nw gauge_sw gauge_se
V12_COUPONS := coupon_ne coupon_se coupon_collar
V12_PARTS := $(V12_GAUGES) $(V12_COUPONS) deck_ne deck_nw deck_sw deck_se collar bridge
V12_STLS := $(addprefix $(V12_BUILD)/,$(addsuffix .stl,$(V12_PARTS)))
PYTHON ?= python3

.PHONY: all stl preview stl-v2 check-v2 preview-v2 gauge-v12 coupon-v12 stl-v12 check-v12 preview-v12 clean

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

$(V12_BUILD):
	mkdir -p $@

$(V12_BUILD)/%.stl: $(V12_SRC) $(V2_SRC) | $(V12_BUILD)
	$(OPENSCAD) --hardwarnings -D 'PART="$*"' -o $@ $<

# Start here: the user's legacy V12 outline has not been fit-checked.
gauge-v12: $(addprefix $(V12_BUILD)/,$(addsuffix .stl,$(V12_GAUGES)))

coupon-v12: $(addprefix $(V12_BUILD)/,$(addsuffix .stl,$(V12_COUPONS)))

stl-v12: $(V12_STLS)

check-v12: stl-v12
	$(PYTHON) tools/check_mesh.py $(V12_STLS)
	$(PYTHON) tools/check_v12.py --openscad '$(OPENSCAD)'

preview-v12: | $(V12_BUILD)
	$(OPENSCAD) --hardwarnings --imgsize=1600,1200 --autocenter --viewall --projection=o --colorscheme=Tomorrow -D 'PART="assembly"' -o $(V12_BUILD)/assembly.png $(V12_SRC)
	$(OPENSCAD) --hardwarnings --imgsize=1600,1200 --autocenter --viewall --projection=o --colorscheme=Tomorrow -D 'PART="assembly"' -D 'EXPLODE=18' -D 'SHOW_REFERENCE=false' -o $(V12_BUILD)/exploded.png $(V12_SRC)
	$(OPENSCAD) --hardwarnings --imgsize=1400,1000 --autocenter --viewall --projection=o --colorscheme=Tomorrow -D 'PART="gauge_assembly"' -o $(V12_BUILD)/gauge.png $(V12_SRC)

clean:
	rm -rf $(BUILD)
