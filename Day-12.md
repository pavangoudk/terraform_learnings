## Azure DevOps with Terraform - Day 12: Advanced Variable Handling and Validation Functions

### Overview 📘
This video is a continuation of a hands-on series integrating Azure DevOps and Terraform, focusing on advanced Terraform variable manipulations and validations. It delves deeply into practical assignments that demonstrate how to use Terraform functions like `lookup`, `validation`, conditional logic, and managing sensitive data. The instruction balances conceptual explanations with live coding demonstrations, helping viewers build robust infrastructure configurations through enhanced Terraform programming techniques.

### Summary of core knowledge points ⏱️

- **00:00 - 04:52 | Understanding the `lookup` Function and Environment Configuration Mapping**  
  The video introduces the `lookup` function as a more efficient alternative to nested conditionals for mapping environment names (Dev, Staging, Prod) to specific machine types. It emphasizes implementing fallback/default values when lookup keys are absent and validates environment input strictly via variable validation. Example: Setting the default environment as Dev if no environment is specified and restricting accepted values with a clear error message for invalid inputs.

- **04:52 - 15:47 | Validations on VM Size Variable Using Functions `length` and `contains`**  
  Demonstrates validation rules applied to a VM size variable: enforcing string length between 2 to 20 characters and ensuring the string contains the keyword standard using the `contains` function. The video highlights a common error — `contains` function does not work on strings but only on lists or sets — and introduces `strcontains` as the correct function for string substring checks, ensuring validation accuracy.

- **15:47 - 20:54 | Handling Sensitive Variables and Validation with `endswith` Function**  
  The tutorial explains how to mark variables as sensitive (e.g., credentials) to prevent their exposure in Terraform outputs. It shows how to validate strings to ensure they end with a specific suffix (`endswith` function), such as backup names ending with _backup. This reinforces good practices in managing secrets and adhering to naming conventions through validation.

- **20:54 - 26:39 | File Path Validation and Managing Unique Resource Locations with `concat` & `toset` Functions**  
  Covers validating file and directory paths with `fileexists` function to confirm presence of required Terraform files. Then, it addresses combining location lists using `concat` and removing duplicates by converting lists to sets via `toset`, ensuring unique resource location data. This part illustrates manipulating variable collections to meet infrastructure configuration needs.

- **26:39 - 31:56 | Cost Calculations: Absolute Value Transformation and Finding Maximum**  
  Discusses working with numeric lists containing negative values by converting all to absolute via a loop and `abs` function, thereafter calculating the maximum cost using `max` function. It clarifies a subtlety with `max` requiring unpacking of list elements using the splat operator (`...`) to work correctly on collections.

- **31:56 - 37:33 | Timestamp Management and Formatting Using `timestamp` and `formatdate` Functions**  
  The video explains obtaining system timestamps with `timestamp()` and formatting it into human-readable strings with `formatdate()`. These formatted timestamps can be included as tags or resource identifiers for auditability and versioning in resource management, underscoring practical application of time-based Terraform functions.

- **37:33 - 41:49 | Secure File Content Handling and JSON Validation**  
  Covers reading JSON configuration files securely by marking loaded content as sensitive to avoid output leakage. The use of `jsondecode` allows parsing string content into Terraform objects, facilitating validation of JSON structures. This underscores the importance of secure and structured configuration management.

### Key terms and definitions 📚

- **lookup(map, key, default)**: Retrieves a value from a map using the specified key. If the key is missing, returns the default value to avoid errors.  
- **validation block**: A block inside variable declarations used to enforce data constraints and display custom error messages if validation fails.  
- **sensitive**: A Terraform variable property that masks values from being displayed in CLI outputs to protect secrets.  
- **contains(list or set, element)**: Checks if a list or set contains a certain element. Not applicable on plain strings.  
- **strcontains(string, substring)**: Checks if a substring exists within a string, for string content validation.  
- **endswith(string, suffix)**: Validates whether a string ends with a certain suffix, useful for naming conventions.  
- **fileexists(path)**: Returns whether a given file path exists, used for validating configuration file paths.  
- **concat(list1, list2)**: Combines two lists into a single list, preserving order and duplicates initially.  
- **toset(list)**: Transforms a list into a set data structure that only contains unique values, thus removing duplicates.  
- **abs(number)**: Returns the absolute (non-negative) value of a number.  
- **max(numbers...)**: Returns the maximum number from one or more input values; requires unpacking a list/set using `...` if used with collections.  
- **timestamp()**: Returns the current UTC timestamp string in RFC3339 format.  
- **formatdate(format, timestamp)**: Formats a timestamp string according to a custom date/time pattern.  
- **jsondecode(string)**: Parses a JSON formatted string into a Terraform object.  

### Reasoning structure 🔍

1. **Premise:** Need to assign machine sizes based on environment names with a default fallback.  
   → **Reasoning:** Use `lookup` to efficiently map environments to VM sizes with a default in case of an invalid environment.  
   → **Conclusion:** Allows scalable environment-variable management without complex nested conditional logic.

