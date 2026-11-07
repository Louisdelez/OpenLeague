package org.swizframework.utils.logging
{
   import flash.events.Event;
   
   public class SwizLogEvent extends Event
   {
      
      public static const LOG_EVENT:String = "log";
      
      public var message:String;
      
      public var level:int;
      
      public function SwizLogEvent(message:String, level:int)
      {
         super(LOG_EVENT,true,true);
         this.message = message;
         this.level = level;
      }
      
      override public function clone() : Event
      {
         return new SwizLogEvent(this.message,this.level);
      }
   }
}

