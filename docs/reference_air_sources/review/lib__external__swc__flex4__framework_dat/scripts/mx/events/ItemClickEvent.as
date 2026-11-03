package mx.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class ItemClickEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public var index:int;
      
      public var item:Object;
      
      public var label:String;
      
      public var relatedObject:InteractiveObject;
      
      public function ItemClickEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, label:String = null, index:int = -1, relatedObject:InteractiveObject = null, item:Object = null)
      {
         super(type,bubbles,cancelable);
         this.label = label;
         this.index = index;
         this.relatedObject = relatedObject;
         this.item = item;
      }
      
      override public function clone() : Event
      {
         return new ItemClickEvent(type,bubbles,cancelable,this.label,this.index,this.relatedObject,this.item);
      }
   }
}

