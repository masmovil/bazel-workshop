genrule(
    name = "convert_data",
    srcs = [
        "//resources:data.json"    
    ],
    tools = ["..."] # Include the process_json.py as a tool
    outs = ["output.csv"],
    cmd = ".. resources/process_json.py ....", # Use $(SRCS) to reference the srcs and $(OUTS) to reference the outs
)
