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
