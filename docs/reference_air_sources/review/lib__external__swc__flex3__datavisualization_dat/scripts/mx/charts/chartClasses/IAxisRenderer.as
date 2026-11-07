package mx.charts.chartClasses
{
   import flash.geom.Rectangle;
   import mx.core.IUIComponent;
   
   public interface IAxisRenderer extends IUIComponent
   {
      
      function get axis() : IAxis;
      
      function set axis(param1:IAxis) : void;
      
      function chartStateChanged(param1:uint, param2:uint) : void;
      
      function get horizontal() : Boolean;
      
      function get placement() : String;
      
      function set horizontal(param1:Boolean) : void;
      
      function adjustGutters(param1:Rectangle, param2:Object) : Rectangle;
      
      function set otherAxes(param1:Array) : void;
      
      function set heightLimit(param1:Number) : void;
      
      function set gutters(param1:Rectangle) : void;
      
      function set placement(param1:String) : void;
      
      function get heightLimit() : Number;
      
      function get ticks() : Array;
      
      function get gutters() : Rectangle;
      
      function get minorTicks() : Array;
   }
}

