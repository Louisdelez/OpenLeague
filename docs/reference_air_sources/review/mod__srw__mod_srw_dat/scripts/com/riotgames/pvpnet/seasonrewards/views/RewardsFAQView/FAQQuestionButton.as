package com.riotgames.pvpnet.seasonrewards.views.RewardsFAQView
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import flash.display.MovieClip;
   
   public class FAQQuestionButton extends ButtonX
   {
      
      private var _textField:TextFieldProxy;
      
      private var _localeHelper:ILocaleHelper;
      
      public function FAQQuestionButton(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("faqButton");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
      }
      
      override public function setData(param1:*) : void
      {
         _data = param1;
         this._textField.setText(this._localeHelper.localeLookup(_data + "_question"));
         this._textField.setHeight(this._textField.getTextHeight() + 4);
      }
   }
}

