package com.riotgames.platform.gameclient.module.rt.view.stats
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.rust.context.popup.IPopupContext;
   import com.riotgames.rust.context.popup.SimplePopupContextBehavior;
   import flash.display.MovieClip;
   
   public class StatefulViewWithPopupManagement extends StatefulView implements IPopupContext
   {
      
      private var popupBehavior:SimplePopupContextBehavior;
      
      public function StatefulViewWithPopupManagement(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this.popupBehavior = new SimplePopupContextBehavior(this);
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.removePopup(param1);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         this.popupBehavior.setPosition(param1,param2,param3,param4);
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.addPopup(param1);
      }
   }
}

