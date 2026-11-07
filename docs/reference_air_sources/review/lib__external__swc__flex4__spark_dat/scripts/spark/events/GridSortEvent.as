package spark.events
{
   import flash.events.Event;
   
   public class GridSortEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const SORT_CHANGE:String = "sortChange";
      
      public static const SORT_CHANGING:String = "sortChanging";
      
      public var columnIndices:Vector.<int>;
      
      public var newSortFields:Array;
      
      private var _oldSortFields:Array;
      
      public function GridSortEvent(type:String, bubbles:Boolean, cancelable:Boolean, columnIndices:Vector.<int>, oldSortFields:Array, newSortFields:Array)
      {
         super(type,bubbles,cancelable);
         this.columnIndices = Boolean(columnIndices) ? columnIndices.concat() : null;
         this._oldSortFields = Boolean(oldSortFields) ? oldSortFields.concat() : null;
         this.newSortFields = Boolean(newSortFields) ? newSortFields.concat() : null;
      }
      
      public function get oldSortFields() : Array
      {
         return this._oldSortFields;
      }
      
      override public function toString() : String
      {
         return formatToString("GridSortEvent","type","bubbles","cancelable","eventPhase","columnIndices");
      }
      
      override public function clone() : Event
      {
         return new GridSortEvent(type,bubbles,cancelable,this.columnIndices,this.oldSortFields,this.newSortFields);
      }
   }
}

