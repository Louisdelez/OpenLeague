package com.degrafa.geometry.layout
{
   import com.degrafa.core.IDegrafaObject;
   import flash.geom.Rectangle;
   
   public interface ILayout extends IDegrafaObject
   {
      
      function get layoutRectangle() : Rectangle;
      
      function computeLayoutRectangle(param1:Rectangle, param2:Rectangle) : Rectangle;
   }
}

