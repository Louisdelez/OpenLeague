package mx.events
{
   import flash.events.Event;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class AdvancedDataGridEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const ITEM_CLOSE:String = "itemClose";
      
      public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";
      
      public static const ITEM_EDIT_END:String = "itemEditEnd";
      
      public static const ITEM_FOCUS_IN:String = "itemFocusIn";
      
      public static const ITEM_FOCUS_OUT:String = "itemFocusOut";
      
      public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";
      
      public static const ITEM_OPEN:String = "itemOpen";
      
      public static const ITEM_OPENING:String = "itemOpening";
      
      public static const COLUMN_STRETCH:String = "columnStretch";
      
      public static const HEADER_DRAG_OUTSIDE:String = "headerDragOutside";
      
      public static const HEADER_DROP_OUTSIDE:String = "headerDropOutside";
      
      public static const HEADER_RELEASE:String = "headerRelease";
      
      public static const SORT:String = "sort";
      
      public var dispatchEvent:Boolean;
      
      public var removeColumnFromSort:Boolean;
      
      public var reason:String;
      
      public var localX:Number;
      
      public var triggerEvent:Event;
      
      public var item:Object;
      
      public var column:AdvancedDataGridColumn;
      
      public var rowIndex:int;
      
      public var columnIndex:int;
      
      public var opening:Boolean;
      
      public var animate:Boolean;
      
      public var headerPart:String;
      
      public var multiColumnSort:Boolean;
      
      public var dataField:String;
      
      public var itemRenderer:IListItemRenderer;
      
      public function AdvancedDataGridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, columnIndex:int = -1, dataField:String = null, rowIndex:int = -1, reason:String = null, itemRenderer:IListItemRenderer = null, localX:Number = NaN, multiColumnSort:Boolean = false, removeColumnFromSort:Boolean = false, item:Object = null, triggerEvent:Event = null, headerPart:String = null)
      {
         super(type,bubbles,cancelable);
         this.columnIndex = columnIndex;
         this.dataField = dataField;
         this.rowIndex = rowIndex;
         this.reason = reason;
         this.itemRenderer = itemRenderer;
         this.localX = localX;
         this.multiColumnSort = multiColumnSort;
         this.removeColumnFromSort = removeColumnFromSort;
         this.item = item;
         this.triggerEvent = triggerEvent;
         this.headerPart = headerPart;
      }
      
      override public function clone() : Event
      {
         return new AdvancedDataGridEvent(type,bubbles,cancelable,columnIndex,dataField,rowIndex,reason,itemRenderer,localX,multiColumnSort,removeColumnFromSort,item,triggerEvent,headerPart);
      }
   }
}

