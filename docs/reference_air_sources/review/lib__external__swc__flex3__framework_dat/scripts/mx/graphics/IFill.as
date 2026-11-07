package mx.graphics
{
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   
   public interface IFill
   {
      
      function begin(param1:Graphics, param2:Rectangle) : void;
      
      function end(param1:Graphics) : void;
   }
}

