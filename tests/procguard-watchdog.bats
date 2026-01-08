#!/usr/bin/env bats

setup() {
  export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
  export HOME="$BATS_TEST_TMPDIR"
}

@test "fails when HEARTBEAT_ID is missing" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh
  [ "$status" -eq 1 ]
  [[ "$output" == *"Missing param HEARTBEAT_ID"* ]]
}

@test "prints usage on --help" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh --help
  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage:"* ]]
}

@test "uses default interval when missing" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh abc123
  [[ "$output" == *"Missing param INTERVAL"* ]]
}

@test "initializes whitelist from ps output" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh abc123 1
  [[ "$output" == *"Process dictionary loaded"* ]]
}

@test "sends heartbeat success on check" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh abc123 1
  grep -q "GET https://uptime.betterstack.com/api/v1/heartbeat/abc123" \
    "$BATS_TEST_TMPDIR/curl.log"
}

@test "alerts on unknown process" {
  RUN_ONCE=1 run ./bin/procguard-watchdog.sh abc123 1

  [[ "$output" == *"[ALERT] New process: /evil"* ]]

  grep -q \
  'POST -d Unknown process /evil on machine test-host (eth0) https://uptime.betterstack.com/api/v1/heartbeat/abc123/fail' \
  "$BATS_TEST_TMPDIR/curl.log"
}

