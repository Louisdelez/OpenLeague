package com.riotgames.rust.components
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.components.button.ButtonX;
   import com.riotgames.pvpnet.component.DeprecatedAudioButton;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ViewUtil
   {
      
      public function ViewUtil()
      {
         super();
      }
      
      public function wireButton(param1:DisplayObjectContainerProxy, param2:InstanceMapping, param3:Function) : ButtonX
      {
         var _loc4_:ButtonX = this.makeNewButton(param1);
         param1.setTimelineChild(param2,_loc4_);
         if(param3 != null)
         {
            _loc4_.addEventListener(MouseEvent.CLICK,param3);
         }
         return _loc4_;
      }
      
      protected function makeNewButton(param1:DisplayObjectContainerProxy) : ButtonX
      {
         return new DeprecatedAudioButton(param1);
      }
      
      public function setupComponentOverlay(param1:DisplayObjectContainerProxy, param2:InstanceMapping, param3:DisplayObjectContainer, param4:DisplayObject) : DisplayObjectProxy
      {
         var assetChangedCallback:Function;
         var proxyView:DisplayObjectProxy = null;
         var parentView:DisplayObjectContainerProxy = param1;
         var mapping:InstanceMapping = param2;
         var componentParent:DisplayObjectContainer = param3;
         var component:DisplayObject = param4;
         proxyView = new DisplayObjectProxy(parentView);
         parentView.setTimelineChild(mapping,proxyView);
         assetChangedCallback = function():void
         {
            var _loc1_:Sprite = proxyView.getAsset() as Sprite;
            if(Boolean(_loc1_))
            {
               if(_loc1_.width > 1 && _loc1_.height > 1)
               {
                  component.width = _loc1_.width;
                  component.height = _loc1_.height;
               }
               component.x = _loc1_.x;
               component.y = _loc1_.y;
               _loc1_.visible = false;
               componentParent.addChild(component);
            }
         };
         proxyView.getAssetChanged().add(assetChangedCallback);
         assetChangedCallback();
         return proxyView;
      }
   }
}

