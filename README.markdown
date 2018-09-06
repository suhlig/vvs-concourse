# VVS Concourse Pipeline

This is an experiment to visualize the VVS network using Concourse.

## Set the pipeline

```sh
fly set-pipeline --pipeline=VVS --config=<(./scripts/generate-pipeline)
```

## Execute a single task

```sh
station=Böblingen stopover_time=5 fly execute --config tasks/halt/task.yml --input pipeline=.
```

# TODO
* Use official data from VVS' [OpenData Portal](https://openvvs.de/organization/vvs)
* Spread out the start time so that we don't overload the pipeline
* Create a separate group for each station
* Crazy idea: Can we fetch the actual start times for a train and emit them in a new resource?
  -> Data is here: https://www3.vvs.de/mngvvs/VELOC
