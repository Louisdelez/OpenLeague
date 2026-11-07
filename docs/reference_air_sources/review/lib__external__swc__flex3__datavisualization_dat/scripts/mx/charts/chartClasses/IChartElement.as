package mx.charts.chartClasses
{
   import flash.display.Sprite;
   import mx.core.IFlexDisplayObject;
   
   public interface IChartElement extends IFlexDisplayObject
   {
      
      function chartStateChanged(param1:uint, param2:uint) : void;
      
      function set chartDataProvider(param1:Object) : void;
      
      function set dataTransform(param1:DataTransform) : void;
      
      function findDataPoints(param1:Number, param2:Number, param3:Number) : Array;
      
      function mappingChanged() : void;
      
      function collectTransitions(param1:Number, param2:Array) : void;
      
      function describeData(param1:String, param2:uint) : Array;
      
      function get labelContainer() : Sprite;
      
      function claimStyles(param1:Array, param2:uint) : uint;
   }
}

