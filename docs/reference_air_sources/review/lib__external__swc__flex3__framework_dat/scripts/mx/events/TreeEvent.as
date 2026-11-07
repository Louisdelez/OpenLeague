package mx.events
{
   import flash.events.Event;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TreeEvent extends Event
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public static const ITEM_CLOSE:String = "itemClose";
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      public static const ITEM_OPENING:String = "itemOpening";
      
      public var dispatchEvent:Boolean;
      
      public var animate:Boolean;
      
      public var triggerEvent:Event;
      
      public var itemRenderer:IListItemRenderer;
      
      public var opening:Boolean;
      
      public var item:Object;
      
      public function TreeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, item:Object = null, itemRenderer:IListItemRenderer = null, triggerEvent:Event = null)
      {
         super(type,bubbles,cancelable);
         this.item = item;
         this.itemRenderer = itemRenderer;
         this.triggerEvent = triggerEvent;
      }
      
      override public function clone() : Event
      {
         return new TreeEvent(type,bubbles,cancelable,item,itemRenderer,triggerEvent);
      }
   }
}

