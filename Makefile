# Makefile for second project to FLP
# author: Daniel Patek (xpatek08)
# VUT FIT 2023

# Prolog compiler
COMPILER = swipl
EXECUTABLE = flp22-log
ZIPNAME = flp-log-xpatek08.zip

all: 
	$(COMPILER) -g main -o $(EXECUTABLE) -c $(EXECUTABLE).pl

clean:
	rm -rf $(EXECUTABLE) $(ZIPNAME)

#todo
zip: all
	zip -r $(ZIPNAME) $(EXECUTABLE).pl Makefile 

test: all
	./run_tests.sh