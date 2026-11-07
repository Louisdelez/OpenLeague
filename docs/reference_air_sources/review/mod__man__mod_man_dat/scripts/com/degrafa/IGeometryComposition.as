package com.degrafa
{
   import com.degrafa.geometry.command.CommandStack;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   
   public interface IGeometryComposition
   {
      
      function draw(param1:Graphics, param2:Rectangle) : void;
      
      function get bounds() : Rectangle;
      
      function preDraw() : void;
      
      function set commandStack(param1:CommandStack) : void;
      
      function get commandStack() : CommandStack;
      
      function endDraw(param1:Graphics) : void;
   }
}

