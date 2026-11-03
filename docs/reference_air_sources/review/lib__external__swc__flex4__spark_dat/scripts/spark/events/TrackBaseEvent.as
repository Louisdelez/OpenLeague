package spark.events
{
   import flash.events.Event;
   
   public class TrackBaseEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const THUMB_DRAG:String = "thumbDrag";
      
      public static const THUMB_PRESS:String = "thumbPress";
      
      public static const THUMB_RELEASE:String = "thumbRelease";
      
      public function TrackBaseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new TrackBaseEvent(type,bubbles,cancelable);
      }
   }
}

