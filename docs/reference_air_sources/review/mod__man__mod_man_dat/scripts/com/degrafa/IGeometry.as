package com.degrafa
{
   import com.degrafa.core.IGraphicsFill;
   import com.degrafa.core.IGraphicsStroke;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   
   public interface IGeometry
   {
      
      function set stroke(param1:IGraphicsStroke) : void;
      
      function get fill() : IGraphicsFill;
      
      function draw(param1:Graphics, param2:Rectangle) : void;
      
      function set fill(param1:IGraphicsFill) : void;
      
      function get stroke() : IGraphicsStroke;
      
      function get data() : Object;
      
      function set data(param1:Object) : void;
      
      function endDraw(param1:Graphics) : void;
   }
}

