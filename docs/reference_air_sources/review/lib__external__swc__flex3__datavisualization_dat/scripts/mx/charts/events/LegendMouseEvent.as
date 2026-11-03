package mx.charts.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.charts.LegendItem;
   
   public class LegendMouseEvent extends MouseEvent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const ITEM_MOUSE_DOWN:String = "itemMouseDown";
      
      public static const ITEM_MOUSE_UP:String = "itemMouseUp";
      
      public static const ITEM_MOUSE_OUT:String = "itemMouseOut";
      
      public static const ITEM_MOUSE_OVER:String = "itemMouseOver";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      [Inspectable(environment="none")]
      public var item:LegendItem;
      
      public function LegendMouseEvent(type:String, triggerEvent:MouseEvent = null, item:LegendItem = null)
      {
         var eventType:String = convertType(type);
         var bubbles:Boolean = true;
         var cancelable:Boolean = false;
         var localX:int = 0;
         var localY:int = 0;
         var relatedObject:InteractiveObject = null;
         var ctrlKey:Boolean = false;
         var shiftKey:Boolean = false;
         var altKey:Boolean = false;
         var buttonDown:Boolean = false;
         var delta:int = 0;
         if(Boolean(triggerEvent))
         {
            bubbles = triggerEvent.bubbles;
            cancelable = triggerEvent.cancelable;
            localX = triggerEvent.localX;
            localY = triggerEvent.localY;
            relatedObject = triggerEvent.relatedObject;
            ctrlKey = triggerEvent.ctrlKey;
            altKey = triggerEvent.altKey;
            shiftKey = triggerEvent.shiftKey;
            buttonDown = triggerEvent.buttonDown;
            delta = triggerEvent.delta;
         }
         super(eventType,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
         this.item = item;
      }
      
      private static function convertType(baseType:String) : String
      {
         switch(baseType)
         {
            case MouseEvent.CLICK:
               return ITEM_CLICK;
            case MouseEvent.MOUSE_DOWN:
               return ITEM_MOUSE_DOWN;
            case MouseEvent.MOUSE_UP:
               return ITEM_MOUSE_UP;
            case MouseEvent.MOUSE_OVER:
               return ITEM_MOUSE_OVER;
            case MouseEvent.MOUSE_OUT:
               return ITEM_MOUSE_OUT;
            default:
               return baseType;
         }
      }
      
      override public function clone() : Event
      {
         return new LegendMouseEvent(type,this,item);
      }
   }
}

