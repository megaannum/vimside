package com.megaannum

import java.lang.Float
import java.lang.Math
import scala.math._
import scala.sys._



object Foo {
  def main(args: Array[String]): Unit = {
    val nameOfBar = Bar.NAME
    println(nameOfBar)
    val f = new Float(4.3)
    println(f.toString)
    val i = 5
    val j = 10
    val m1 = Math.max(i, j)
    println(Integer.toString(m1, 8))
    val m2 = max(2,5)
    println(m2)

    val bi = BigInt("1000", 8)
    println(bi)
    val b = bi.toString(8)


    error("sys.error")
  }
}

import Foo._

class Foo {
  val bar_object1 = new Bar(this)
  val bar_object2 = new Bar(this)

  def getBar: Bar = {
    bar_object1
  }
}
