package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.controller.NewMatchHistoryController;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.net.URLRequest;
   
   public class NewMatchHistoryView extends RiotModuleView implements INestedScreen
   {
      
      private static const STATE_INITIAL:String = "initialState";
      
      private static const STATE_LOADING_OVERVIEW:String = "loadingOverview";
      
      private static const STATE_OVERVIEW:String = "overview";
      
      private static const STATE_MATCH_DETAILS:String = "matchDetails";
      
      private static const STATE_ERROR:String = "error";
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _model:NewMatchHistoryModel;
      
      private var _controller:NewMatchHistoryController;
      
      private var _matchOverview:MatchHistoryOverview;
      
      private var _matchDetails:MatchHistoryGameDetailsView;
      
      private var _errorText:TextFieldProxy;
      
      private var _currentPlayer:MatchHistoryPlayer;
      
      private var _currentGame:MatchHistoryGame;
      
      public function NewMatchHistoryView(param1:IContext, param2:RiotModuleInfo, param3:NewMatchHistoryModel, param4:NewMatchHistoryController)
      {
         this._moduleInfo = param2;
         this._model = param3;
         this._controller = param4;
         this._assetsUrlRequest = getThemeAssetUrl(this._moduleInfo.getPath(),"newMatchHistoryAssets.swf");
         super(param1,null);
         setLinkage("MatchHistoryView");
         setCurrentState(STATE_LOADING_OVERVIEW);
         this._model.getCurrentPlayerChanged().add(this.handleCurrentPlayerChanged);
         this._model.getCurrentGameChanged().add(this.handleCurrentGameChanged);
         this._model.getServiceErrorEncounteredChanged().add(this.updateViewState);
         this.handleCurrentPlayerChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         registerDependency(NewMatchHistoryModel,this._model);
         registerDependency(NewMatchHistoryController,this._controller);
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 0;
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this,_loc1_));
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._matchOverview = new MatchHistoryOverview(this);
         setTimelineChildByName("matchOverview",this._matchOverview);
         this._matchDetails = new MatchHistoryGameDetailsView(this);
         setTimelineChildByName("matchDetails",this._matchDetails);
         this._errorText = new TextFieldProxy(this);
         setTimelineChildByName("errorText",this._errorText);
         this._errorText.setHtmlText("<font face=\'ApplicationFont2\'>" + EMatchHistoryLocalization.getLocalizedString("newMatchHistory_serviceError") + "</font>");
         super.createChildren();
      }
      
      private function handleCurrentPlayerChanged() : void
      {
         setCurrentState(STATE_INITIAL);
         this.removeCurrentPlayerListeners();
         this._currentPlayer = this._model.getCurrentPlayer();
         this.addCurrentPlayerListeners();
         this.handleRetrievingGamesChanged();
      }
      
      private function addCurrentPlayerListeners() : void
      {
         if(this._currentPlayer)
         {
            this._currentPlayer.getRetrievingRecentGamesChanged().add(this.handleRetrievingGamesChanged);
            this._currentPlayer.getRetrievingPlayerInfoChanged().add(this.handleRetrievingInfoChanged);
         }
      }
      
      private function removeCurrentPlayerListeners() : void
      {
         if(this._currentPlayer)
         {
            this._currentPlayer.getRetrievingRecentGamesChanged().remove(this.handleRetrievingGamesChanged);
            this._currentPlayer.getRetrievingPlayerInfoChanged().remove(this.handleRetrievingInfoChanged);
         }
      }
      
      private function handleRetrievingGamesChanged() : void
      {
         this.updateViewState();
      }
      
      private function handleRetrievingInfoChanged() : void
      {
         this.updateViewState();
      }
      
      private function handleCurrentGameChanged() : void
      {
         this.updateViewState();
      }
      
      private function updateViewState() : void
      {
         var _loc1_:MatchHistoryGame = null;
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         if(this._model.getServiceErrorEncountered())
         {
            setCurrentState(STATE_ERROR);
         }
         else if(!this._currentPlayer)
         {
            setCurrentState(STATE_LOADING_OVERVIEW);
         }
         else
         {
            _loc1_ = this._model.getCurrentGame();
            if(_loc1_)
            {
               setCurrentState(STATE_MATCH_DETAILS);
            }
            else if(this._currentPlayer.getRetrievingPlayerInfo() || this._currentPlayer.getRetrievingRecentGames())
            {
               setCurrentState(STATE_LOADING_OVERVIEW);
            }
            else if(this._currentPlayer.getRecentGames())
            {
               setCurrentState(STATE_OVERVIEW);
            }
         }
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function hide() : void
      {
         unloadAssets(this._assetsUrlRequest);
         this._hideCompleted.dispatch();
      }
      
      public function show() : void
      {
         loadAssets(this._assetsUrlRequest);
      }
   }
}

