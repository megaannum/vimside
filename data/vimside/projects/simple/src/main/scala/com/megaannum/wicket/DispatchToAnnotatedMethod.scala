package com.megaannum.wicket

object DispatchToAnnotatedMethod {
  def main(args: Array[String]): Unit = {
  }
}

import DispatchToAnnotatedMethod._

class DispatchToAnnotatedMethod {
  def dispatchEvent(sink: Any,
                    event: IEvent[_],
                    component: Component[_]): Unit = {
    var sinkMethods = sink.getClass.getMethods
    for (sinkMethod <- sinkMethods) {
      if (sinkMethod.isAnnotationPresent(classOf[EventCallback])) {
        try {
          sinkMethod.invoke(sink)
        } catch {
          case e: Exception =>
            throw new RuntimeException(e)
        }
      }
    }
  }
}
