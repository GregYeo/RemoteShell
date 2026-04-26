## rex CLI

The binary name is `rex`, standing for **Remote Execution**.

## The Problem
Executing commands on a remote server during development presents several challenges:

* **Fixed Targets vs. Manual Input**: SSH requires you to specify the target server every time, even though the target is usually fixed for the duration of a project.

* **Shell Complexity & Collisions**: Running complex commands over SSH often requires tricky escaping to avoid local/remote shell collisions. Managing quote boundaries, redirections, and TTY/color support usually necessitates uploading temporary scripts to ensure safety.

* **Boilerplate Fatigue**: Developers often end up writing fragile, custom wrapper scripts (like remote.sh) to handle repeatable logic for every new project.

## The Goal

* **Project-Based Configuration**: Use a [rex.yaml](sample/rex.yaml) file to define the target server and remote working directory. This eliminates repetitive arguments and the need for custom wrapper scripts.
* **Native Performance**: Built as a compiled binary using system programming to ensure the lowest possible execution latency.
  * It still wraps SSH to respect ssh integration in the system

## Usage
Simply prefix your project commands with `rex`:
```shell
rex docker compose build
```

## Performance Benchmark
`rex` is faster than traditional script-based wrappers because it optimizes the connection overhead (using direct SSH execution rather than the scp + ssh pattern).

### Comparison: rex vs. Custom Wrapper Script
```shell
# REX project CLI version
# It uses ssh only
time rex echo hello
hello
Connection to 192.168.64.2 closed.
rex echo hello  0.10s user 0.02s system 32% cpu 0.374 total

# Custom script version
# It uses scp and ssh both to run script in remote
time ./remote.sh echo hello
hello
Connection to 192.168.64.2 closed.
./remote.sh echo hello  0.16s user 0.05s system 31% cpu 0.641 total
```