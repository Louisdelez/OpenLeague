package flexlib.scheduling.scheduleClasses.lineRenderer
{
   import flash.display.Graphics;
   import mx.graphics.IStroke;
   
   public interface ILineRenderer extends IStroke
   {
      
      function get color() : uint;
      
      function set color(param1:uint) : void;
      
      function moveTo(param1:Graphics, param2:Number, param3:Number) : void;
      
      function set alpha(param1:Number) : void;
      
      function get alpha() : Number;
      
      function drawTo(param1:Graphics, param2:Number, param3:Number) : void;
   }
}

