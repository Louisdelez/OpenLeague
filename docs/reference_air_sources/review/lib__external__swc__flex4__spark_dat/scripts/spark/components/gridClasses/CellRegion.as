package spark.components.gridClasses
{
   public class CellRegion
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _columnCount:int;
      
      private var _columnIndex:int;
      
      private var _rowCount:int;
      
      private var _rowIndex:int;
      
      public function CellRegion(rowIndex:int = -1, columnIndex:int = -1, rowCount:int = 0, columnCount:int = 0)
      {
         super();
         this._rowIndex = rowIndex;
         this._columnIndex = columnIndex;
         this._rowCount = rowCount;
         this._columnCount = columnCount;
      }
      
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      public function set columnCount(value:int) : void
      {
         this._columnCount = value;
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function set columnIndex(value:int) : void
      {
         this._columnIndex = value;
      }
      
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      public function set rowCount(value:int) : void
      {
         this._rowCount = value;
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
         return "[rowIndex=" + this.rowIndex + " columnIndex=" + this.columnIndex + " rowCount=" + this.rowCount + " columnCount=" + this.columnCount + "]";
      }
   }
}

