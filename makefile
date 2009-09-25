PREFIX=.
SRC_PATH=src
TEST_PATH=tests
INCLUDE_PATH=$(PREFIX)/include
LIB_PATH=$(PREFIX)/lib
EXTERNAL_LIBS=$(PREFIX)/external-libs

INCLUDE_FILES=scm-lib_.scm class.scm class_.scm match.scm thread-simulation_.scm
LIB_FILES=scm-lib.o1 rbtree.o1 thread-simulation.o1

all: prefix include lib

prefix:
ifneq "$(PREFIX)" "."
	mkdir -p $(PREFIX)
endif

include: $(foreach f,$(INCLUDE_FILES),$(INCLUDE_PATH)/$(f))
$(INCLUDE_PATH)/%.scm: $(SRC_PATH)/%.scm
	mkdir -p $(INCLUDE_PATH)
	cp $< $@

lib: $(foreach f,$(LIB_FILES),$(LIB_PATH)/$(f))
$(LIB_PATH)/%.o1: $(SRC_PATH)/%.scm
	mkdir -p $(LIB_PATH)
	gsc -o $@ $<

setup-libs: setup-scm-lib setup-class

$(SRC_PATH)/scm-lib.scm $(SRC_PATH)/scm-lib_.scm: setup-scm-lib
setup-scm-lib:
	mkdir -p $(LIB_PATH)
	mkdir -p $(EXTERNAL_LIBS)
ifeq "$(wildcard $(EXTERNAL_LIBS)/scm-lib)" ""
	cd $(EXTERNAL_LIBS) && git clone git://github.com/sthilaid/scm-lib.git
