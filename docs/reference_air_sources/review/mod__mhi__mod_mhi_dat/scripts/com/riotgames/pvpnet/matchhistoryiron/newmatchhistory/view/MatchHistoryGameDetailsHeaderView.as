package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryContentHelper;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class MatchHistoryGameDetailsHeaderView extends StatefulView
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _mapNameText:TextFieldProxy;
      
      private var _gameTypeText:TextFieldProxy;
      
      private var _gameResultTextContainer:StatefulView;
      
      private var _gameResultText:TextFieldProxy;
      
      private var _durationText:TextFieldProxy;
      
      private var _dateText:TextFieldProxy;
      
      private var _background:StatefulView;
      
      private var _viewOnlineButton:LabelButtonX;
      
      public function MatchHistoryGameDetailsHeaderView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("MatchHistoryDetailsHeader");
         this._model.getCurrentGameChanged().add(this.handleCurrentGameChanged);
         this.handleCurrentGameChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._mapNameText = new TextFieldProxy(this);
         setTimelineChildByName("mapNameText",this._mapNameText);
         this._gameTypeText = new TextFieldProxy(this);
         setTimelineChildByName("gameTypeText",this._gameTypeText);
         this._gameResultTextContainer = new StatefulView(this);
         setTimelineChildByName("gameResultTextContainer",this._gameResultTextContainer);
         this._gameResultText = new TextFieldProxy(this);
         this._gameResultTextContainer.setTimelineChildByName("gameResultText",this._gameResultText);
         this._durationText = new TextFieldProxy(this);
         setTimelineChildByName("matchDurationText",this._durationText);
         this._dateText = new TextFieldProxy(this);
         setTimelineChildByName("matchDateText",this._dateText);
         this._background = new StatefulView(this);
         setTimelineChildByName("background",this._background);
         this._viewOnlineButton = new LabelButtonX(this);
         setTimelineChildByName("viewOnlineButton",this._viewOnlineButton);
         this._viewOnlineButton.addEventListener(MouseEvent.CLICK,this.handleViewOnlineButtonClicked);
         this._viewOnlineButton.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_viewOnlineButton"));
         super.createChildren();
      }
      
      private function updateView() : void
      {
         if(this._currentGame)
         {
            this._mapNameText.setText(EMatchHistoryLocalization.getLocalizedString(MatchHistoryContentHelper.getMapLocalizationKey(this._currentGame.mapId)));
            this._gameTypeText.setText(EMatchHistoryLocalization.getLocalizedString(MatchHistoryContentHelper.getQueueLocalizationKey(this._currentGame.queueId)));
            this._gameResultTextContainer.setCurrentState(this._currentGame.searchedParticipant.stats.win ? "green" : "red");
            this._gameResultText.setText(EMatchHistoryLocalization.getLocalizedString(this._currentGame.searchedParticipant.stats.win ? "GAME_VICTORY" : "GAME_DEFEAT"));
            this._durationText.setText(DateUtil.secondsToTimeString(this._currentGame.gameDuration));
            this._dateText.setText(this.getFormattedDate());
            this._background.setCurrentState(this._currentGame.searchedParticipant.stats.win ? "green" : "red");
         }
      }
      
      private function getFormattedDate() : String
      {
         var _loc1_:Date = new Date();
         _loc1_.setTime(this._currentGame.gameCreation);
         return DateUtil.getDateString(_loc1_);
      }
      
      private function handleCurrentGameChanged() : void
      {
         this._currentGame = this._model.getCurrentGame();
         this.updateView();
      }
      
      private function handleViewOnlineButtonClicked(param1:MouseEvent) : void
      {
      }
   }
}

