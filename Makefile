# Makefile for second project to FLP
# author: Daniel Patek (xpatek08)
# VUT FIT 2023

COMPILER = swipl
EXECUTABLE = flp22-log
ZIPNAME = flp-log-xpatek08.zip

all: 
	$(COMPILER) -O -q -g main -o $(EXECUTABLE) -c $(EXECUTABLE).pl

clean:
	rm -rf $(EXECUTABLE) $(ZIPNAME)

zip: all
	zip -r $(ZIPNAME) $(EXECUTABLE).pl Makefile README.md run_tests.sh tests

test: all
	./run_tests.sh