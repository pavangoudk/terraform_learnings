## In-Built Functions in Terraform: Practical Usage and Assignments 🧩

### Overview 📚
This video, part 11 of a 28-day Terraform series, dives deep into the built-in functions available in Terraform. The focus is on hands-on practice through multiple assignments designed to solidify understanding of numeric, string, collection, filesystem, and type conversion functions. Instead of just theoretical explanation, the instructor actively codes and debugs in real time using Terraform CLI and VS Code, showing both correct approaches and common mistakes in function usage. The video emphasizes using built-in methods for string manipulation, data structure merging, string formatting, input validation, and iteration in resource declarations, reinforcing the practical necessity of functions when crafting Terraform configurations.

### Summary of Core Knowledge Points ⏰

- **00:00 - 04:15 Introduction to Terraform Built-in Functions and Console Usage**
  - Terraform provides built-in functions categorized as numeric, string, collection, filesystem, and type conversion functions.
  - Functions simplify coding by encapsulating complex logic for common tasks like max value retrieval, string trims, or list manipulations.
  - Terraform does not allow custom user-defined functions, so learning built-in ones is essential.
  - Using the `terraform console` provides an interactive environment to test functions like `max()`, `min()`, `trim()`, and others before applying them in code.
  - Example: Using `max(2,4,1)` returns 4, demonstrating numeric max retrieval.

- **04:16 - 07:45 String Manipulation Functions: trim and chomp**
  - `trim()` removes occurrences of specified characters from both ends of a string; the second argument contains the characters to remove.
  - `chomp()` removes the newline character (end of line `\\n`) from strings, helpful in string cleanup.
  - Demonstrated careful syntax usage: strings must be enclosed in double quotes and proper escaping is needed.
  - Example: `trim(hello, lo)` removes all 'l' and 'o' characters from the start and end, resulting in he.

- **07:46 - 15:30 Assignment 1: Normalize Resource Names (lowercase and replace spaces)**
  - Scenario: Resource names must be all lowercase and replace spaces with hyphens.
  - Created a variable for project name and used Terraform's `replace()` to substitute spaces with hyphens, and `lower()` to convert to lowercase.
  - Used `local` variable to store transformed name for reuse.
  - Demonstrated string concatenation using `${}` syntax in resource definitions.
  - Example output: `project-alpha-resource-rg` from input `Project Alpha Resource`.

- **15:31 - 19:55 Assignment 2: Merge Multiple Tag Maps**
  - Task: Merge two maps representing default tags and environment-specific tags.
  - Demonstrated declaring variables of type `map(string)` and using the `merge()` function to combine maps.
  - Created a local variable to hold merged tags for cleaner references in resources.
  - Resulted in a unified map containing all key-value pairs from both inputs to apply as tags in a resource.

- **20:00 - 31:45 Assignment 3: Validate and Format Storage Account Name**
  - Requirements: Storage account name must be lowercase, max 23 characters, only letters and numbers.
  - Used `substring()` to limit length to 23 characters.
  - Nested `replace()` and `lower()` functions to remove spaces and convert uppercase to lowercase.
  - Discussed challenges in removing special characters and spaces using `trim()` and `replace()` with multiple nested calls.
  - Experimented live in Terraform console to test string cleanup functions.
  - Final approach combined `lower()`, multiple `replace()` calls to strip spaces and special characters.

- **32:00 - 46:30 Assignment 4: Transform Port List to Security Group Rule Names**
  - Goal: Given a comma-separated list of ports, produce security group rule names prefixed by Port- and concatenate them.
  - Demonstrated converting a string to a list using `split()`, iterating over it with `for` loops.
  - Built maps for each rule with keys like `name`, `port`, and `description`.
  - Fixed syntax errors related to `split()` usage order and dynamic blocks.
  - Used string interpolation to construct names dynamically per port.
  - Output shows multiple security rules each named like Port-80 with corresponding port number and description.

- **46:31 - 47:35 Summary and Encouragement for Practice**
  - Instructor encourages practicing these assignments independently without copying solutions.
  - Emphasizes the importance of understanding function usage deeply, as Terraform limits to built-in functions only.
  - Signals continuation in next video covering remaining assignments.

### Key Terms and Definitions ✨

- **Built-in Functions**: Predefined functions in Terraform for operations on numbers, strings, collections, etc. Cannot be extended by users.
- **Terraform Console**: Interactive CLI tool allowing real-time evaluation and testing of Terraform expressions and functions.
- **trim(string, cutset)**: Removes all Unicode code points contained in `cutset` from the start and end of `string`.
- **chomp(string)**: Removes trailing newline characters from the string.
- **replace(string, substring, replacement)**: Returns a new string replacing all occurrences of `substring` with `replacement`.
- **merge(map1, map2, ...)**: Combines multiple maps into one map. Keys from later maps overwrite earlier ones.
- **substring(string, offset, length)**: Extracts a substring starting from `offset` with `length` characters.
- **split(separator, string)**: Splits a string by `separator` into a list of substrings.
- **local variable**: A named value in Terraform configuration, scoped to a module, to hold computed expressions.
- **dynamic block**: A Terraform construct to generate multiple nested blocks based on complex data structures programmatically.

