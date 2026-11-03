package mx.olap
{
   [DefaultProperty("axes")]
   public class OLAPQuery implements IOLAPQuery
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static var COLUMN_AXIS:int = 0;
      
      public static var ROW_AXIS:int = 1;
      
      public static var SLICER_AXIS:int = 2;
      
      private var _axes:Array = [new OLAPQueryAxis(0),new OLAPQueryAxis(1),new OLAPQueryAxis(2)];
      
      public function OLAPQuery()
      {
         super();
      }
      
      public function setAxis(axisOrdinal:int, axis:IOLAPQueryAxis) : void
      {
         switch(axisOrdinal)
         {
            case COLUMN_AXIS:
            case ROW_AXIS:
            case SLICER_AXIS:
               axes[axisOrdinal] = axis;
         }
      }
      
      public function get axes() : Array
      {
         return _axes;
      }
      
      public function set axes(value:Array) : void
      {
         _axes = value;
      }
      
      public function getAxis(axisOrdinal:int) : IOLAPQueryAxis
      {
         switch(axisOrdinal)
         {
            case COLUMN_AXIS:
            case ROW_AXIS:
            case SLICER_AXIS:
               return axes[axisOrdinal];
            default:
               return null;
         }
      }
   }
}

