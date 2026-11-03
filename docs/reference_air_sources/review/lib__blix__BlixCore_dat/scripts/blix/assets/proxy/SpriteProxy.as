package blix.assets.proxy
{
   import blix.context.IContext;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   
   public class SpriteProxy extends DisplayObjectContainerProxy
   {
      
      protected var _hitArea:SpriteProxy;
      
      protected var _spriteAsset:Sprite;
      
      public function SpriteProxy(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         var _loc2_:Sprite = null;
         super.configureAsset(param1);
         this._spriteAsset = param1 as Sprite;
         if(this._spriteAsset != null)
         {
            if(this._hitArea == null)
            {
               _loc2_ = this._spriteAsset.getChildByName("hitAreaClip") as Sprite;
               if(Boolean(_loc2_))
               {
                  _loc2_.mouseEnabled = false;
                  _loc2_.mouseChildren = false;
                  this._spriteAsset.hitArea = _loc2_;
               }
            }
         }
      }
      
      public function getSpriteAsset() : Sprite
      {
         return this._spriteAsset;
      }
      
      public function startDrag(param1:Boolean = false, param2:Rectangle = null) : void
      {
         if(this._spriteAsset == null)
         {
            addPendingCall("startDrag",[param1,param2]);
            return;
         }
         this._spriteAsset.startDrag(param1,param2);
      }
      
      public function stopDrag() : void
      {
         if(this._spriteAsset == null)
         {
            addPendingCall("stopDrag");
            return;
         }
         this._spriteAsset.stopDrag();
      }
      
      public function getButtonMode() : Boolean
      {
         return assetProxy.buttonMode;
      }
      
      public function setButtonMode(param1:Boolean) : void
      {
         assetProxy.buttonMode = param1;
      }
      
      public function getDropTarget() : DisplayObject
      {
         return assetProxy.dropTarget;
      }
      
      public function getGraphics() : Graphics
      {
         return assetProxy.graphics;
      }
      
      public function getHitArea() : SpriteProxy
      {
         return this._hitArea;
      }
      
      public function setHitArea(param1:SpriteProxy) : void
      {
         if(this._hitArea != null)
         {
            this._hitArea.getAssetChanged().remove(this.hitAreaChangeHandler);
            delete assetProxy.hitArea;
         }
         this._hitArea = param1;
         if(this._hitArea != null)
         {
            this._hitArea.getAssetChanged().add(this.hitAreaChangeHandler);
            if(Boolean(this._hitArea.getAsset()))
            {
               this.hitAreaChangeHandler();
            }
         }
      }
      
      protected function hitAreaChangeHandler() : void
      {
         assetProxy.hitArea = this._hitArea.getAsset();
      }
      
      public function getSoundTransform() : SoundTransform
      {
         return assetProxy.soundTransform;
      }
      
      public function setSoundTransform(param1:SoundTransform) : void
      {
         assetProxy.soundTransform = param1;
      }
      
      public function getUseHandCursor() : Boolean
      {
         return assetProxy.useHandCursor;
      }
      
      public function setUseHandCursor(param1:Boolean) : void
      {
         assetProxy.useHandCursor = param1;
      }
      
      override public function destroy() : void
      {
         if(this._hitArea != null)
         {
            this._hitArea.getAssetChanged().remove(this.hitAreaChangeHandler);
         }
         super.destroy();
      }
   }
}