### Reasoning Structure 🔍

1. **Function Utilization Motivation**
   - Premise: Repetitive logic is inefficient.
   - Reasoning: Use built-in functions to encapsulate common logic for numerics, strings, collections.
   - Conclusion: Functions provide productivity and clarity.

2. **String Normalization Process (Assignment 1)**
   - Premise: Resource names must be lowercase and hyphen-separated.
   - Reasoning: Use `replace()` to swap spaces with hyphens; use `lower()` to convert string case; assign to local variable.
   - Conclusion: Formatted string meets company naming standards.

3. **Map Merging Technique (Assignment 2)**
   - Premise: Need to combine default and environment tags.
   - Reasoning: Use `merge()` on two map variables; assign merged map to local variable for reuse.
   - Conclusion: Single tag map simplifies resource tagging.

4. **Storage Account Name Validation (Assignment 3)**
   - Premise: Name must be less than 24 chars, lowercase, numbers only.
   - Reasoning: Use `substring()` for length; nest `replace()` to eliminate spaces/special chars; apply `lower()`.
   - Conclusion: Resulting name conforms to cloud provider requirements.

5. **Port List Formatting for Security Groups (Assignment 4)**
   - Premise: Ports listed in string need conversion to prefixed rule names.
   - Reasoning: Use `split()` to convert string to list; iterate with `for` loop; construct map with `name` and `port`; use dynamic block in resource.
   - Conclusion: Correctly formatted, dynamic security group rules created.

### Examples 💡

- **Max Value Extraction**: Using `max(2,4,1)` returns `4`, illustrating basic number functions.
- **Trim Usage**: `trim(hello, lo)` removes all leading/trailing 'l' and 'o', yielding `he`.
- **Resource Name Formatting**: `Project Alpha Resource` becomes `project-alpha-resource-rg` with nested `replace()` and `lower()`.
- **Tag Maps Merge**: Combining `{env=dev}` and `{owner=team}` into `{env=dev, owner=team}` for resource tagging.
- **Port Rules Creation**: String `80,443,3306` split and transformed into security rules named `Port-80`, `Port-443`, `Port-3306` with matching ports.

### Error-Prone Points ⚠️

- Misuse of `trim()` thinking it removes characters inside a string rather than only at the start/end.
- Mixing argument order in `split()`: it is `split(separator, string)` not the other way round.
- Forgetting string interpolation syntax `${...}` when concatenating variables into strings.
- Incorrectly attempting to assign a string where a map or list is expected (e.g., dynamic block `for_each` on a string).
- Using multiple maps or variables inline repeatedly without storing in locals may slow down configurations.
- Not handling string cleaning comprehensively when multiple unwanted characters exist.

### Quick Review Tips / Self-Test Exercises 🔄

**Tips (without answers):**

- Recall the categories of Terraform built-in functions.
- Explain the purpose of `terraform console`.
- How can you replace spaces with hyphens in a string and convert it to lowercase?
- Describe how you would merge two maps of tags.
- What functions help limit a string’s length?
- How does `split()` differ from `replace()` in function application?

**Exercises (with answers):**

1. Fill in the blank: To remove all occurrences of characters l and o from the edges of string `hello`, you use `_______`.
   - Answer: `trim(hello, lo)`

2. What is the syntax to convert string variable `var.name` to lowercase and replace spaces with hyphens?
   - Answer: `lower(replace(var.name,  , -))`

3. Given `var.default_tags = {env=dev}` and `var.env_tags = {owner=ops}`, write the expression to merge them.
   - Answer: `merge(var.default_tags, var.env_tags)`

4. To split `80,443,3306` by commas into a list, use `split(____, ____ )`.
   - Answer: `split(,, 80,443,3306)`

5. How do you limit a string variable `var.name` to max 23 characters?
   - Answer: `substring(var.name, 0, 23)`

### Summary and Review 🔁
This video extensively explored Terraform’s built-in functions through practical, task-driven learning. Starting with numeric and string functions, the instructor showcased testing via the Terraform console to validate assumptions. The core knowledge centered on function usage to transform strings for resource naming conventions, merging complex maps for tagging, stringent validation and cleanup of resource names, and dynamic generation of resource blocks through list manipulation. Hands-on debugging illuminated common pitfalls, such as order of arguments and string vs list distinctions. By completing the four assignments, learners gain confidence in applying and chaining Terraform functions effectively, foundational for writing cleaner, more maintainable infrastructure-as-code. The upcoming continuation promises deeper exploration of advanced functions and their real-world applications.
