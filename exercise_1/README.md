## Exercise 1: Print JSON Content to the Console

**Objective:** Demonstrate a simple genrule that reads data.json and prints its contents to the console.

**Steps:**

    1.Create a BUILD file under simple_genrule/.

    2.Define a genrule that references data.json as its source.

    3.Use cmd to run a cat (or similar command) that prints the file contents, also storing them in a small log file so Bazel doesn’t complain about missing outputs.
Run bazel build //simple_genrule:print_data and verify the output in the console and the generated log.

**Estimated Duration:** ~15 minutes (explanation + practice).