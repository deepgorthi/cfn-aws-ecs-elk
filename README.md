# elk-stack-on-aws-ecs
 Deploying Elastic Stack on AWS Elastic Container Service

I will outline the procedure I followed to deploy Elastic Stack on AWS ECS.

> Here is the architecture I followed to build this

![Arch](ELK-ECS.jpg)

In the diagram above, we have the following containers:
- Three ElasticSearch containers to ensure high availability. Odd number to minimize split brain scenarios.
- Two Kibana containers for UI
- Two logstash containers to handle traffic


>[**Split Brain Scenario**](https://scalac.io/split-brain-scenarios-with-akka-scala/#targetText=A%20network%20partition%20membership%20data%20of%20the%20cluster) is a situation where a network failure caused the network to split. The split means that the parts can no longer communicate with each other. They need to decide what to do next on their own based on the latest membership data of the cluster. This is being handled by using 3 ECS clusters. 


*Working with immutable infrastructure to replace defective componenets of this architecture.*

After adding DockerFile and elasticsearch.yml configuration files, run the aws-ecr-bake-and-push.sh file to push a new docker image into the private docker repo. 
```
./aws-ecr-bake-and-push.sh elasticsearch
```
