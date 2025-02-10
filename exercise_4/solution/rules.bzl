load("//exercise_3:rules.bzl", "my_json_rule")
load(":rules_zip.bzl", "my_zip_rule")


def my_pipeline(name, src):
    """
    Macro that chains two steps:  
      1) Convert JSON to CSV using `my_json_rule`.  
      2) Compress the resulting CSV using a `genrule`.  
    """
    # 1) Target that converts JSON to CSV  
    my_json_rule(
        name = name + "_json_to_csv",
        src = src,
    )

    # 2) Target that compresses the CSV (uses the output of the first step as `src`)  
    # Output name: `pipeline.zip`  
    native.genrule(
        name = name,
        srcs = [name + "_json_to_csv"],
        outs = [name + ".zip"],
        cmd = "zip $@ $(SRCS)", # Use $(SRCS) to reference the srcs and $(@) to reference the outs
    )


def my_pipeline_zip(name, src):
    """
    Macro that chains two steps:  
      1) Convert JSON to CSV using `my_json_rule`.  
      2) Compress the resulting CSV using a `genrule`.  
    """
    # 1) Target that converts JSON to CSV  
    my_json_rule(
        name = name + "_json_to_csv",
        src = src,
    )

    # 2) Target that compresses the CSV (uses the output of the first step as `src`)  
    # Output name: `pipeline.zip`  
    my_zip_rule(
        name = name,
        src = ":" + name + "_json_to_csv",        
    )