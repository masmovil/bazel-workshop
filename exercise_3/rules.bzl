def _my_json_rule_impl(ctx):
    # Get Input file (JSON)
    input_file = ctx.file.src
    # Declare ouput file (CSV)
    output_file = ctx.actions.declare_file(ctx.label.name + ".csv")

    # Execute the command
    ctx.actions.run(
        inputs = [input_file],
        outputs = [output_file],
        arguments = [input_file.path, output_file.path],
        executable = ctx.executable._script,
    )

    return [DefaultInfo(files = depset([output_file]))]

my_json_rule = rule(
    implementation = _my_json_rule_impl,
    attrs = {
        "src": attr.label(allow_single_file = True),
        "_script": attr.label(
            allow_single_file = True,
            default = "//resources:process_json.py",
            executable = True,
            cfg = "exec",
        )
    },
)
