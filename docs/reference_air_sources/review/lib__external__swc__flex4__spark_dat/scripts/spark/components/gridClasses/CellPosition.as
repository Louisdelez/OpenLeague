package spark.components.gridClasses
{
   public class CellPosition
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _columnIndex:int;
      
      private var _rowIndex:int;
      
      public function CellPosition(rowIndex:int = -1, columnIndex:int = -1)
      {
         super();
         this._rowIndex = rowIndex;
         this._columnIndex = columnIndex;
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function set columnIndex(value:int) : void
      {
         this._columnIndex = value;
      }
      
      public function get rowIndex() : int
      {
         return this._rowIndex;
      }
      
      public function set rowIndex(value:int) : void
      {
         this._rowIndex = value;
      }
      
      public function toString() : String
      {
         return "[rowIndex=" + this.rowIndex + " columnIndex=" + this.columnIndex + "]";
      }
   }
}

