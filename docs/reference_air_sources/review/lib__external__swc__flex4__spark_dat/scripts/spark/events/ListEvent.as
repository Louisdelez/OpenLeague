package spark.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import spark.components.IItemRenderer;
   
   public class ListEvent extends MouseEvent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public var item:Object;
      
      public var itemRenderer:IItemRenderer;
      
      public var itemIndex:int;
      
      public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, itemIndex:int = -1, item:Object = null, itemRenderer:IItemRenderer = null)
      {
         super(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
         this.itemIndex = itemIndex;
         this.item = item;
         this.itemRenderer = itemRenderer;
      }
      
      override public function clone() : Event
      {
         var cloneEvent:ListEvent = new ListEvent(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta,this.itemIndex,this.item,this.itemRenderer);
         cloneEvent.relatedObject = this.relatedObject;
         return cloneEvent;
      }
   }
}

