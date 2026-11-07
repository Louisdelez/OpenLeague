package com.degrafa.core.collections
{
   import com.degrafa.core.IGraphicsStroke;
   
   public class StrokeCollection extends DegrafaCollection
   {
      
      public function StrokeCollection(param1:Array = null, param2:Boolean = false)
      {
         super(IGraphicsStroke,param1,param2);
      }
      
      public function addItem(param1:IGraphicsStroke) : IGraphicsStroke
      {
         return super._addItem(param1);
      }
      
      public function addItemAt(param1:IGraphicsStroke, param2:Number) : IGraphicsStroke
      {
         return super._addItemAt(param1,param2);
      }
      
      public function getItemIndex(param1:IGraphicsStroke) : int
      {
         return super._getItemIndex(param1);
      }
      
      public function removeItemAt(param1:Number) : IGraphicsStroke
      {
         return super._removeItemAt(param1);
      }
      
      public function getItemAt(param1:Number) : IGraphicsStroke
      {
         return super._getItemAt(param1);
      }
      
      public function setItemIndex(param1:IGraphicsStroke, param2:Number) : Boolean
      {
         return super._setItemIndex(param1,param2);
      }
      
      public function removeItem(param1:IGraphicsStroke) : IGraphicsStroke
      {
         return super._removeItem(param1);
      }
      
      public function addItems(param1:StrokeCollection) : StrokeCollection
      {
         super.concat(param1.items);
         return this;
      }
   }
}

