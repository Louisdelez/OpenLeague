package com.degrafa.core
{
   import com.degrafa.IGraphic;
   import com.degrafa.core.collections.GeometryCollection;
   
   public interface IGraphicSkin extends IGraphic
   {
      
      function get geometryCollection() : GeometryCollection;
      
      function get geometry() : Array;
      
      function set geometry(param1:Array) : void;
      
      function invalidateDisplayList() : void;
   }
}

