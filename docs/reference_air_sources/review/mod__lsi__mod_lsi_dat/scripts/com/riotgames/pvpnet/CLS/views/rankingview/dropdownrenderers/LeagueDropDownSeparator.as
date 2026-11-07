package com.riotgames.pvpnet.CLS.views.rankingview.dropdownrenderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   
   public class LeagueDropDownSeparator extends SpriteProxy
   {
      
      private var _textField:TextFieldProxy;
      
      public function LeagueDropDownSeparator(param1:IContext, param2:String)
      {
         super(param1);
         setLinkage(param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
      }
      
      public function setData(param1:*) : void
      {
         this._textField.setText(param1.label);
      }
   }
}

