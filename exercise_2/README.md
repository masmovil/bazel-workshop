## Exercise 2: Process the JSON File

**Objective:** Apply a simple script in Python to read the JSON and convert it to another format (e.g., CSV).

**Steps:**

1. Create a `BUILD` file under `exercise_2/team_name_solution/.`
2. In the `BUILD` file, define a `genrule` (convert_data) that:
    * Declares the `resources\process_json.py` script as a `tool (tools)`.
    * Calls `resources\process_json.py` in the cmd and write the result to an output `output.csv.`

**Estimated Duration:** ~15 minutes (explanation + practice).
