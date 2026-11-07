package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SliderEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const CHANGE:String = "change";
      
      public static const THUMB_DRAG:String = "thumbDrag";
      
      public static const THUMB_PRESS:String = "thumbPress";
      
      public static const THUMB_RELEASE:String = "thumbRelease";
      
      public var value:Number;
      
      public var triggerEvent:Event;
      
      public var clickTarget:String;
      
      public var thumbIndex:int;
      
      public var keyCode:int;
      
      public function SliderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, thumbIndex:int = -1, value:Number = NaN, triggerEvent:Event = null, clickTarget:String = null, keyCode:int = -1)
      {
         super(type,bubbles,cancelable);
         this.thumbIndex = thumbIndex;
         this.value = value;
         this.triggerEvent = triggerEvent;
         this.clickTarget = clickTarget;
         this.keyCode = keyCode;
      }
      
      override public function clone() : Event
      {
         return new SliderEvent(type,bubbles,cancelable,thumbIndex,value,triggerEvent,clickTarget,keyCode);
      }
   }
}

