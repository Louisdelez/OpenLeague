package com.riotgames.pvpnet.CLS.views.leagueFAQView
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
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
         switch(_data)
         {
            case 0:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatIsTheLeagueSystemTitle"));
               break;
            case 1:
               this._textField.setText(this._localeHelper.localeLookup("lhWhereDidMyEloRatingGoTitle"));
               break;
            case 2:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatAreLeaguesTitle"));
               break;
            case 3:
               this._textField.setText(this._localeHelper.localeLookup("lhHowDoIGetPlacedIntoALeagueTitle"));
               break;
            case 4:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatAreTiersTitle"));
               break;
            case 5:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatAreDivisionsTitle"));
               break;
            case 6:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatAreLeaguePointTitle"));
               break;
            case 7:
               this._textField.setText(this._localeHelper.localeLookup("lhHowDoesAPromotionSeriesWorkTitle"));
               break;
            case 8:
               this._textField.setText(this._localeHelper.localeLookup("lhDoIOnlyCompeteAgainstOtherPlayersInMyLeagueTitle"));
               break;
            case 9:
               this._textField.setText(this._localeHelper.localeLookup("lhCanILoseATierThatIveEarnedTitle"));
               break;
            case 10:
               this._textField.setText(this._localeHelper.localeLookup("lhHowDoesChallengerTierWorkTitle"));
               break;
            case 11:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatHappensIfIStopPlayingRankedForAwhileTitle"));
               break;
            case 12:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatDeterminesHowManyLeaguePointsIGainFromWinningAMatchTitle"));
               break;
            case 13:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatAreEmblemsTitle"));
               break;
            case 14:
               this._textField.setText(this._localeHelper.localeLookup("lhWhatDeterminesTheOrderingOfTheLeagueStandingsTitle"));
               break;
            case 15:
               this._textField.setText(this._localeHelper.localeLookup("lhHowCanIGetANewLeagueNameTitle"));
               break;
            case 16:
               this._textField.setText(this._localeHelper.localeLookup("lhWhyShouldILoseLPForAQueueDodgeTitle"));
         }
         this._textField.setHeight(this._textField.getTextHeight() + 4);
      }
   }
}

