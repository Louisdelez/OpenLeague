package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class MatchHistoryGraphLabel extends StatefulView
   {
      
      private var _textField:TextFieldProxy;
      
      public function MatchHistoryGraphLabel(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("MatchHistoryGraphLabel");
      }
      
      override protected function createChildren() : void
      {
         this._textField = new TextFieldProxy(this);
         this._textField.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("textField",this._textField);
         super.createChildren();
      }
      
      public function setGoldValue(param1:Number) : void
      {
         var _loc2_:String = EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.THOUSAND);
         this._textField.setText(Math.abs(Math.round(param1 / 1000)).toString() + _loc2_);
         this._textField.setAutoSize(TextFieldAutoSize.RIGHT);
         setCurrentState("rightAligned");
      }
      
      public function setObjectiveScoreValue(param1:Number) : void
      {
         this._textField.setText(Math.abs(param1).toString());
         this._textField.setAutoSize(TextFieldAutoSize.RIGHT);
         setCurrentState("rightAligned");
      }
      
      public function setTimeValue(param1:Number) : void
      {
         this._textField.setText(DateUtil.milisecondsToTimeString(param1));
         this._textField.setAutoSize(TextFieldAutoSize.CENTER);
         setCurrentState("centerAligned");
      }
      
      public function getTextFieldWidth() : Number
      {
         return this._textField.getWidth();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._textField.setExplicitSize(param1,param2);
         return this._textField.getBounds(null);
      }
   }
}

