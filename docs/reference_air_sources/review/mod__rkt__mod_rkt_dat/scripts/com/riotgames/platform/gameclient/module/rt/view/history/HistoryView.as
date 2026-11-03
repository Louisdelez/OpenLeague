package com.riotgames.platform.gameclient.module.rt.view.history
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.MatchHistoryContent;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import com.riotgames.platform.gameclient.views.IEndOfGameScoreboardProvider;
   import com.riotgames.platform.gameclient.views.IScoreboard;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.core.ScrollPolicy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   
   public class HistoryView extends FlashFlexComponent implements IActivatableView
   {
      
      private var _matchList:ArrayCollection;
      
      private var _currentStats:EndOfGameStats;
      
      private var completeDetailsButton:ButtonX;
      
      private var _mediator:IMediator;
      
      private var summaryList:List;
      
      private var matchDetailDecorator:StatefulView;
      
      private var overviewHeader:OverviewHeader;
      
      public var backToMatchDetailsSignal:Signal = new Signal();
      
      private var detailContent:Canvas;
      
      private var _currentMatchHistory:MatchHistorySummary;
      
      private var scoreboardProvider:IEndOfGameScoreboardProvider;
      
      public function HistoryView(param1:RTContext)
      {
         super(param1,"mh.MatchHistoryContent");
         var _loc2_:MatchHistoryContent = new MatchHistoryContent();
         this.summaryList = new List();
         this.summaryList.itemRenderer = new ClassFactory(MatchSummaryRenderer);
         this.summaryList.rowHeight = 65;
         this.summaryList.selectable = false;
         this.summaryList.verticalScrollPolicy = ScrollPolicy.ON;
         this.summaryList.styleName = "yellow";
         param1.viewUtil.setupComponentOverlay(this.view,_loc2_.matchListProxy,this,this.summaryList);
         this.detailContent = new Canvas();
         this.detailContent.verticalScrollPolicy = ScrollPolicy.OFF;
         this.detailContent.horizontalScrollPolicy = ScrollPolicy.OFF;
         param1.viewUtil.setupComponentOverlay(this.view,_loc2_.matchDetailProxy,this,this.detailContent);
         this.overviewHeader = new OverviewHeader(this.view);
         this.view.setTimelineChild(_loc2_.overviewHeader,this.overviewHeader);
         this.matchDetailDecorator = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.matchDetailDecorator,this.matchDetailDecorator);
         this.completeDetailsButton = param1.viewUtil.wireButton(this.view,_loc2_.completeDetailsButton,this.onDetailsClicked);
         this.completeDetailsButton.setVisible(false);
         ProviderLookup.getProvider(IEndOfGameScoreboardProvider,this.gotScoreboardProvider);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function showSummaries(param1:ArrayCollection) : void
      {
         var _loc2_:MatchHistorySummary = null;
         var _loc3_:MatchHistoryListData = null;
         this._matchList = new ArrayCollection();
         for each(_loc2_ in param1)
         {
            _loc3_ = new MatchHistoryListData(_loc2_);
            this._matchList.addItem(_loc3_);
         }
         this.summaryList.dataProvider = this._matchList;
      }
      
      private function onDetailsClicked(param1:MouseEvent) : void
      {
         this.scoreboardProvider.navigateToEndOfGameScreen(this._currentStats,this._currentMatchHistory,RTResource.getString("mhBackToMatchHistory"),this.onBackToMatchDetailsClicked,true);
         if(RTFacade.profilePlayerProxy.isLocal)
         {
         }
      }
      
      public function showDetails(param1:EndOfGameStats, param2:Boolean, param3:MatchHistorySummary) : void
      {
         var _loc4_:MatchHistorySummary = null;
         var _loc5_:MatchHistoryListData = null;
         var _loc6_:IScoreboard = null;
         this._currentStats = param1;
         this._currentMatchHistory = param3;
         for each(_loc5_ in this._matchList)
         {
            if(Boolean(param1) && _loc5_.summary.gameId == param1.gameId)
            {
               _loc5_.details = param1;
               _loc5_.isSelected = true;
               _loc4_ = _loc5_.summary;
            }
            else
            {
               _loc5_.isSelected = false;
            }
         }
         if(!param1)
         {
            this.clearDetailContent();
            this.overviewHeader.setVisible(false);
            this.completeDetailsButton.setVisible(false);
            if(param2)
            {
               this.matchDetailDecorator.setCurrentState("loadingMatch");
            }
            else if(Boolean(this._matchList) && this._matchList.length > 0)
            {
               this.matchDetailDecorator.setCurrentState("noMatch");
            }
            else
            {
               this.matchDetailDecorator.setCurrentState("noMatches");
            }
         }
         else
         {
            this.matchDetailDecorator.setCurrentState("showMatch");
            this.overviewHeader.setVisible(true);
            this.overviewHeader.showStats(param1,_loc4_);
            this.completeDetailsButton.setVisible(this.scoreboardProvider.isGameNavigationAllowed());
            _loc6_ = this.scoreboardProvider.getScoreboardForStats(param1,this._currentMatchHistory,true);
            _loc6_.scaleX = this.detailContent.width / 814;
            _loc6_.scaleY = this.detailContent.height / 434;
            this.detailContent.addChild(DisplayObject(_loc6_));
            _loc6_.show();
         }
      }
      
      private function gotScoreboardProvider(param1:IEndOfGameScoreboardProvider) : void
      {
         this.scoreboardProvider = param1;
      }
      
      private function clearDetailContent() : void
      {
         this.detailContent.removeAllChildren();
      }
      
      private function onBackToMatchDetailsClicked() : void
      {
         this.backToMatchDetailsSignal.dispatch();
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      public function activate() : void
      {
         if(!this._mediator)
         {
            this._mediator = new HistoryViewMediator(HistoryViewMediator.NAME,this);
         }
         RTFacade.instance.registerMediator(this._mediator);
         if(RTFacade.profilePlayerProxy.isLocal)
         {
         }
      }
      
      public function deactivate() : void
      {
         RTFacade.instance.removeMediator(HistoryViewMediator.NAME);
      }
   }
}

