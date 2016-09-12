#!/usr/bin/env bash

warn() {
  echo "WARNING: $*" >> "${TEST_WARNINGS_OUTPUT_FILE:-/dev/stderr}"
}

testlog="${TEST_TMPDIR:+${TEST_TMPDIR}/test.log}"

test_bin="%real_bin%"
test_args=( -test.v "$@" )

if [[ -n "$XML_OUTPUT_FILE" && -n "$testlog" ]]; then
  "$test_bin" "${test_args[@]}" 2>&1 | tee "$testlog"
  err=${PIPESTATUS[0]}
  %go2xunit% \
      -input "$testlog" \
      -output "$XML_OUTPUT_FILE" \
      -suite-name-prefix "%suite_prefix%" \
    || warn "go2xunit conversion failed"
  exit "$err"
else
  "$test_bin" "${test_args[@]}"
fi
