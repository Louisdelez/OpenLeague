package mx.events
{
   import flash.events.Event;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class TreeEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const ITEM_CLOSE:String = "itemClose";
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      public static const ITEM_OPENING:String = "itemOpening";
      
      public var animate:Boolean;
      
      public var dispatchEvent:Boolean;
      
      public var item:Object;
      
      public var itemRenderer:IListItemRenderer;
      
      public var opening:Boolean;
      
      public var triggerEvent:Event;
      
      public function TreeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, item:Object = null, itemRenderer:IListItemRenderer = null, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.item = item;
         this.itemRenderer = itemRenderer;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new TreeEvent(type,bubbles,cancelable,this.item,this.itemRenderer,this.triggerEvent);
      }
   }
}

