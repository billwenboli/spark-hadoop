#!/usr/bin/env bash

## For Hortonworks Sandbox
scp -P 2222 ./target/spark-hadoop-1.0-SNAPSHOT.jar maria_dev@172.16.202.166:/home/maria_dev
ssh -p 2222 maria_dev@172.16.202.166

## Local Mode
spark-submit --class com.billwenboli.spark.SparkHadoop --master local spark-hadoop-1.0-SNAPSHOT.jar

## Distributed Mode - Current machine as driver machine
spark-submit --class com.billwenboli.spark.SparkHadoop --master yarn --deploy-mode client spark-hadoop-1.0-SNAPSHOT.jar

## Distributed Mode - YARN picks driver machine
spark-submit --class com.billwenboli.spark.SparkHadoop --master yarn --deploy-mode cluster spark-hadoop-1.0-SNAPSHOT.jar

## For live debugging
export SPARK_JAVA_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8086

# Notes Found Online
#
# It’s important to note that a poorly written Spark program can accidentally try to bring back many Terabytes of data to
# the driver machine, causing it to crash. For this reason you shouldn’t use the master node of your cluster as your driver
# machine. Many organizations submit Spark jobs from what’s called an edge node, which is a separate machine that isn’t
# used to store data or perform computation. Since the edge node is separate from the cluster, it can go down without
# affecting the rest of the cluster. Edge nodes are also used for data science work on aggregate data that has been retrieved
# from the cluster. For example, a data scientist might submit a Spark job from an edge node to transform a 10 TB dataset
# into a 1 GB aggregated dataset, and then do analytics on the edge node using tools like R and Python. If you plan on setting
# up an edge node, make sure that machine doesn’t have the DataNode or HostManager components installed, since these are the
# data storage and compute components of the cluster. You can check this on the host tab in Ambari.