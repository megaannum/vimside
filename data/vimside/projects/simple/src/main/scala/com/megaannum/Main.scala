package com.megaannum

object Main {
  def doWork(value: Int): Int = {
    var incr = 1
    value + incr
  }
  def main(args: Array[String]): Unit = {
    var cnt = 0
    var total = 0
    while (cnt < 100) {
      Thread.sleep(5);
      total += doWork(total);
    }
  }
}
