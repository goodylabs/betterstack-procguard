[![Build Snap](https://github.com/goodylabs/betterstack-procguard/actions/workflows/build-snap.yml/badge.svg?branch=main)](https://github.com/goodylabs/betterstack-procguard/actions/workflows/build-snap.yml)

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

### Linux

1. Get the latest snap from https://github.com/goodylabs/betterstack-procguard/actions -> choose details of the latest run
2. Download procguard artifact as procguard.zip
3. Run the following on your Linux machine

```
unzip procguard.zip
sudo snap install procguard_1.1_amd64.snap --dangerous --classic
```
