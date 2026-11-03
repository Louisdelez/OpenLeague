package com.riotgames.pvpnet.CLS.views.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.Context;
   import flash.display.MovieClip;
   
   public class SingleLineToolTip extends EmblemsToolTip
   {
      
      private var _titleText:TextFieldProxy;
      
      private var _background:SpriteProxy;
      
      private var _contentPositioner:SpriteProxy;
      
      public function SingleLineToolTip(param1:Context, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("SingleLineToolTip");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._titleText = new TextFieldProxy(this);
         setTimelineChildByName("titleText",this._titleText);
         this._background = new SpriteProxy(this);
         setTimelineChildByName("bg",this._background);
         this._contentPositioner = new SpriteProxy(this);
         setTimelineChildByName("contentPositioner",this._contentPositioner);
      }
      
      override protected function updateUI() : void
      {
         this._titleText.setText(_model.title);
         this._background.setWidth(HORIZONTAL_PADDING + this._titleText.getTextWidth());
         this._titleText.setWidth(HORIZONTAL_SIZER * this._titleText.getTextWidth());
      }
   }
}

