package com.riotgames.pvpnet.CLS.views.helpers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import flash.display.MovieClip;
   
   public class MenuSelectorButton extends ButtonX
   {
      
      private var _sizer:SpriteProxy;
      
      public function MenuSelectorButton(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
      }
   }
}

