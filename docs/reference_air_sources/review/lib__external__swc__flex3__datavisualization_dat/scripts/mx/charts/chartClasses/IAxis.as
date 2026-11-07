package mx.charts.chartClasses
{
   import flash.events.IEventDispatcher;
   import mx.charts.AxisLabel;
   
   public interface IAxis extends IEventDispatcher
   {
      
      function get baseline() : Number;
      
      function mapCache(param1:Array, param2:String, param3:String, param4:Boolean = false) : void;
      
      function reduceLabels(param1:AxisLabel, param2:AxisLabel) : AxisLabelSet;
      
      function unregisterDataTransform(param1:DataTransform) : void;
      
      function update() : void;
      
      function filterCache(param1:Array, param2:String, param3:String) : void;
      
      function get unitSize() : Number;
      
      function preferDropLabels() : Boolean;
      
      function dataChanged() : void;
      
      function set chartDataProvider(param1:Object) : void;
      
      function get displayName() : String;
      
      function getLabelEstimate() : AxisLabelSet;
      
      function invertTransform(param1:Number) : Object;
      
      function get title() : String;
      
      function getLabels(param1:Number) : AxisLabelSet;
      
      function transformCache(param1:Array, param2:String, param3:String) : void;
      
      function formatForScreen(param1:Object) : String;
      
      function registerDataTransform(param1:DataTransform, param2:String) : void;
   }
}

