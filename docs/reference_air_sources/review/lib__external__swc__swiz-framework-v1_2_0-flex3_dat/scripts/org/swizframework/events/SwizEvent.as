package org.swizframework.events
{
   import flash.events.Event;
   import org.swizframework.core.ISwiz;
   
   public class SwizEvent extends Event
   {
      
      public static const CREATED:String = "swizCreated";
      
      public static const LOAD_COMPLETE:String = "loadComplete";
      
      public static const DESTROYED:String = "swizDestroyed";
      
      public var swiz:ISwiz;
      
      public function SwizEvent(type:String, swiz:ISwiz = null)
      {
         super(type,true,true);
         this.swiz = swiz;
      }
      
      override public function clone() : Event
      {
         return new SwizEvent(type,this.swiz);
      }
   }
}

