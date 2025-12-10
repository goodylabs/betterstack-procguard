# betterstack-procguard

Monitor the list of processes on a Unix / Linux / BSD machine and report any unexpected processes to BetterStack.com as failed heartbeats.

## Usage

`bin/procguard-watchdog.sh [BETTERSTACK_HEARTBEAT_ID] 5`

It verifies the list of processes on the local machine every 5 seconds and when a new unknown process appears, it sends the failed heartbeat HTTP request to BetterStack.com API.
