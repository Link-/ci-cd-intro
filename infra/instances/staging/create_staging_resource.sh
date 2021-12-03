#!/usr/bin/env bash

# Short form: set -u
set -o nounset

# Exit immediately if a pipeline returns non-zero.
# Short form: set -e
set -o errexit

# Print a helpful message if a pipeline with non-zero exit code causes the
# script to exit as described above.
trap 'echo "Aborting due to errexit on line $LINENO. Exit code: $?" >&2' ERR

# Allow the above trap be inherited by all functions in the script.
#
# Short form: set -E
set -o errtrace

# Return value of a pipeline is the value of the last (rightmost) command to
# exit with a non-zero status, or zero if all commands in the pipeline exit
# successfully.
set -o pipefail

###############################################################################
# General Purpose Functions
###############################################################################
_get_local_directory() {
  cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P
}

# _exit_1()
#
# Usage:
#   _exit_1 <command>
#
# Description:
#   Exit with status 1 after executing the specified command with output
#   redirected to standard error. The command is expected to print a message
#   and should typically be either `echo`, `printf`, or `cat`.
_exit_1() {
  {
    printf "%s " "$(tput setaf 1)!$(tput sgr0)"
    "${@}"
  } 1>&2
  exit 1
}

###############################################################################
# Run Program
###############################################################################

# Creates a random identifier RANDOMID then creates a copy of 
# extra_staging.tf.example and renames it extra_staging_RANDOMID.tf
# The copy is also modified to replace the RANDOMID with the actual random identifier
_main() {
  # local -r: creates a readonly variable
  local -r local_dir="$(_get_local_directory)"
  # Current date as a Unix timestamp
  local -r random_id="$(date +%s)"
  # Read the first argument passed to the script otherwise default to random_id
  local -r resource_id="${1:-$random_id}"

  # If the random_id fails to generate for whatever reason, exit with an error
  if [[ -z "${resource_id}" ]]; then
    _exit_1 "FATAL: Failed to read resource identifier and default to random_id"
  fi

  # Skip copying if a resource file already exists with the same id
  if [[ ! -f "${local_dir}/extra_staging_${resource_id}.tf" ]]; then
    # Create a copy of the extra_staging.tf.example file template
    cp \
      "${local_dir}/extra_staging.tf.example" \
      "${local_dir}/extra_staging_${resource_id}.tf"

    # Replace the <RANDOMID> with the actual random identifier
    sed -i "s/RANDOMID/${resource_id}/g" "${local_dir}/extra_staging_${resource_id}.tf"
  fi

  # Exit after outputing the meta data either way
  echo '{"resource_file": "extra_staging_'${resource_id}'.tf", "terraform_expected_output": "staging_dns_'${resource_id}'"}'
  exit 0
}


# Call the `_main` function after everything has been defined.
_main "${@}"
