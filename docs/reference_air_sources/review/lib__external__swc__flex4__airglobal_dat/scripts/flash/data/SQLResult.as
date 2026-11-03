package flash.data
{
   [API("661")]
   public class SQLResult
   {
      
      private var _rowID:Number;
      
      private var _rowsAffected:uint;
      
      private var _data:Array;
      
      private var _complete:Boolean;
      
      public function SQLResult(data:Array = null, rowsAffected:Number = 0, complete:Boolean = true, rowID:Number = 0)
      {
         super();
         this._data = data;
         this._rowsAffected = rowsAffected;
         this._complete = complete;
         this._rowID = rowID;
      }
      
      public function get complete() : Boolean
      {
         return this._complete;
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function get rowsAffected() : Number
      {
         return this._rowsAffected;
      }
      
      public function get lastInsertRowID() : Number
      {
         return this._rowID;
      }
   }
}

