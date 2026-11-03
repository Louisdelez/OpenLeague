package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.dropdown.DropDown;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryContentHelper;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class MatchHistoryDetailsOverTimeView extends StatefulView
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentGame:MatchHistoryGame;
      
      private var _content:SpriteProxy;
      
      private var _graphSizer:SpriteProxy;
      
      private var _graphView:MatchHistoryGraphPanelView;
      
      private var _dropdown:DropDown;
      
      private var _titleText:TextFieldProxy;
      
      private var _participantSelectionView:MatchHistoryParticipantSelectionView;
      
      private var _graphModesDataProvider:ListView;
      
      private var _graphModesDictionary:Dictionary = new Dictionary();
      
      private var _setDefaultParticipant:Boolean;
      
      public function MatchHistoryDetailsOverTimeView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("MatchHistoryGraphView");
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
         var _loc2_:Object = null;
         this._content = new SpriteProxy(this);
         setTimelineChildByName("content",this._content);
         this._graphSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("graphAreaSizer",this._graphSizer);
         this._participantSelectionView = new MatchHistoryParticipantSelectionView(this);
         this._participantSelectionView.getSelectedParticipantsChanged().add(this.handleParticipantSelectionChanged);
         this._content.setTimelineChildByName("participantSelectionView",this._participantSelectionView);
         this._graphView = new MatchHistoryGraphPanelView(this);
         this._content.setTimelineChildByName("graphContainer",this._graphView);
         var _loc1_:Array = this._graphView.getGraphDisplayModes();
         for each(_loc2_ in _loc1_)
         {
            this._graphModesDictionary[_loc2_["name"]] = _loc2_;
         }
         this._graphModesDataProvider = new ListView(new ListX(_loc1_));
         this._graphModesDataProvider.filter(this.graphModeFilter);
         this._dropdown = new DropDown(this);
         this._dropdown.setListLinkage("MatchHistoryDropdownList");
         this._dropdown.setLabelField("label");
         this._dropdown.setDataProvider(this._graphModesDataProvider);
         this._dropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
         this._dropdown.setNoneSelectedLabel(EMatchHistoryLocalization.getLocalizedString("newMatchHistory_selectGraphLabel"));
         this._content.setTimelineChildByName("dropdown",this._dropdown);
         this._titleText = new TextFieldProxy(this);
         this._titleText.setText("");
         this._content.setTimelineChildByName("titleText",this._titleText);
         super.createChildren();
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         invalidateLayout();
      }
      
      private function updateView() : void
      {
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         if(Boolean(this._currentGame) && this._currentGame.getTimelineRetrieved())
         {
            this.setCurrentState("loaded");
         }
         else
         {
            this.setCurrentState("waiting");
         }
      }
      
      private function handleDropdownSelection() : void
      {
         this._dropdown.getSelectionBehavior().getSelectedItemsChanged().remove(this.handleDropdownSelection);
         this.setGraphMode(this._dropdown.getSelectionBehavior().getSelectedItem());
         this._dropdown.getSelectionBehavior().setSelectedItem(null);
         this._dropdown.getSelectionBehavior().getSelectedItemsChanged().add(this.handleDropdownSelection);
      }
      
      private function handleParticipantSelectionChanged() : void
      {
         this._graphView.setParticipants(this._participantSelectionView.getSelectedParticipants());
      }
      
      private function setGraphMode(param1:Object) : void
      {
         var _loc2_:MatchHistoryGameParticipant = null;
         if(!this._currentGame)
         {
            return;
         }
         if(param1["name"] == MatchHistoryGraphPanelView.MODE_CHAMPION_GOLD || param1["name"] == MatchHistoryGraphPanelView.MODE_CHAMPION_SCORE)
         {
            this._participantSelectionView.setVisible(true);
            if(this._setDefaultParticipant)
            {
               this._setDefaultParticipant = false;
               for each(_loc2_ in this._currentGame.participants)
               {
                  if(_loc2_.player.accountId == this._currentGame.searchedParticipant.player.accountId)
                  {
                     this._participantSelectionView.setSelectedParticipant(_loc2_);
                     break;
                  }
               }
            }
         }
         else
         {
            this._participantSelectionView.setVisible(false);
         }
         this._titleText.setText(param1["label"]);
         this._graphView.setDisplayMode(param1["name"]);
      }
      
      private function graphModeFilter(param1:Object, param2:int, param3:Array) : Boolean
      {
         if(this._currentGame)
         {
            if(MatchHistoryContentHelper.shouldShowObjectiveScoreForMap(this._currentGame.mapId))
            {
               return param1["onObjectiveScoreGames"];
            }
            return param1["onNonObjectiveScoreGames"];
         }
         return false;
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.removeGameListeners();
         this._currentGame = this._model.getCurrentGame();
         this._setDefaultParticipant = true;
         this.handleDetailsPopulatedChanged();
         this._graphModesDataProvider.reset();
         if(this._currentGame)
         {
            if(MatchHistoryContentHelper.shouldShowObjectiveScoreForMap(this._currentGame.mapId))
            {
               this._dropdown.getSelectionBehavior().setSelectedItem(this._graphModesDictionary[MatchHistoryGraphPanelView.MODE_TEAM_SCORE_ADVANTAGE]);
            }
            else
            {
               this._dropdown.getSelectionBehavior().setSelectedItem(this._graphModesDictionary[MatchHistoryGraphPanelView.MODE_TEAM_GOLD_ADVANTAGE]);
            }
         }
         this._dropdown.getSelectionBehavior().setSelectedItem(null,false);
         this.addGameListeners();
      }
      
      private function addGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getTimelineRetrievedChanged().add(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function removeGameListeners() : void
      {
         if(this._currentGame)
         {
            this._currentGame.getTimelineRetrievedChanged().remove(this.handleDetailsPopulatedChanged);
         }
      }
      
      private function handleDetailsPopulatedChanged() : void
      {
         this.updateView();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._graphView.setExplicitPosition(this._graphSizer.getX(),this._graphSizer.getY());
         this._graphView.setExplicitSize(this._graphSizer.getWidth(),this._graphSizer.getHeight());
         return super.updateLayout(param1,param2);
      }
   }
}

