package com.degrafa.core.collections
{
   import com.degrafa.IGeometry;
   
   public class GeometryCollection extends DegrafaCollection
   {
      
      public function GeometryCollection(param1:Array = null, param2:Boolean = false)
      {
         super(IGeometry,param1,param2);
      }
      
      public function addItem(param1:IGeometry) : IGeometry
      {
         return super._addItem(param1);
      }
      
      public function addItemAt(param1:IGeometry, param2:Number) : IGeometry
      {
         return super._addItemAt(param1,param2);
      }
      
      public function getItemIndex(param1:IGeometry) : int
      {
         return super._getItemIndex(param1);
      }
      
      public function removeItemAt(param1:Number) : IGeometry
      {
         return super._removeItemAt(param1);
      }
      
      public function getItemAt(param1:Number) : IGeometry
      {
         return super._getItemAt(param1);
      }
      
      public function setItemIndex(param1:IGeometry, param2:Number) : Boolean
      {
         return super._setItemIndex(param1,param2);
      }
      
      public function removeItem(param1:IGeometry) : IGeometry
      {
         return super._removeItem(param1);
      }
      
      public function addItems(param1:GeometryCollection) : GeometryCollection
      {
         super.concat(param1.items);
         return this;
      }
   }
}

