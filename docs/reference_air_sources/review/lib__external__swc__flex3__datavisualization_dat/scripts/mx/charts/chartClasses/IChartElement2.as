package mx.charts.chartClasses
{
   import flash.geom.Point;
   
   public interface IChartElement2 extends IChartElement
   {
      
      function localToData(param1:Point) : Array;
      
      function dataToLocal(... rest) : Point;
      
      function getAllDataPoints() : Array;
   }
}

