package flash.events
{
   [API("661")]
   public class SQLUpdateEvent extends Event
   {
      
      public static const UPDATE:String = "update";
      
      public static const INSERT:String = "insert";
      
      public static const DELETE:String = "delete";
      
      private var _kind:String;
      
      private var _rowID:Number;
      
      private var _table:String;
      
      public function SQLUpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, table:String = null, rowID:Number = 0)
      {
         super(type,bubbles,cancelable);
         this._table = table;
         this._rowID = rowID;
      }
      
      public function get table() : String
      {
         return this._table;
      }
      
      public function get rowID() : Number
      {
         return this._rowID;
      }
      
      override public function clone() : Event
      {
         return new SQLUpdateEvent(type,bubbles,cancelable,this.table,this.rowID);
      }
   }
}

