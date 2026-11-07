package com.riotgames.platform.common.components
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import mx.core.ClassFactory;
   import mx.core.IDataRenderer;
   
   public class RendererCache
   {
      
      protected var generator:Class;
      
      protected var _itemRenderer:ClassFactory;
      
      protected var availableRenderers:Array = [];
      
      public function RendererCache()
      {
         super();
      }
      
      public function cacheRenderer(param1:IDataRenderer) : void
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Class = getDefinitionByName(_loc2_) as Class;
         if(Boolean(this.generator) && this.generator == _loc3_)
         {
            this.availableRenderers.push(param1);
         }
      }
      
      public function getRenderer() : IDataRenderer
      {
         if(this.availableRenderers.length > 0)
         {
            return this.availableRenderers.pop();
         }
         if(Boolean(this.itemRenderer))
         {
            return this.itemRenderer.newInstance();
         }
         return null;
      }
      
      public function set itemRenderer(param1:ClassFactory) : void
      {
         this._itemRenderer = param1;
         if(Boolean(this._itemRenderer))
         {
            this.generator = this._itemRenderer.generator;
         }
         else
         {
            this.generator = null;
         }
         this.availableRenderers = [];
      }
      
      public function get itemRenderer() : ClassFactory
      {
         return this._itemRenderer;
      }
   }
}

