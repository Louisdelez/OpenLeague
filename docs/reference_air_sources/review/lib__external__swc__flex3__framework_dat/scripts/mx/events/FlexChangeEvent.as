package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class FlexChangeEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const ADD_CHILD_BRIDGE:String = "addChildBridge";
      
      public static const REMOVE_CHILD_BRIDGE:String = "removeChildBridge";
      
      public var data:Object;
      
      public function FlexChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new FlexChangeEvent(type,bubbles,cancelable,data);
      }
   }
}

