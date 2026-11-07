package org.swizframework.utils.logging
{
   public class AbstractSwizLoggingTarget
   {
      
      private var _filters:Array = ["*"];
      
      private var _level:int = SwizLogEventLevel.ALL;
      
      public function AbstractSwizLoggingTarget()
      {
         super();
      }
      
      public function get filters() : Array
      {
         return this._filters;
      }
      
      public function set filters(value:Array) : void
      {
         this._filters = value;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set level(value:int) : void
      {
         this._level = value;
      }
      
      public function addLogger(logger:SwizLogger) : void
      {
         if(Boolean(logger))
         {
            logger.addEventListener(SwizLogEvent.LOG_EVENT,this.logHandler);
         }
      }
      
      public function removeLogger(logger:SwizLogger) : void
      {
         if(Boolean(logger))
         {
            logger.removeEventListener(SwizLogEvent.LOG_EVENT,this.logHandler);
         }
      }
      
      protected function logEvent(event:SwizLogEvent) : void
      {
      }
      
      protected function logHandler(event:SwizLogEvent) : void
      {
         if(event.level >= this.level)
         {
            this.logEvent(event);
         }
      }
   }
}

