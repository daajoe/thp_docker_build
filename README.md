# Towards Faster Reasoners by Using Transparent Huge Pages
This directory contains the files to compile a combinatorial solver with a modified glibc,
which allows to enable transparant huge pages via an environment variable.

For SAT workloads, that can result in up to 10% run time improvements.

For a detailed description, we refer to a recent report
[https://arxiv.org/abs/2004.14378](https://arxiv.org/abs/2004.14378).


## Download
```git clone --recurse-submodules https://github.com/daajoe/thp_docker_build.git```

## External Requirements

- Linux
- Docker (recent version), see [Docker CE](https://docs.docker.com/engine/install/)


## Short Description
To build the binary with a modified glibc, we setup a Docker image, and install
the modified glibc there as system default glibc. This way, the **build system
is not modified**. Since we build the solvers statically, you can use the resulting binary
on your system without installing a modified glibc.

## Usage

### Prepare the Compiler System
```sudo make glibc```

### Build a Solver
The solver build scripts are placed under "solver_scripts/". For example,
"solver_scripts/sat/minisat.sh".

To run a single solver execute the following command:
```sudo ./build_solver solver_scripts/sat/minisat.sh```

or
```sudo make build_solver ARGS="solver_scripts/sat/minisat.sh"```


To build all solvers using scripts, which are named solver_scripts/**/*.sh.
Simply execut the following command:
```sudo ./build_solver solver_scripts/sat/minisat.sh```

or
```sudo make build_solver```



### Run the Solver

#### Usual Run
Run as usual:
```./build/minisat_glibc <input.cnf>```

#### THP Run
To check whether the system has transparent huge pages enabled for being usable
with madvise, run (works on debian based systems):

```cat /sys/kernel/mm/transparent_hugepage/enabled```

You need the value "madvise".

If madvise is not set run:

```echo "madvise" | sudo tee /sys/kernel/mm/transparent_hugepage/enabled```


Run the solver with transparent huge pages, and 2M alignment enabled:

![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+)```GLIBC_THP_ALWAYS=1 ./build/minisat_glibc <input.cnf>```

en tibi 


To check whether huge pages are used on your linux system, run the following command in parallel to
the execution of the solver:

```watch -n 1 "grep Huge /proc/meminfo"```




---
[1]: [Kernel Documentation on Transparent Huge Pages](https://www.kernel.org/doc/Documentation/vm/transhuge.txt)
