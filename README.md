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

After we have the customized docker image with elasticsearch on ECR, we need to create a cluster in ECS with 3 EC2 instances. 

Few points that need to be addressed:
- We might not need all 3 instances all the time. For this reason, we will be using Autoscaling to start with 1 instance and scale to 3 whenever needed. 
- There is no way to disable public IP assignments from the ECS wizard. Instead, we need to manually ensure our private cluster stays private, safely tucked inside our VPC. 
- ElasticSearch will fail due to a low mmap count; we need to increase that.
- We need to allocate more space to our ElasticSearch nodes than the standard 8GB granted by Amazon.
- We need to customize the docker daemon to take advantage of the extra space.

Adding this to User Data section of the EC2 instances in CloudFormation Changeset.
```
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/cloud-boothook; charset="us-ascii"

# Set Docker daemon options
cloud-init-per once docker_options echo 'OPTIONS="${OPTIONS} --storage-opt dm.basesize=250G"' >> /etc/sysconfig/docker

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash
# Set the ECS agent configuration options
cat <<'EOF' >> /etc/ecs/ecs.config
ECS_CLUSTER=platformnonprod
ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=15m
ECS_IMAGE_CLEANUP_INTERVAL=10m
EOF
sysctl -w vm.max_map_count=262144
mkdir -p /usr/share/elasticsearch/data/
chown -R 1000.1000 /usr/share/elasticsearch/data/

--==BOUNDARY==--
```

**Storage**

Adding EBS stores for storage and using PIOPS as advised on elastic's documentation. 

