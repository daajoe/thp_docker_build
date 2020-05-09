.PHONY: clean

glibc:
	./container_build_glibc.sh

glibc_force:
	./container_build_glibc.sh

build_solver:
	./build_solver.sh $(ARGS)


target: glibc

clean :
	rm -rf build/solvers/*
distclean :
	rm -rf build/*
