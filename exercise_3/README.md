## Exercise 3: Creating a Custom Rule

**Objective:** Understand the difference between a native rule (like genrule) and a custom rule written in Starlark.

**Steps:**

1. Create a `exercise_3\rules.bzl` file to define a simple rule, for example `my_json_rule`.
2. Inside `my_json_rule`, specify:
    * Attributes: `name`, `src` (for the JSON), possibly `output`.
    * The main action: copying or transforming content (similar to `genrule`), but now using Starlark 
    (`ctx.actions.run` or `ctx.actions.write`).
3. In the `exercise_3\BUILD` file, load the rule (`load("//:rules.bzl", "my_json_rule"`) and create a target that uses `my_json_rule`.
4. Modify `my_json_rule` when `script` is a custom rules public `attr`

5. Run `bazel build //exercise_3:my_json_rule_target`.


*Custom Rule Doc:* https://bazel.build/extending/rules#implementation_function

**Estimated Duration:**  ~20 minutes (explanation + practice).

**Solution:** `git cherry-pick 7c0c6196dd38979efab1dc3cd34336384c49ae4c`
