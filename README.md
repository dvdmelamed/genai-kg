# GenAI KG - Generative Artificial Intelligence Knowledge Graph

## Description
This project is a knowledge graph of generative artificial intelligence. It is a collection of information about the field of generative artificial intelligence. It is a work in progress.

## Terraform
This project includes IaC files in order to setup a Neptune cluster as well as an EC2 client in order to connect to the cluster locally. The files were inspired by this [AWS Cloudformation stack](https://docs.aws.amazon.com/neptune/latest/userguide/streams-examples.html).

## Sample Application
A sample application using Streamlit is included in the `app` folder. It includes a simple prompt to interact with the graph using GenAI.

## Data
In order to bootstrap the knowledge graph, we used the following data sources:
* [Security Graph](https://github.com/aws/graph-notebook/tree/2de38f8b0988877142f6baa084276082c4f5a860/src/graph_notebook/seed/queries/propertygraph/gremlin/security-graph)

## Installation

### Prerequisites

Make sure you have access to the Claude3 model if this is the first time you use it. 

### Provision the Neptune Cluster using the included Terraform

### Seed the data in the graph using the notebook located in `notebooks/Neptune/01-Neptune-Database/03-Sample-Applications/04-Security-Graphs/01-Building-a-Security-Graph-Application-with-openCypher.ipynb`

### Open an SSH tunnel to get local access to the Neptune cluster

 ```bash
 ssh -i <cluster_name>.pem -L 8182:<cluster_url>:8182 ec2-user@44.200.149.23
```

### Add your cluster to your `/etc/hosts`

```bash
127.0.0.1 <cluster_url>
```

### Run the Streamlit app

```bash
streamlit run app/app.py
```
