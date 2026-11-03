package com.riotgames.platform.common.components
{
   import flash.utils.Dictionary;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   import mx.core.UIComponent;
   
   public class RendererDelegate
   {
      
      protected var rendererCache:RendererCache = new RendererCache();
      
      public var renderers:Dictionary = new Dictionary();
      
      public function RendererDelegate()
      {
         super();
      }
      
      public function getRendererForItem(param1:Object) : IDataRenderer
      {
         return this.renderers[param1];
      }
      
      public function destroyRenderers(param1:UIComponent, param2:IList) : void
      {
         var _loc3_:IDataRenderer = null;
         for each(_loc3_ in this.renderers)
         {
            this.rendererCache.cacheRenderer(_loc3_);
         }
         this.renderers = new Dictionary();
         if(!param1)
         {
            return;
         }
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public function addRenderers(param1:UIComponent, param2:IList) : void
      {
         var _loc3_:Object = null;
         if(!param1)
         {
            return;
         }
         for each(_loc3_ in param2)
         {
            if(Boolean(this.renderers[_loc3_]))
            {
               param1.addChild(this.renderers[_loc3_]);
            }
         }
      }
      
      public function set itemRenderer(param1:ClassFactory) : void
      {
         this.rendererCache.itemRenderer = param1;
      }
      
      public function deleteRendererForItem(param1:Object) : void
      {
         delete this.renderers[param1];
      }
      
      public function setRendererData(param1:IList) : void
      {
         var _loc2_:Object = null;
         var _loc3_:IDataRenderer = null;
         var _loc4_:int = 0;
         if(!param1 || param1.length == 0)
         {
            return;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1.getItemAt(_loc4_);
            if(Boolean(this.renderers[_loc2_]))
            {
               _loc3_ = this.renderers[_loc2_];
               _loc3_.data = _loc2_;
            }
            _loc4_++;
         }
      }
      
      public function associateDataWithRenderer(param1:Object, param2:Object) : void
      {
         this.renderers[param1] = param2;
      }
      
      public function createRenderers(param1:IList) : void
      {
         var _loc2_:Object = null;
         var _loc3_:IDataRenderer = null;
         this.renderers = new Dictionary();
         for each(_loc2_ in param1)
         {
            _loc3_ = this.createRenderer();
            if(Boolean(_loc3_))
            {
               this.renderers[_loc2_] = _loc3_;
            }
         }
      }
      
      public function rebuildRenderers(param1:IList, param2:UIComponent) : void
      {
         this.destroyRenderers(param2,param1);
         this.createRenderers(param1);
         this.addRenderers(param2,param1);
         this.setRendererData(param1);
      }
      
      public function get itemRenderer() : ClassFactory
      {
         return this.rendererCache.itemRenderer;
      }
      
      public function recycleRenderer(param1:IDataRenderer) : void
      {
         this.rendererCache.cacheRenderer(param1);
      }
      
      public function createRenderer() : IDataRenderer
      {
         if(Boolean(this.itemRenderer))
         {
            return this.rendererCache.getRenderer();
         }
         return null;
      }
   }
}

