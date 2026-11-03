package spark.events
{
   import flash.events.Event;
   
   public class LoaderInvalidationEvent extends Event
   {
      
      public static const INVALIDATE_LOADER:String = "invalidateLoader";
      
      public var content:*;
      
      public function LoaderInvalidationEvent(type:String, content:*)
      {
         super(type);
         this.content = content;
      }
      
      override public function clone() : Event
      {
         return new LoaderInvalidationEvent(type,this.content);
      }
   }
}

