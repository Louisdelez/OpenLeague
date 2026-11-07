package com.riotgames.rust.components
{
   import blix.assets.proxy.DisplayObjectProxy;
   import com.riotgames.rust.context.RustContext;
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   
   public class FlashFlexComponent extends UIComponent
   {
      
      protected var _view:DisplayObjectProxy;
      
      protected var _context:RustContext;
      
      private var assetName:String;
      
      private var oldAsset:DisplayObject;
      
      public function FlashFlexComponent(param1:RustContext, param2:String)
      {
         super();
         this.assetName = param2;
         this._context = param1;
         this._view = this.createView();
         this._view.setLinkage(param2);
         this._view.getAssetChanged().add(this.refreshAsset);
         this.refreshAsset();
      }
      
      protected function createView() : DisplayObjectProxy
      {
         return new DisplayObjectProxy(this._context);
      }
      
      private function refreshAsset() : void
      {
         var _loc1_:DisplayObject = this._view.getAsset();
         if(this.oldAsset != null && this.oldAsset.parent == this)
         {
            this.removeChild(this.oldAsset);
         }
         if(_loc1_ != null)
         {
            this.addChild(_loc1_);
         }
         this.oldAsset = _loc1_;
      }
   }
}

