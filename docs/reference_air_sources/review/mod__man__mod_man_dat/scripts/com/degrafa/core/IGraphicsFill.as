package com.degrafa.core
{
   import com.degrafa.IGeometryComposition;
   import flash.geom.Rectangle;
   import mx.graphics.IFill;
   
   public interface IGraphicsFill extends IDegrafaObject, IFill
   {
      
      function set requester(param1:IGeometryComposition) : void;
      
      function get lastRectangle() : Rectangle;
      
      function get lastArgs() : Array;
      
      function get restartFunction() : Function;
   }
}

