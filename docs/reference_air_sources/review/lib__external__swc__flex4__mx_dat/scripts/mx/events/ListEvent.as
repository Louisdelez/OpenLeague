package mx.events
{
   import flash.events.Event;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class ListEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const CHANGE:String = "change";
      
      public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";
      
      public static const ITEM_EDIT_END:String = "itemEditEnd";
      
      public static const ITEM_FOCUS_IN:String = "itemFocusIn";
      
      public static const ITEM_FOCUS_OUT:String = "itemFocusOut";
      
      public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public static const ITEM_DOUBLE_CLICK:String = "itemDoubleClick";
      
      public static const ITEM_ROLL_OUT:String = "itemRollOut";
      
      public static const ITEM_ROLL_OVER:String = "itemRollOver";
      
      public var columnIndex:int;
      
      public var itemRenderer:IListItemRenderer;
      
      public var reason:String;
      
      public var rowIndex:int;
      
      public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, columnIndex:int = -1, rowIndex:int = -1, reason:String = null, itemRenderer:IListItemRenderer = null)
      {
         super(type,bubbles,cancelable);
         this.columnIndex = columnIndex;
         this.rowIndex = rowIndex;
         this.reason = reason;
         this.itemRenderer = itemRenderer;
      }
      
      override public function clone() : Event
      {
         return new ListEvent(type,bubbles,cancelable,this.columnIndex,this.rowIndex,this.reason,this.itemRenderer);
      }
   }
}