endif
	cd $(EXTERNAL_LIBS)/scm-lib && git pull
	$(MAKE) -C $(EXTERNAL_LIBS)/scm-lib
	cp $(EXTERNAL_LIBS)/scm-lib/include/* $(SRC_PATH)/
	cp $(EXTERNAL_LIBS)/scm-lib/src/* $(SRC_PATH)/
	cp $(EXTERNAL_LIBS)/scm-lib/lib/* $(LIB_PATH)/

$(SRC_PATH)/class.scm $(SRC_PATH)/class_.scm: setup-class
setup-class:
	mkdir -p $(LIB_PATH)
	mkdir -p $(EXTERNAL_LIBS)
ifeq "$(wildcard $(EXTERNAL_LIBS)/class)" ""
	cd $(EXTERNAL_LIBS) && git clone git://github.com/sthilaid/class.git
endif
	cd $(EXTERNAL_LIBS)/class && git pull
	$(MAKE) -C $(EXTERNAL_LIBS)/class
	cp $(EXTERNAL_LIBS)/class/include/* $(SRC_PATH)/
	cp $(EXTERNAL_LIBS)/class/src/* $(SRC_PATH)/
	cp $(EXTERNAL_LIBS)/class/lib/* $(LIB_PATH)/


TEST_INCLUDE_FILES=$(addprefix $(INCLUDE_PATH)/, $(INCLUDE_FILES))
TEST_RUN_FILES=$(addprefix $(LIB_PATH)/, $(LIB_FILES)) \
               $(TEST_PATH)/test.o1 \
	             $(TEST_PATH)/thread-simulation-tests.o1
test: $(TEST_INCLUDE_FILES) $(TEST_RUN_FILES)
	gsi $(TEST_RUN_FILES) -e "(run-tests)"

$(TEST_PATH)/%.o1: $(TEST_PATH)/%.scm
	gsc -o $@ $<


clean:
	rm -rf $(EXTERNAL_LIBS) $(INCLUDE_PATH) $(LIB_PATH) $(TEST_PATH)/*.o1

# PREFIX=.
# BUILD_PATH=$(PREFIX)/build
# INCLUDE_PATH=$(PREFIX)/include
# LIB_PATH=$(PREFIX)/lib
# EXTERNAL_LIBS=$(PREFIX)/external-libs

# INCLUDE_FILES=match.scm thread-simulation_.scm
# LIB_FILES=rbtree.o1 thread-simulation.o1

# vpath %.o1 build

# all: prefix setup-libs include lib

# prefix:
# ifneq "$(PREFIX)" ""
# 	mkdir -p $(PREFIX)
# endif

# include: $(foreach f,$(INCLUDE_FILES),$(INCLUDE_PATH)/$(f))
# $(INCLUDE_PATH)/%.scm: %.scm
# 	mkdir -p $(INCLUDE_PATH)
# 	cp $< $@

# lib: $(foreach f,$(LIB_FILES),$(LIB_PATH)/$(f))
# $(LIB_PATH)/%.o1: %.scm
# 	mkdir -p $(BUILD_PATH)
# 	gsc -o $@ $<

# $(BUILD_PATH)/%.o1: %.scm
# 	mkdir -p $(BUILD_PATH)
# 	gsc -o $@ $<

# setup-libs: setup-class
# setup-class:
# 	mkdir -p $(INCLUDE_PATH)
# 	mkdir -p $(LIB_PATH)
# 	mkdir -p $(EXTERNAL_LIBS)
# ifeq "$(wildcard $(EXTERNAL_LIBS)/class)" ""
# 	cd $(EXTERNAL_LIBS) && git clone git://github.com/sthilaid/class.git
# endif
# 	cd $(EXTERNAL_LIBS)/class && git pull
# 	$(MAKE) -C $(EXTERNAL_LIBS)/class
# 	cp $(EXTERNAL_LIBS)/class/include/* $(INCLUDE_PATH)/
# 	cp $(EXTERNAL_LIBS)/class/lib/* $(LIB_PATH)/

# TEST_INCLUDE_FILES=$(INCLUDE_PATH)/thread-simulation_.scm $(INCLUDE_PATH)/class.scm $(INCLUDE_PATH)/class_.scm $(INCLUDE_PATH)/match.scm test-macro.scm
# TEST_RUN_FILES=$(LIB_PATH)/scm-lib.o1 $(LIB_PATH)/rbtree.o1 $(LIB_PATH)/thread-simulation.o1 $(BUILD_PATH)/test.o1 $(BUILD_PATH)/thread-simulation-tests.o1
# test: setup-libs $(TEST_INCLUDE_FILES) $(TEST_RUN_FILES)
# 	gsi $(TEST_RUN_FILES) -e "(run-tests)"

# clean:
# 	rm -rf $(EXTERNAL_LIBS) $(INCLUDE_PATH) $(LIB_PATH)

# # PREFIX='.'
# # INCLUDE_PATH=$(PREFIX)/include
# # LIB_PATH=$(PREFIX)/lib
# # EXTERNAL_LIBS=$(PREFIX)/external-libs

# # all: prefix include lib

# # prefix:
# # ifneq "$(PREFIX)" ""
# # 	mkdir -p $(PREFIX)
# # endif

# # include: $(INCLUDE_PATH)/thread-simulation.scm $(INCLUDE_PATH)/thread-simulation_.scm
# # # $(INCLUDE_PATH)/scm-lib-macro.scm : scm-lib-macro.scm
# # # 	mkdir -p $(INCLUDE_PATH)
# # # 	cp $< $@

# # $(INCLUDE_PATH)/*.scm:$*.scm
# # 	mkdir -p $(INCLUDE_PATH)
# # 	cp $< $@

# # lib: $(LIB_PATH)/thread-simulation.o1
# # $(LIB_PATH)/thread-simulation.o1: rbtree.scm thread-simulation.scm
# # 	mkdir -p $(LIB_PATH)
# # 	gsc -o $@ $<

# # setup-libs: setup-scm-lib setup-class
# # setup-scm-lib:
# # 	mkdir -p $(EXTERNAL_LIBS)/scm-lib
# # 	git clone git://github.com/sthilaid/scm-lib.git
# # 	$(MAKE)
# # setup-class:
# # 	cd $(EXTERNAL_LIBS)/class
# # 	git clone git://github.com/sthilaid/class.git
# # 	$(MAKE)