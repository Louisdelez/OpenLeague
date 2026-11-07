package com.riotgames.pvpnet.CLS.views.tooltip
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.Context;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class DualLineToolTip extends EmblemsToolTip
   {
      
      private const RIGHT_PADDING:uint = 10;
      
      private var _titleText:TextFieldProxy;
      
      private var _descriptionText:TextFieldProxy;
      
      private var _background:SpriteProxy;
      
      private var _contentPositioner:SpriteProxy;
      
      public function DualLineToolTip(param1:Context, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("DualLineToolTip");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._titleText = new AutoSizeTextFieldProxy(this);
         setTimelineChildByName("titleText",this._titleText);
         this._descriptionText = new TextFieldProxy(this);
         this._descriptionText.setMultiline(true);
         this._descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("descriptionTxt",this._descriptionText);
         this._background = new SpriteProxy(this);
         setTimelineChildByName("bg",this._background);
         this._contentPositioner = new SpriteProxy(this);
         setTimelineChildByName("contentPositioner",this._contentPositioner);
      }
      
      override protected function updateUI() : void
      {
         this._titleText.setText(_model.title);
         this._titleText.setWidth(this._titleText.getTextWidth() + this.RIGHT_PADDING);
         this._descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this._descriptionText.setText(_model.description);
         this._descriptionText.setWidth(this._descriptionText.getWidth() + this.RIGHT_PADDING);
         this._descriptionText.setAutoSize(TextFieldAutoSize.NONE);
         this._background.setWidth(this._descriptionText.getWidth() + this.RIGHT_PADDING);
         var _loc1_:Number = this._descriptionText.getY() + this._descriptionText.getHeight() - this._titleText.getY() + this.RIGHT_PADDING;
         this._background.setHeight(_loc1_);
      }
   }
}

