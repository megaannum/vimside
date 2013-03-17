package com.megaannum

object Bar {
  def main(args: Array[String]): Unit = {
  }

  private var id = 0

  def nextId: Int = {
    val nid = id
    id += 1
    nid
  }

  val NAME = "MY NAME"
}

import Bar._

class Bar(val foo: Foo) {
  val id = nextId
}
