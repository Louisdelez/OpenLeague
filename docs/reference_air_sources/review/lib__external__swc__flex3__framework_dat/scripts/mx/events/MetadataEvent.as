package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class MetadataEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const METADATA_RECEIVED:String = "metadataReceived";
      
      public static const CUE_POINT:String = "cuePoint";
      
      mx_internal static const NAVIGATION:String = "navigation";
      
      mx_internal static const EVENT:String = "event";
      
      public static const ACTION_SCRIPT:String = "actionscript";
      
      public var info:Object;
      
      public function MetadataEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, info:Object = null)
      {
         super(type,bubbles,cancelable);
         this.info = info;
      }
      
      override public function clone() : Event
      {
         return new MetadataEvent(type,bubbles,cancelable,info);
      }
   }
}

