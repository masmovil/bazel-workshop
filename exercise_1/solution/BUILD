genrule(
     name = "print_data",
     srcs = ["//resources:data.json"],  
     outs = ["print_data.log"], 
     cmd = "cat $(SRCS) | tee $@",
)
