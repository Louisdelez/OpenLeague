package com.riotgames.pvpnet.CLS.views.leagueFAQView
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
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.rust.components.list.List;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class LeagueFAQView extends SpriteProxy
   {
      
      private static const NUM_QUESTIONS:uint = 17;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _answers:StatefulView;
      
      private var _answerTitleTxt:TextFieldProxy;
      
      private var _answerDescrTxt:TextFieldProxy;
      
      private var _answerDescrTxt1:TextFieldProxy;
      
      private var _answerDescrTxt2:TextFieldProxy;
      
      private var _answerDescrTxt3:TextFieldProxy;
      
      private var _answerDescrTxt4:TextFieldProxy;
      
      private var _questionsList:List;
      
      private var _questionsData:Array = [];
      
      private var _onClosed:Signal = new Signal();
      
      public function LeagueFAQView(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("leagueHelperScreen");
      }
      
      private static function buildHtml(param1:TextFieldProxy, param2:String) : void
      {
         param1.setHtmlText("<font face=\'ApplicationFont2\'>" + param2 + "</font>");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("mainTitle",_loc1_);
         this._answers = new StatefulView(this);
         setTimelineChildByName("answers",this._answers);
         this._answerTitleTxt = new TextFieldProxy(this);
         this._answerTitleTxt.setSelectable(true);
         this._answers.setTimelineChildByName("titleTxt",this._answerTitleTxt);
         this._answerDescrTxt = new TextFieldProxy(this);
         this._answerDescrTxt.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt",this._answerDescrTxt);
         this._answerDescrTxt1 = new TextFieldProxy(this);
         this._answerDescrTxt1.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt1",this._answerDescrTxt1);
         this._answerDescrTxt2 = new TextFieldProxy(this);
         this._answerDescrTxt2.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt2",this._answerDescrTxt2);
         this._answerDescrTxt3 = new TextFieldProxy(this);
         this._answerDescrTxt3.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt3",this._answerDescrTxt3);
         this._answerDescrTxt4 = new TextFieldProxy(this);
         this._answerDescrTxt4.setSelectable(true);
         this._answers.setTimelineChildByName("descriptionTxt4",this._answerDescrTxt4);
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
         var _loc3_:uint = 0;
         while(_loc3_ < NUM_QUESTIONS)
         {
            this._questionsData.push(_loc3_);
            _loc3_++;
         }
         this._questionsList.data = this._questionsData;
         this.setScalingBehavior();
      }
      
      public function selectionQuestion(param1:int) : void
      {
         this._questionsList.setSelectedIndex(param1);
         this._answers.setCurrentState("state1");
         switch(param1)
         {
            case 0:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatIsTheLeagueSystemTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatIsTheLeagueSystemDesc"));
               break;
            case 1:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhereDidMyEloRatingGoTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhereDidMyEloRatingGoDesc"));
               break;
            case 2:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatAreLeaguesTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatAreLeaguesDesc"));
               break;
            case 3:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhHowDoIGetPlacedIntoALeagueTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhHowDoIGetPlacedIntoALeagueDesc"));
               break;
            case 4:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatAreTiersTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatAreTiersDesc"));
               break;
            case 5:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatAreDivisionsTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatAreDivisionsDesc"));
               break;
            case 6:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatAreLeaguePointTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatAreLeaguePointDesc"));
               break;
            case 7:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhHowDoesAPromotionSeriesWorkTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhHowDoesAPromotionSeriesWorkDesc"));
               break;
            case 8:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhDoIOnlyCompeteAgainstOtherPlayersInMyLeagueTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhDoIOnlyCompeteAgainstOtherPlayersInMyLeagueDesc"));
               break;
            case 9:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhCanILoseATierThatIveEarnedTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhCanILoseATierThatIveEarnedDesc"));
               break;
            case 10:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhHowDoesChallengerTierWorkTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhHowDoesChallengerTierWorkDesc"));
               break;
            case 11:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatHappensIfIStopPlayingRankedForAwhileTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatHappensIfIStopPlayingRankedForAwhileDesc"));
               break;
            case 12:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatDeterminesHowManyLeaguePointsIGainFromWinningAMatchTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatDeterminesHowManyLeaguePointsIGainFromWinningAMatchDesc"));
               break;
            case 13:
               this._answers.setCurrentState("state2");
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatAreEmblemsTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatAreEmblemsDesc0"));
               buildHtml(this._answerDescrTxt1,this._localeHelper.localeLookup("lhWhatAreEmblemsDesc1"));
               buildHtml(this._answerDescrTxt2,this._localeHelper.localeLookup("lhWhatAreEmblemsDesc2"));
               buildHtml(this._answerDescrTxt3,this._localeHelper.localeLookup("lhWhatAreEmblemsDesc3"));
               buildHtml(this._answerDescrTxt4,this._localeHelper.localeLookup("lhWhatAreEmblemsDesc4"));
               break;
            case 14:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhatDeterminesTheOrderingOfTheLeagueStandingsTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhatDeterminesTheOrderingOfTheLeagueStandingsDesc"));
               break;
            case 15:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhHowCanIGetANewLeagueNameTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhHowCanIGetANewLeagueNameDesc"));
               break;
            case 16:
               this._answerTitleTxt.setText(this._localeHelper.localeLookup("lhWhyShouldILoseLPForAQueueDodgeTitle"));
               buildHtml(this._answerDescrTxt,this._localeHelper.localeLookup("lhWhyShouldILoseLPForAQueueDodgeDesc"));
         }
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

