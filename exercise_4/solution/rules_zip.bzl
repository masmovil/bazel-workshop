def _my_zip_rule_impl(ctx):
    # Get Input file (JSON)
    input_file = ctx.file.src

    # Declare ouput file (ZIP)
    output_file = ctx.actions.declare_file(ctx.label.name + ".zip")

    # Execute the command
    ctx.actions.run_shell(
        inputs = [input_file],
        outputs = [output_file],      
        arguments = [input_file.path, output_file.path],  
        command = "zip $2 $1",
    )

    return [DefaultInfo(files = depset([output_file]))]

my_zip_rule = rule(
    implementation = _my_zip_rule_impl,
    attrs = {
        "src": attr.label(allow_single_file = True)       
    },
)
