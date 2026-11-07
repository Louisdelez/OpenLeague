package com.riotgames.pvpnet.seasonrewards.views.RewardsFAQView
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.seasonrewards.configuration.SeasonRewardsConfig;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.rust.components.list.List;
   import com.riotgames.rust.components.text.HTMLTextFieldProxy;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RewardsFAQView extends SpriteProxy
   {
      
      private var _localeHelper:ILocaleHelper;
      
      private var _questions:Array;
      
      private var _answers:StatefulView;
      
      private var _answerTitleTxt:TextFieldProxy;
      
      private var _answerDescrTxt:HTMLTextFieldProxy;
      
      private var _questionsList:List;
      
      private var _onClosed:Signal = new Signal();
      
      private var _titleText:String;
      
      public function RewardsFAQView(param1:IContext, param2:Array, param3:String = null, param4:Sprite = null)
      {
         this._titleText = param3;
         this._questions = param2;
         super(param1,param4);
         setLinkage("faqScreen");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("mainTitle",_loc1_);
         if(this._titleText)
         {
            _loc1_.setText(this._titleText);
         }
         this._answers = new StatefulView(this);
         setTimelineChildByName("answers",this._answers);
         this._answerTitleTxt = new TextFieldProxy(this);
         this._answerTitleTxt.setSelectable(true);
         this._answers.setTimelineChildByName("titleTxt",this._answerTitleTxt);
         this._answerDescrTxt = new HTMLTextFieldProxy(this);
         this._answerDescrTxt.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt",this._answerDescrTxt);
         var _loc2_:ButtonX = new ButtonX(this);
         setTimelineChildByName("closeButton",_loc2_);
         _loc2_.addEventListener(MouseEvent.CLICK,this._onCloseButton);
         this._questionsList = new List(this);
         this._questionsList.allowVariableSpan = true;
         this._questionsList.listView.itemPadding = 0;
         setTimelineChildByName("faqList",this._questionsList);
         this._questionsList.listView.rendererLinkage = "FAQQuestionItemRenderer";
         this._questionsList.listView.rendererType = FAQQuestionItemRenderer;
         this._questionsList.selectionChanged.add(this._onQuestionSelected);
         this._questionsList.data = this._questions;
         this.setScalingBehavior();
      }
      
      public function selectionQuestion(param1:int) : void
      {
         var _loc5_:uint = 0;
         this._questionsList.setSelectedIndex(param1);
         var _loc2_:Array = [];
         var _loc3_:String = DynamicClientConfigManager.getConfiguration(SeasonRewardsConfig.NAMESPACE,SeasonRewardsConfig.POINTS_PER_REWARD_LEVEL,null).getString();
         var _loc4_:Array = _loc3_ ? _loc3_.split(",") : ["XX","XX","XX"];
         switch(this._questions[param1])
         {
            case "whatAreRewards":
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc2_.push(_loc4_[_loc5_]);
                  _loc5_++;
               }
               break;
            case "winsNeededOnSameTeam":
               _loc2_.push(_loc4_.pop());
         }
         this._answerTitleTxt.setText(this._localeHelper.localeLookup(this._questions[param1] + "_question"));
         this._answerDescrTxt.setHtmlText(this._localeHelper.localeLookup(this._questions[param1] + "_answer",_loc2_));
         this._answerTitleTxt.setHeight(this._answerTitleTxt.getTextHeight() + 5);
         this._answerDescrTxt.setY(this._answerTitleTxt.getY() + this._answerTitleTxt.getHeight() + 10);
      }
      
      private function _onQuestionSelected() : void
      {
         this.selectionQuestion(this._questionsList.getSelectedIndex());
      }
      
      private function setScalingBehavior() : void
      {
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc1_.setMaintainAspectRatio(true);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc1_.setVerticalAlign(VerticalAlign.MIDDLE);
         _loc1_.setScalePercentConstraints(new SizeConstraints(new MinMax(0,1),new MinMax(0,1)));
         this.setTransformBehavior(_loc1_);
      }
      
      public function getOnClosed() : ISignal
      {
         return this._onClosed;
      }
      
      protected function _onCloseButton(param1:MouseEvent) : void
      {
         this._onClosed.dispatch(this._onClosed);
      }
   }
}

