package spark.events
{
   import flash.events.Event;
   import spark.components.gridClasses.CellRegion;
   
   public class GridSelectionEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const SELECTION_CHANGE:String = "selectionChange";
      
      public static const SELECTION_CHANGING:String = "selectionChanging";
      
      public var kind:String;
      
      public var selectionChange:CellRegion;
      
      public function GridSelectionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null, selectionChange:CellRegion = null)
      {
         super(type,bubbles,cancelable);
         this.kind = kind;
         this.selectionChange = selectionChange;
      }
      
      override public function toString() : String
      {
         return formatToString("GridSelectionEvent","type","bubbles","cancelable","eventPhase","kind","selectionChange");
      }
      
      override public function clone() : Event
      {
         return new GridSelectionEvent(type,bubbles,cancelable,this.kind,this.selectionChange);
      }
   }
}

