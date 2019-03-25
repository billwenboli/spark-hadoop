package com.billwenboli.spark;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.io.IOException;
import java.util.Arrays;

public class SparkHadoop {

    public static void main(String[] args) throws IOException {

        //Create a SparkContext to initialize
        SparkConf conf = new SparkConf().setMaster("local").setAppName("Word Count");

        // Create a Java version of the Spark Context
        JavaSparkContext sc = new JavaSparkContext(conf);

        // Load the text into a Spark RDD, which is a distributed representation of each line of text
        JavaRDD<String> textFile = sc.textFile("hdfs:///tmp/shakespeare.txt");

        JavaPairRDD<String, Integer> counts = textFile
                .flatMap(s -> Arrays.asList(s.split("[ ,]")).iterator())
                .mapToPair(word -> new Tuple2<>(word, 1))
                .reduceByKey((a, b) -> a + b);

        counts.foreach(p -> System.out.println(p));
        System.out.println("Total words: " + counts.count());

        Configuration configuration = new Configuration();
        FileSystem hdfs = FileSystem.get(configuration);

        Path path = new Path("hdfs:///tmp/shakespeareWordCount.txt");

        if (hdfs.exists(path)) {
            hdfs.delete(path, true);
        }

        counts.saveAsTextFile("hdfs:///tmp/shakespeareWordCount.txt");
    }
}
