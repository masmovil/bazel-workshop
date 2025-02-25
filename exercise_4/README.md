## Exercise 4: Creating a Macro that Combines Multiple Rules

**Objective:** Create a macro in Starlark (in `exercise_4/rules.bzl`) that sequentially invokes multiple rules/targets.

**Steps:**

1. Write a macro `my_pipeline` that takes the JSON input and produces multiple outputs in sequence.
    * For instance, first convert the JSON to CSV, then compress the CSV..
2. In the `BUILD` file, call the macro with something like `my_pipeline(name = "pipeline", src = "data.json")`.
3. Check that a single `bazel build //exercise_4:pipeline` command generates all the expected outputs (e.g., a CSV and a ZIP).
4. Move `genrule` to a new custom bazel rule.
    * run_shell: https://bazel.build/rules/lib/builtins/actions#run_shell

**Estimated Duration:**  ~20 minutes (explanation + practice).

**Solution:** `git cherry-pick bcbb3f6849ad8ddcc77bb17ce84eda764a062d20`