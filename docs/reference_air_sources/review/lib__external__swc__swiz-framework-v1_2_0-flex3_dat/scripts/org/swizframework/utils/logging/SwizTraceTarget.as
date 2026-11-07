package org.swizframework.utils.logging
{
   public class SwizTraceTarget extends AbstractSwizLoggingTarget
   {
      
      public function SwizTraceTarget()
      {
         super();
      }
      
      override protected function logEvent(event:SwizLogEvent) : void
      {
         this.traceMessage(event.message);
      }
      
      private function traceMessage(message:String) : void
      {
         trace(message);
      }
   }
}

