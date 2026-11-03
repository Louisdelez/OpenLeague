package com.riotgames.platform.gameclient.module.rt.view.history
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.MatchSummaryRenderer;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.rankedTeams.MatchHistorySummary;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.events.MouseEvent;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class MatchSummaryRenderer extends FlashFlexComponent implements IListItemRenderer
   {
      
      private var buttonHit:SpriteProxy;
      
      private var match:MatchHistorySummary;
      
      private var contentHolder:SpriteProxy;
      
      private var matchData:MatchHistoryListData;
      
      private var mapToggle:StatefulView;
      
      private var enemyTeamText:TextFieldProxy;
      
      private var vsText:TextFieldProxy;
      
      private var killsText:TextFieldProxy;
      
      private var timestampText:TextFieldProxy;
      
      private var opposingKillsText:TextFieldProxy;
      
      private var resultState:StatefulView;
      
      private var kdaText:TextFieldProxy;
      
      private var summaryButton:ButtonX;
      
      public function MatchSummaryRenderer()
      {
         super(RTFacade.context,"mh.MatchSummaryRenderer");
         var _loc1_:blix.assets.proxy.MatchSummaryRenderer = new blix.assets.proxy.MatchSummaryRenderer();
         this.summaryButton = new ButtonX(this.view);
         this.view.setTimelineChild(_loc1_.summaryButton,this.summaryButton);
         this.buttonHit = new SpriteProxy(this.view);
         this.buttonHit.setMouseEnabled(false);
         this.buttonHit.setMouseChildren(false);
         this.view.setTimelineChild(_loc1_.buttonHit,this.buttonHit);
         this.summaryButton.setHitArea(this.buttonHit);
         this.mapToggle = new StatefulView(this.view);
         this.view.setTimelineChild(_loc1_.summaryButton.mapChoiceToggle,this.mapToggle);
         this.resultState = new StatefulView(this.view);
         this.view.setTimelineChild(_loc1_.summaryButton.resultState,this.resultState);
         this.contentHolder = _loc1_.summaryButton.content.create(this.view);
         this.contentHolder.setMouseEnabled(false);
         this.contentHolder.setMouseChildren(false);
         this.enemyTeamText = _loc1_.summaryButton.content.opposingTeamText.create(this.view);
         this.killsText = _loc1_.summaryButton.content.killsText.create(this.view);
         this.opposingKillsText = _loc1_.summaryButton.content.deathsText.create(this.view);
         this.timestampText = _loc1_.summaryButton.content.timestampText.create(this.view);
         this.kdaText = _loc1_.summaryButton.content.kdaText.create(this.view);
         this.vsText = _loc1_.summaryButton.content.vsText.create(this.view);
         this.view.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new StatefulView(_context);
      }
      
      private function onSelectedChanged() : void
      {
         invalidateProperties();
      }
      
      public function set data(param1:Object) : void
      {
         if(this.matchData)
         {
            this.matchData.isSelectedChanged.remove(this.onSelectedChanged);
         }
         this.matchData = param1 as MatchHistoryListData;
         this.match = this.matchData.summary;
         invalidateProperties();
      }
      
      public function get view() : StatefulView
      {
         return _view as StatefulView;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.matchData.details)
         {
            RTFacade.historyProxy.showMatchDetails(this.matchData.details);
         }
         else if(this.match)
         {
            RTFacade.historyProxy.loadMatchDetails(this.match);
         }
      }
      
      public function get data() : Object
      {
         return this.match;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:String = null;
         var _loc2_:Date = null;
         var _loc3_:Date = null;
         if(this.match)
         {
            this.matchData.isSelectedChanged.add(this.onSelectedChanged);
            switch(this.match.mapId)
            {
               case GameMap.CRYSTAL_SCAR_ID:
                  _loc1_ = "crystalscar";
                  break;
               case GameMap.TWISTED_TREELINE_ID:
                  _loc1_ = "twistedtreeline";
                  break;
               default:
                  _loc1_ = "summonersrift";
            }
            this.mapToggle.setCurrentState(_loc1_);
            if(this.match.win)
            {
               this.resultState.setCurrentState("victory");
            }
            else if(this.match.invalid)
            {
               this.resultState.setCurrentState("lossForgiven");
            }
            else
            {
               this.resultState.setCurrentState("defeat");
            }
            this.summaryButton.setSelected(this.matchData.isSelected);
            _loc2_ = new Date();
            _loc2_.setTime(this.match.date);
            this.timestampText.setText(DateUtil.getDateAndTimeString(_loc2_));
            this.enemyTeamText.setText(this.match.opposingTeamName);
            _loc3_ = new Date(2012,3,15,0,0,0,0);
            if(this.match.opposingTeamKills == 0 && this.match.deaths > 0 && _loc2_.getTime() < _loc3_.getTime())
            {
               this.kdaText.setText(RTResource.getString("mhKDA",[this.match.kills,this.match.deaths,this.match.assists]));
               this.killsText.setVisible(false);
               this.opposingKillsText.setVisible(false);
               this.vsText.setVisible(false);
               this.kdaText.setVisible(true);
            }
            else
            {
               this.killsText.setText(this.match.kills.toString());
               this.opposingKillsText.setText(this.match.opposingTeamKills.toString());
               this.killsText.setVisible(true);
               this.opposingKillsText.setVisible(true);
               this.vsText.setVisible(true);
               this.kdaText.setVisible(false);
            }
         }
      }
   }
}

