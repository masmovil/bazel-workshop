genrule(
    name = "convert_data_2",
    srcs = [
        "//resources:data.json",
    ],
    tools = ["//resources:process_json.py"],
    outs = ["output.csv"],
    cmd = "python3 resources/process_json.py $(SRCS) $(OUTS)",
)