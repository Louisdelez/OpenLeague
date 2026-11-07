package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryContentHelper;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryTeamStats;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.MovieClip;
   
   public class MatchHistoryScoreboardTeamStatsFooter extends StatefulView
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _blueBans:MatchHistoryBansView;
      
      private var _purpleBans:MatchHistoryBansView;
      
      private var _blueTowersText:TextFieldProxy;
      
      private var _purpleTowersText:TextFieldProxy;
      
      private var _blueVictoryScore:TextFieldProxy;
      
      private var _purpleVictoryScore:TextFieldProxy;
      
      private var _blueDragonsText:TextFieldProxy;
      
      private var _purpleDragonsText:TextFieldProxy;
      
      private var _blueBaronsText:TextFieldProxy;
      
      private var _purpleBaronsText:TextFieldProxy;
      
      private var _blueVilemawsText:TextFieldProxy;
      
      private var _purpleVilemawsText:TextFieldProxy;
      
      public function MatchHistoryScoreboardTeamStatsFooter(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
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
         this._blueBans = new MatchHistoryBansView(this,100);
         setTimelineChildByName("blueBans",this._blueBans);
         this._purpleBans = new MatchHistoryBansView(this,200);
         setTimelineChildByName("purpleBans",this._purpleBans);
         this._blueTowersText = new TextFieldProxy(this);
         setTimelineChildByName("blueTowers",this._blueTowersText);
         this._purpleTowersText = new TextFieldProxy(this);
         setTimelineChildByName("purpleTowers",this._purpleTowersText);
         this._blueVictoryScore = new TextFieldProxy(this);
         setTimelineChildByName("blueVictoryScore",this._blueVictoryScore);
         this._purpleVictoryScore = new TextFieldProxy(this);
         setTimelineChildByName("purpleVictoryScore",this._purpleVictoryScore);
         this._blueDragonsText = new TextFieldProxy(this);
         setTimelineChildByName("blueDragons",this._blueDragonsText);
         this._purpleDragonsText = new TextFieldProxy(this);
         setTimelineChildByName("purpleDragons",this._purpleDragonsText);
         this._blueBaronsText = new TextFieldProxy(this);
         setTimelineChildByName("blueBarons",this._blueBaronsText);
         this._purpleBaronsText = new TextFieldProxy(this);
         setTimelineChildByName("purpleBarons",this._purpleBaronsText);
         this._blueVilemawsText = new TextFieldProxy(this);
         setTimelineChildByName("blueVilemaws",this._blueVilemawsText);
         this._purpleVilemawsText = new TextFieldProxy(this);
         setTimelineChildByName("purpleVilemaws",this._purpleVilemawsText);
         super.createChildren();
      }
      
      private function updateView() : void
      {
         var _loc1_:MatchHistoryTeamStats = null;
         var _loc2_:MatchHistoryTeamStats = null;
         if(Boolean(this._currentGame) && this._currentGame.getDetailsPopulated())
         {
            setVisible(true);
            setCurrentState(MatchHistoryContentHelper.getMapLocalizationKey(this._currentGame.mapId));
            _loc1_ = this._currentGame.teams[100];
            _loc2_ = this._currentGame.teams[200];
            this._blueTowersText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_towers",[_loc1_.towerKills]));
            this._purpleTowersText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_towers",[_loc2_.towerKills]));
            this._blueVictoryScore.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_victoryScore",[_loc1_.dominionVictoryScore]));
            this._purpleVictoryScore.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_victoryScore",[_loc2_.dominionVictoryScore]));
            this._blueDragonsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_dragons",[_loc1_.dragonKills]));
            this._purpleDragonsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_dragons",[_loc2_.dragonKills]));
            this._blueBaronsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_barons",[_loc1_.baronKills]));
            this._purpleBaronsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_barons",[_loc2_.baronKills]));
            this._blueVilemawsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_vilemaws",[_loc1_.vilemawKills]));
            this._purpleVilemawsText.setText(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_vilemaws",[_loc2_.vilemawKills]));
         }
         else
         {
            setVisible(false);
         }
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.removeGameListeners();
         this._currentGame = this._model.getCurrentGame();
         this.handleDetailsPopulatedChanged();
         this.addGameListeners();
      }
      
      private function addGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().add(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getDetailsPopulatedChanged().remove(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function handleDetailsPopulatedChanged() : void
      {
         this.updateView();
      }
   }
}

