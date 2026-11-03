package mx.olap
{
   public class OLAPResult implements IOLAPResult
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static var COLUMN_AXIS:int = 0;
      
      public static var ROW_AXIS:int = 1;
      
      public static var SLICER_AXIS:int = 2;
      
      private var _axes:Array = [];
      
      private var _query:IOLAPQuery;
      
      protected var cellData:Array = [];
      
      public function OLAPResult()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeRowData(y:int) : void
      {
         cellData.splice(y,1);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setAxis(axisOrdinal:int, axis:IOLAPResultAxis) : void
      {
         axes[axisOrdinal] = axis;
      }
      
      public function hasRowData(rowIndex:int) : Boolean
      {
         return cellData[rowIndex] != undefined;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setCell(x:int, y:int, value:Number) : void
      {
         if(!cellData[x])
         {
            cellData[x] = [];
         }
         cellData[x][y] = value;
      }
      
      public function get query() : IOLAPQuery
      {
         return _query;
      }
      
      public function set query(q:IOLAPQuery) : void
      {
         _query = q;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeColumnData(x:int) : void
      {
         var a:Array = null;
         for each(a in cellData)
         {
            a.splice(x,1);
         }
      }
      
      public function get axes() : Array
      {
         return _axes;
      }
      
      public function getAxis(axisOrdinal:int) : IOLAPResultAxis
      {
         return axes[axisOrdinal];
      }
      
      public function getCell(x:int, y:int) : IOLAPCell
      {
         if(Boolean(cellData[x]))
         {
            return new OLAPCell(cellData[x][y]);
         }
         return new OLAPCell(NaN);
      }
   }
}

