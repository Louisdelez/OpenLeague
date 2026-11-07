package mx.events
{
   import flash.events.Event;
   
   public class MetadataEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const METADATA_RECEIVED:String = "metadataReceived";
      
      public static const CUE_POINT:String = "cuePoint";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const NAVIGATION:String = "navigation";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const EVENT:String = "event";
      
      public static const ACTION_SCRIPT:String = "actionscript";
      
      public var info:Object;
      
      public function MetadataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, info:Object = null)
      {
         super(type,bubbles,cancelable);
         this.info = info;
      }
      
      override public function clone() : Event
      {
         return new MetadataEvent(type,bubbles,cancelable,this.info);
      }
   }
}

