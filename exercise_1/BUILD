genrule(
    name = "print_data",
    srcs = ["//resources:data.json"],  # Reference to data.json on resources
    outs = ["print_data.log"],  # Output file
    cmd = "echo 'HELLO BAZEL'", # use $(SRCS) to reference the srcs and $(OUTS) to reference the outs
)
