package com.riotgames.rust.context.popup
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import flash.geom.Point;
   
   public class SimplePopupContextBehavior implements IPopupContext
   {
      
      private var target:DisplayObjectContainerProxy;
      
      public function SimplePopupContextBehavior(param1:DisplayObjectContainerProxy)
      {
         super();
         this.target = param1;
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this.target.addChild(param1);
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this.target.removeChild(param1);
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         if(Boolean(param2.getStage()) && Boolean(this.target.getStage()))
         {
            _loc5_ = param2.localToGlobal(new Point(param3,param4));
            _loc6_ = this.target.globalToLocal(_loc5_);
            param1.setX(_loc6_.x);
            param1.setY(_loc6_.y);
         }
      }
   }
}

