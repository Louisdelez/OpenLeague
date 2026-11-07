package mx.graphics
{
   import flash.display.Graphics;
   
   public interface IStroke
   {
      
      function get weight() : Number;
      
      function apply(param1:Graphics) : void;
      
      function set weight(param1:Number) : void;
   }
}

