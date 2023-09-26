#!/bin/bash
kubectl -n eventing-test apply -f greeting-trigger.yaml
kubectl -n eventing-test apply -f sendoff-trigger.yaml
kubectl -n eventing-test get triggers
