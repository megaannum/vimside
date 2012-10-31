package com.megaanum

object Foo {
  def main(args: Array[String]): Unit = {
    val nameOfBar = Bar.NAME
    println(nameOfBar)
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
