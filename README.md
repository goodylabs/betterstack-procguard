# betterstack-procguard

Monitor the list of processes on a Unix / Linux / BSD machine and report any unexpected processes to BetterStack.com as failed heartbeats.

## Usage

`procguard [BETTERSTACK_HEARTBEAT_ID] 5`

It verifies the process list on the local machine every 5 seconds.
When a new unknown process appears, it sends a failed heartbeat HTTP request to BetterStack.com API.

## Installation 

### macOS

```
brew tap goodylabs/betterstack-procguard https://github.com/goodylabs/betterstack-procguard
brew install procguard
```
