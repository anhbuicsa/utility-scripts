#!/bin/bash
#gcloud logging sinks list --folder=   --project= --organization=   --format= --filter= --sort-by=
gcloud logging sinks list --limit=10 --project=$1 --format=json
