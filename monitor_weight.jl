using Pkg
Pkg.activate(".")
Pkg.instantiate()
using SerialPorts
using Dates
using YAML
using Statistics

include("functions.jl")

# list_serialports()
# portname = "/dev/ttyS5"

parameters = YAML.load_file("parameters.yml")

# Make the file where the data is written:
output_file_name = "scale-data.txt"

touch(output_file_name)

# Start measurements:
measure_weight(
    output_file_name,
    parameters["portname"],
    parameters["baudrate"],
    parameters["bits"]bits,
    parameters["stopbits"])
