package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataScroller;
   import blix.components.list.RendererFactory;
   import blix.components.scroll.ScrollPolicy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.layout.algorithms.VirtualizedVerticalLayout;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   
   public class MatchHistoryOverview extends StatefulView
   {
      
      private static const STATE_DEFAULT:String = "default";
      
      private static const STATE_NO_RESULTS:String = "noResults";
      
      private var _model:NewMatchHistoryModel;
      
      private var _currentPlayer:MatchHistoryPlayer;
      
      private var _sizer:SpriteProxy;
      
      private var _dataScroller:DataScroller;
      
      private var _listData:ListView;
      
      private var _infoText:TextFieldProxy;
      
      public function MatchHistoryOverview(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._model.getCurrentPlayerChanged().add(this.handleCurrentPlayerChanged);
         this.handleCurrentPlayerChanged();
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(NewMatchHistoryModel);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this._sizer);
         var _loc1_:VirtualizedVerticalLayout = new VirtualizedVerticalLayout();
         _loc1_.setGap(0);
         var _loc2_:RendererFactory = new RendererFactory(MatchHistoryOverviewRenderer,[this]);
         this._listData = new ListView();
         this._listData.sortWithCompare(this.sortRecentGames);
         this._dataScroller = new DataScroller(this,this._listData,_loc2_);
         this._dataScroller.setLinkage("ScrollContainer");
         this._dataScroller.setScrollPolicy(ScrollPolicy.ON);
         this._dataScroller.setLayoutAlgorithm(_loc1_);
         this._dataScroller.getLayoutInvalidated().add(invalidateLayout);
         this._dataScroller.setKineticScrolling(true);
         addChild(this._dataScroller);
         this._infoText = new TextFieldProxy(this);
         setTimelineChildByName("infoText",this._infoText);
         this._infoText.setHtmlText("<font face=\'ApplicationFont2\'>" + EMatchHistoryLocalization.getLocalizedString("newMatchHistory_noResultsText") + "</font>");
         this._infoText.setMouseEnabled(false);
         super.createChildren();
      }
      
      private function sortRecentGames(param1:MatchHistoryGame, param2:MatchHistoryGame) : int
      {
         return param1.gameCreation < param2.gameCreation ? 1 : -1;
      }
      
      private function handleCurrentPlayerChanged() : void
      {
         this.removeCurrentPlayerListeners();
         this._currentPlayer = this._model.getCurrentPlayer();
         this.addCurrentPlayerListeners();
         this.handleRecentGamesChanged();
      }
      
      private function addCurrentPlayerListeners() : void
      {
         if(this._currentPlayer)
         {
            this._currentPlayer.getRecentGamesChanged().add(this.handleRecentGamesChanged);
            this._currentPlayer.getRetrievingRecentGamesChanged().add(this.handleRetrievingGamesChanged);
         }
      }
      
      private function removeCurrentPlayerListeners() : void
      {
         if(this._currentPlayer)
         {
            this._currentPlayer.getRecentGamesChanged().remove(this.handleRecentGamesChanged);
            this._currentPlayer.getRetrievingRecentGamesChanged().remove(this.handleRetrievingGamesChanged);
         }
      }
      
      private function handleRecentGamesChanged() : void
      {
         if(Boolean(this._model.getCurrentPlayer()) && Boolean(this._model.getCurrentPlayer().getRecentGames()))
         {
            this._listData.setSource(this._model.getCurrentPlayer().getRecentGames().games);
         }
         else
         {
            this._listData.setSource(null);
         }
         var _loc1_:Boolean = false;
         if(Boolean(this._model.getCurrentPlayer()) && Boolean(this._model.getCurrentPlayer().getRecentGames()) && this._model.getCurrentPlayer().getRecentGames().games.length > 0)
         {
            _loc1_ = true;
         }
         setCurrentState(_loc1_ ? STATE_DEFAULT : STATE_NO_RESULTS);
         this._dataScroller.setVisible(_loc1_);
         this._infoText.setVisible(!_loc1_);
      }
      
      private function handleRetrievingGamesChanged() : void
      {
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._dataScroller.setExplicitSize(this._sizer.getWidth(),this._sizer.getHeight());
         this._dataScroller.setExplicitPosition(this._sizer.getX(),this._sizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