2. **Premise:** VM size must obey formatting rules (length and keyword presence).  
   → **Reasoning:** Combine `length` checks and substring validation using `strcontains` to enforce the rules. Validate input upon assignment to catch configuration errors early.  
   → **Conclusion:** Strong validation avoids runtime errors and enforces organizational standards.

3. **Premise:** Sensitive data like credentials must not be exposed in outputs.  
   → **Reasoning:** Mark variables as `sensitive` and apply the same attribute to any output variables exporting those values.  
   → **Conclusion:** Protects secrets from accidental exposure during Terraform operations.

4. **Premise:** Duplicates can exist in user and default location lists, need unique locations to configure resources properly.  
   → **Reasoning:** Use `concat` to merge lists and `toset` to convert to a unique set of locations.  
   → **Conclusion:** Clean unique list used for resource location ensures no redundancy and errors in resource allocation.

5. **Premise:** Must handle negative costs and compute maximum cost efficiently.  
   → **Reasoning:** Use a loop with `abs` to convert negative to positive numbers, then expand the list elements with the splat operator when passing to `max`.  
   → **Conclusion:** Accurate financial calculations with robust handling of list data types.

### Examples ✨

- **Environment machine type mapping using `lookup`**: The key-value map (Dev: Standard_D2s_v3, Staging: ..., Prod: ...) provides the VM size per environment. If the user inputs Prod, VM size Standard_D8s_v3 is selected; if the input is invalid, a validation error occurs.

- **VM size validation failure**: Attempting to use `contains()` on a string instead of a list causes an error, demonstrating the important difference between string and list containment functions and directing to use `strcontains` instead.

- **Sensitive Backup Credential Example**: A backup credential variable is marked sensitive, ensuring that even if output is created, the value is masked, showcasing Terraform's sensitive data handling capabilities.

- **Location Deduplication**: Combining user locations [East US, West US, East US] with default location [Central US] using `concat` and then `toset` results in a unique set {East US, West US, Central US}, showcasing list merging and deduplication.

- **Cost List Absolute Conversion**: Given input monthly costs `[-500, 75, -200]`, a for-loop converts all values to their absolute equivalents `[500, 75, 200]` before calculating the maximum cost as 500.

### Error-prone points ⚠️

- **Using `contains` on strings instead of lists**: The function `contains` only works with collections. For strings, the correct function is `strcontains`. Misuse leads to validation runtime errors.

- **Not expanding collections when passed to functions like `max`**: Functions expecting multiple discrete arguments cannot directly accept lists or sets without unpacking them with the splat operator `...`.

- **Omitting `sensitive = true` in output variables propagating sensitive inputs**: A variable marked as sensitive must be accompanied by an output declaration that also marks sensitivity; otherwise, Terraform warns about potentially exposing sensitive data.

- **Incorrect suffix validation with `endswith`**: Ensuring the string ends exactly with the suffix is case- and character-specific; misspelling (e.g., hyphen vs underscore) causes failed validations.

### Quick review tips/self-test exercises 📝

**Tips (no answers):**  
- What function can you use to provide a fallback value when a map key does not exist?  
- How do you validate that a string contains a substring in Terraform?  
- Which keyword marks a Terraform variable as sensitive?  
- How can you convert a list with duplicates into a unique collection?  
- What function allows formatting of timestamps into human-readable strings?

**Exercises (with answers):**

1. **Q:** How do you validate that an environment variable only accepts Dev, Staging, or Prod in Terraform?  
   **A:** Use variable `validation` block with `condition = contains([Dev, Staging, Prod], var.environment)` and provide an error message.

2. **Q:** What will happen if you use `contains(vm_size_variable, standard)` where `vm_size_variable` is a string?  
   **A:** Terraform will throw an error because `contains` requires a list/set; use `strcontains(vm_size_variable, standard)` instead.

3. **Q:** How do you ensure negative numbers in a list are converted to positive before using `max`?  
   **A:** Use a for expression to map each number to its absolute value: `[for cost in local.costs : abs(cost)]` then apply `max()` on this list.

4. **Q:** What syntactical change is needed when passing a list to `max` to get the highest number?  
   **A:** Use the splat operator `...` to unpack the list: `max(local.positive_costs...)`.

5. **Q:** How do you mark a variable so that its value does not get displayed in Terraform plan or output?  
   **A:** Add `sensitive = true` in the variable declaration.

### Summary and review 🔄
This video builds on Terraform essentials by focusing on advanced variable management techniques such as key-value lookups with fallback values, string and list validations, handling sensitive data, and data transformations like deduplication and absolute value calculations. It carefully walks through function usages like `lookup`, `validation`, `contains` vs. `strcontains`, `endswith`, `concat`, `toset`, and timestamp formatting to create resilient, error-resistant Terraform configurations. These assignments prepare practitioners for real-world infrastructure scenarios where input validation, secure data handling, and efficient resource definitions are crucial. The next lessons will move forward into actual Azure resource creation, applying these foundational variable techniques in live deployments.
