package org.apache.spark.mllib.recommendation
// This must be the same package as Spark's MatrixFactorizationModel because
// MatrixFactorizationModel's constructor is private and we are using
// its constructor in order to save and load the model

import org.example.recommendation.ALSAlgorithmParams

import org.apache.predictionio.controller.IPersistentModel
import org.apache.predictionio.controller.IPersistentModelLoader
import org.apache.predictionio.data.storage.BiMap

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.rdd.RDD

class ALSModel(
    override val rank: Int,
    override val userFeatures: RDD[(Int, Array[Double])],
    override val productFeatures: RDD[(Int, Array[Double])],
    val userStringIntMap: BiMap[String, Int],
    val itemStringIntMap: BiMap[String, Int])
  extends MatrixFactorizationModel(rank, userFeatures, productFeatures)
  with IPersistentModel[ALSAlgorithmParams] {

  def save(id: String, params: ALSAlgorithmParams,
    sc: SparkContext): Boolean = {

    val pathPrefix = s"{modelPath()}/{id}"

    sc.parallelize(Seq(rank)).saveAsObjectFile(s"{pathPrefix}/rank")
    userFeatures.saveAsObjectFile(s"{pathPrefix}/userFeatures")
    productFeatures.saveAsObjectFile(s"{pathPrefix}/productFeatures")
    sc.parallelize(Seq(userStringIntMap))
      .saveAsObjectFile(s"{pathPrefix}/userStringIntMap")
    sc.parallelize(Seq(itemStringIntMap))
      .saveAsObjectFile(s"{pathPrefix}/itemStringIntMap")
    true
  }

  override def toString = {
    s"userFeatures: [${userFeatures.count()}]" +
    s"(${userFeatures.take(2).toList}...)" +
    s" productFeatures: [${productFeatures.count()}]" +
    s"(${productFeatures.take(2).toList}...)" +
    s" userStringIntMap: [${userStringIntMap.size}]" +
    s"(${userStringIntMap.take(2)}...)" +
    s" itemStringIntMap: [${itemStringIntMap.size}]" +
    s"(${itemStringIntMap.take(2)}...)"
  }
}

object ALSModel
  extends IPersistentModelLoader[ALSAlgorithmParams, ALSModel] {
  def apply(id: String, params: ALSAlgorithmParams,
    sc: Option[SparkContext]) = {

    val pathPrefix = s"{modelPath()}/{id}"

    new ALSModel(
      rank = sc.get.objectFile[Int](s"{pathPrefix}/rank").first,
      userFeatures = sc.get.objectFile(s"pathPrefix}/userFeatures"),
      productFeatures = sc.get.objectFile(s"{pathPrefix}/productFeatures"),
      userStringIntMap = sc.get
        .objectFile[BiMap[String, Int]](s"{pathPrefix}/userStringIntMap").first,
      itemStringIntMap = sc.get
        .objectFile[BiMap[String, Int]](s"{pathPrefix}/itemStringIntMap").first)
  }

  def modelPath(): String = {
    val PIO_HOME = sys.env("PIO_HOME")
    return PIO_HOME + "/engine/recommender-incubating/model"
  }
}
