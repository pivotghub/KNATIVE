#Knative Eventing and testing with hell of an effort. This is 11:50 PM IST now in Bangalore.
#This does not need any installation of Knative Serving

You will need:
+ Kubernetes Cluster Managed on DigitalOcean
+ Nodes are on V1.28.2


# Eventing version is v1.11.3
# DigitalOcean 
https://docs.digitalocean.com/reference/doctl/how-to/install/
DOCTL command line for below.
Always delete the existing LB before you start this exercise otherwise  
kourier-networking may conflict
doctl kubernetes cluster create n-knative-serving-eventing --size s-2vcpu-4gb --count 2

# To start
v1.11.3_basic_installation.sh - CRD, CORE and MQTT broker, Channel

# Broker
kubectl create namespace eventing-test

broker.yaml to install broker - kubectl create -f broker.yaml

$ kubectl -n eventing-test get broker default
NAME      URL                                                                              AGE    READY   REASON
default   http://broker-ingress.knative-eventing.svc.cluster.local/eventing-test/default   3m6s   True


# Event Consumers
event_consumers.sh


# Create Triggers
trigger.sh
$ kubectl -n eventing-test get triggers
NAME              BROKER    SUBSCRIBER_URI                                            AGE   READY
goodbye-display   default   http://goodbye-display.eventing-test.svc.cluster.local/   24s   True
hello-display     default   http://hello-display.eventing-test.svc.cluster.local/     46s   True


# Create Producer
event_producer.sh


# Send and Get Events

kubectl -n eventing-test attach curl -it
[ root@curl:/ ]$
curl -v "http://broker-ingress.knative-eventing.svc.cluster.local/eventing-test/default" \
  -X POST \
  -H "Ce-Id: say-hello" \
  -H "Ce-Specversion: 1.0" \
  -H "Ce-Type: greeting" \
  -H "Ce-Source: not-sendoff" \
  -H "Content-Type: application/json" \
  -d '{"msg":"Hello Knative!"}'

  After you do 
  > POST /eventing-test/default HTTP/1.1
> User-Agent: curl/7.35.0
> Host: broker-ingress.knative-eventing.svc.cluster.local
> Accept: */*
> Ce-Id: say-hello
> Ce-Specversion: 1.0
> Ce-Type: greeting
> Ce-Source: not-sendoff
> Content-Type: application/json
> Content-Length: 24
>
< HTTP/1.1 202 Accepted
< Date: Sun, 24 Jan 2021 22:25:25 GMT
< Content-Length: 0


curl -v "http://broker-ingress.knative-eventing.svc.cluster.local/eventing-test/default" \
  -X POST \
  -H "Ce-Id: say-goodbye" \
  -H "Ce-Specversion: 1.0" \
  -H "Ce-Type: not-greeting" \
  -H "Ce-Source: sendoff" \
  -H "Content-Type: application/json" \
  -d '{"msg":"Goodbye Knative!"}'

  > POST /eventing-test/default HTTP/1.1
> User-Agent: curl/7.35.0
> Host: broker-ingress.knative-eventing.svc.cluster.local
> Accept: */*
> Ce-Id: say-goodbye
> Ce-Specversion: 1.0
> Ce-Type: not-greeting
> Ce-Source: sendoff
> Content-Type: application/json
> Content-Length: 26
>
< HTTP/1.1 202 Accepted
< Date: Sun, 24 Jan 2021 22:33:00 GMT
< Content-Length: 0


# verify
kubectl -n eventing-test logs -l app=hello-display --tail=100
kubectl -n eventing-test logs -l app=goodbye-display --tail=100


