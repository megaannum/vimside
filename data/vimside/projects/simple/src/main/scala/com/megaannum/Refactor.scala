package com.megaannum

// see http://scala-refactoring.org/organize-imports/

import java.lang.String
import collection.mutable.ListBuffer
import java.lang._
import collection.mutable.{HashMap => HMap}
import java.lang.Object

object A

// we also need io:
import java.io._

object B

// 
// Examples from http://scala-refactoring.org/
// Not all refactoring features behave the same.
// 
object Refactor {

  object OrganizeImports {
    val lb = new ListBuffer[Int]
    val map = new HMap[String, Int]
    val f = new File("XXX")
  }

  object Rename {
  
    // Place cursor on message and invoke 'Rename'
    // see http://scala-refactoring.org/rename/
    def helloworld {
      var message = Nil: List[String]
      message ::= "Hello"
      message ::= "World"

      println(message.size)
      println(message.mkString(" "))
    }
  }
  class Rename {

    // Place cursor on msg and invoke 'Rename'
    // see http://scala-refactoring.org/rename/
    def helloworld {
      val msg = List("Hello", "World")
      println(msg.mkString(" "))
    }
  }

  object ExtractLocal {
    // Either visually select Syte....ux" and invoke 'ExtractLocal'
    // or place cursor within expression, invoke 'ExpandSelection'
    // and then invoke 'ExtractLocal'
    // see http://scala-refactoring.org/extract-local/
    def main(args: Array[String]): Unit = {
      println("Detecting OS...")

      if (System.getProperties.get("os.name") == "Linux") {
        println("We're on Linux")
      } else {
        println("We're not on Linux")
      }
    }
  }
  object InlineLocal {
    // http://scala-refactoring.org/inline-local/
    def main(args: Array[String]): Unit = {
      args toList match {
        case x :: Nil =>
          val x = "one argument"
          println(x)
        case _ =>
          println("more than one arguament")
      }
    }
  }
  object ExtractMethod {
    // see http://scala-refactoring.org/extract-method/
    val name = "Mirko"
    def printBanner() = {}
    def printOwing(amount: Double) {
      printBanner()

      // print details
      print("name:   " + name)
      print("amount: " + amount)
    }
  }
}

