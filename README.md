# elk-stack-on-aws-ecs
 Deploying Elastic Stack on AWS Elastic Container Service

I will outline the procedure I followed to deploy Elastic Stack on AWS ECS.

Here is the architecture
![Arch](https://github.com/deepgorthi/elk-stack-on-aws-ecs/blob/master/ELK-ECS.jpg)

In the diagram above, we have the following containers:
- Three ElasticSearch containers to ensure high availability. Odd number to minimize split brain scenarios.
- Two Kibana containers for UI
- Two logstash containers to handle traffic

Handling split Brain scenario - 

A network partition (a.k.a. Split Brain) is a situation where a network failure caused the network to split. The split means that the parts can no longer communicate with each other. They need to decide what to do next on their own based on the latest membership data of the cluster.

> [Following the methodology here](https://scalac.io/split-brain-scenarios-with-akka-scala/#targetText=A%20network%20partition%20membership%20data%20of%20the%20cluster)

Working with immutable infrastructure.

