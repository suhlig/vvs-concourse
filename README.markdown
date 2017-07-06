# VVS Concourse Pipeline

This is an experiment to visualize the VVS network using Concourse.

```bash
fly --target=lite login --concourse-url=http://$(docker-machine ip):8080
fly --target=lite set-pipeline --pipeline=VVS --config=pipelines/vvs.yml
fly --target=lite unpause-pipeline --pipeline=VVS
station=Böblingen stopover_time=5 fly -t lite execute -c tasks/halt/task.yml -i pipeline=.
```

# TODO

* Spread out the start time so that we don't overload the pipeline
* Create a separate group for each station
* Crazy idea: Can we fetch the actual start times for a train and emit them in a new resource?
