package mx.charts.chartClasses
{
   import flash.utils.Dictionary;
   
   public interface IStackable
   {
      
      function stack(param1:Dictionary, param2:IStackable) : Number;
      
      function set stacker(param1:StackedSeries) : void;
      
      function get stacker() : StackedSeries;
      
      function set stackTotals(param1:Dictionary) : void;
   }
}

