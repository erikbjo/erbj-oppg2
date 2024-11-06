# Checkov with severity level

This composite action is used to run checkov with the ability to fail on a given severity level.
It is essentially the same as the built-in fail-on-level option in Checkov, but this action does not
require an API-key.

The action takes three inputs:

- WORKING_DIR:
    - The directory to execute the commands in.
- FAIL_ON_LEVEL:
    - The severity level to fail on, will fail on and/or greater than the level. (LOW, MEDIUM, HIGH)
- SOFT_FAIL:
    - Boolean flag to enable soft failing. (true, false)