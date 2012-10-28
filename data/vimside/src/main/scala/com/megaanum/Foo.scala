package com.megaanum

object Foo {
  def main(args: Array[String]): Unit = {
    val name = Bar.NAME
    println(name)
  }
}

import Foo._

class Foo {
  val bar = new Bar(this)

  def getBar: Bar = {
    bar
  }
}
