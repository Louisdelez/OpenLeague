package com.riotgames.pvpnet.endofgamegiftwindow.views.components.giftdetail
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.CustomMessageConfigData;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   
   public class CustomMessageContainer extends SpriteProxy implements IDataRenderer
   {
      
      private var _customMessageConfig:CustomMessageConfigData;
      
      private var _inputText:InputTextFieldProxy;
      
      public function CustomMessageContainer(param1:IContext)
      {
         super(param1,null);
      }
      
      override protected function createChildren() : void
      {
         this._inputText = new InputTextFieldProxy(this);
         this._inputText.setEmbedFonts(true);
         setTimelineChildByName("textField",this._inputText);
         super.createChildren();
      }
      
      public function getData() : *
      {
         return this._customMessageConfig;
      }
      
      public function setData(param1:*) : void
      {
         this._customMessageConfig = CustomMessageConfigData(param1);
         this.redrawView();
      }
      
      override public function destroy() : void
      {
         this._customMessageConfig = null;
         super.destroy();
      }
      
      private function redrawView() : void
      {
         this._inputText.setHintTextColor(this._customMessageConfig.hintTextColor);
         this._inputText.setHintText(this._customMessageConfig.hintText);
         this._inputText.setTextColor(this._customMessageConfig.textColor);
         this._inputText.setBackground(true);
         this._inputText.setBackgroundColor(this._customMessageConfig.backgroundColor);
         this._inputText.setBorder(true);
         this._inputText.setBorderColor(this._customMessageConfig.borderColor);
      }
   }
}

