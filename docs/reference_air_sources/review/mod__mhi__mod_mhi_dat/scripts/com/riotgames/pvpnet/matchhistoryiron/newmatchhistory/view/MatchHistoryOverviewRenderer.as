package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.view
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryContentHelper;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.controller.NewMatchHistoryController;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class MatchHistoryOverviewRenderer extends ButtonX implements IItemRenderer
   {
      
      private var _game:MatchHistoryGame;
      
      private var _index:uint;
      
      private var _controller:NewMatchHistoryController;
      
      private var _content:StatefulView;
      
      private var _victoryIndicator:StatefulView;
      
      private var _championIcon:NewMatchHistoryChampionRenderer;
      
      private var _spell1Icon:NewMatchHistorySpellRenderer;
      
      private var _spell2Icon:NewMatchHistorySpellRenderer;
      
      private var _mapNameText:TextFieldProxy;
      
      private var _gameTypeText:TextFieldProxy;
      
      private var _gameResultTextContainer:StatefulView;
      
      private var _gameResultText:TextFieldProxy;
      
      private var _item1:NewMatchHistoryGameItemRenderer;
      
      private var _item2:NewMatchHistoryGameItemRenderer;
      
      private var _item3:NewMatchHistoryGameItemRenderer;
      
      private var _item4:NewMatchHistoryGameItemRenderer;
      
      private var _item5:NewMatchHistoryGameItemRenderer;
      
      private var _item6:NewMatchHistoryGameItemRenderer;
      
      private var _item7:NewMatchHistoryGameItemRenderer;
      
      private var _kdaText:TextFieldProxy;
      
      private var _goldText:TextFieldProxy;
      
      private var _csText:TextFieldProxy;
      
      private var _objectiveScoreText:TextFieldProxy;
      
      private var _dominionRank:StatefulView;
      
      private var _durationText:TextFieldProxy;
      
      private var _dateText:TextFieldProxy;
      
      private var _levelText:TextFieldProxy;
      
      private var _championIconSizer:SpriteProxy;
      
      private var _spell1IconSizer:SpriteProxy;
      
      private var _spell2IconSizer:SpriteProxy;
      
      private var _item1IconSizer:SpriteProxy;
      
      private var _item2IconSizer:SpriteProxy;
      
      private var _item3IconSizer:SpriteProxy;
      
      private var _item4IconSizer:SpriteProxy;
      
      private var _item5IconSizer:SpriteProxy;
      
      private var _item6IconSizer:SpriteProxy;
      
      private var _item7IconSizer:SpriteProxy;
      
      public function MatchHistoryOverviewRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("MatchOverviewRenderer");
         addEventListener(MouseEvent.CLICK,this.handleClick);
      }
      
      override protected function initializeDependencies() : void
      {
         this._controller = getDependency(NewMatchHistoryController);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this._content = new StatefulView(this);
         this._content.setCurrentState("default");
         setTimelineChildByName("content",this._content);
         this._victoryIndicator = new StatefulView(this);
         this._content.setTimelineChildByName("victoryIndicator",this._victoryIndicator);
         this._championIcon = new NewMatchHistoryChampionRenderer(this);
         this._content.setTimelineChildByName("championIconContainer",this._championIcon);
         this._spell1Icon = new NewMatchHistorySpellRenderer(this);
         this._content.addChild(this._spell1Icon);
         this._spell2Icon = new NewMatchHistorySpellRenderer(this);
         this._content.addChild(this._spell2Icon);
         this._mapNameText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("mapNameText",this._mapNameText);
         this._gameTypeText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("gameTypeText",this._gameTypeText);
         this._gameResultTextContainer = new StatefulView(this);
         this._content.setTimelineChildByName("gameResultTextContainer",this._gameResultTextContainer);
         this._gameResultText = new TextFieldProxy(this);
         this._gameResultTextContainer.setTimelineChildByName("gameResultText",this._gameResultText);
         this._item1 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item1);
         this._item2 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item2);
         this._item3 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item3);
         this._item4 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item4);
         this._item5 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item5);
         this._item6 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item6);
         this._item7 = new NewMatchHistoryGameItemRenderer(this);
         this._content.addChild(this._item7);
         this._kdaText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("kdaText",this._kdaText);
         this._goldText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("goldText",this._goldText);
         this._csText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("csText",this._csText);
         this._objectiveScoreText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("objectiveScoreText",this._objectiveScoreText);
         this._durationText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("matchDurationText",this._durationText);
         this._dateText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("matchDateText",this._dateText);
         this._championIconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("championIconSizer",this._championIconSizer);
         this._spell1IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("spell1IconSizer",this._spell1IconSizer);
         this._spell2IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("spell2IconSizer",this._spell2IconSizer);
         this._item1IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item1Sizer",this._item1IconSizer);
         this._item2IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item2Sizer",this._item2IconSizer);
         this._item3IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item3Sizer",this._item3IconSizer);
         this._item4IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item4Sizer",this._item4IconSizer);
         this._item5IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item5Sizer",this._item5IconSizer);
         this._item6IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item6Sizer",this._item6IconSizer);
         this._item7IconSizer = new SpriteProxy(this);
         this._content.setTimelineChildByName("item7Sizer",this._item7IconSizer);
         this._levelText = new TextFieldProxy(this);
         this._content.setTimelineChildByName("levelText",this._levelText);
         this._levelText.setMouseEnabled(false);
         this._dominionRank = new StatefulView(this);
         this._content.setTimelineChildByName("dominionRank",this._dominionRank);
         this._dominionRank.setMouseEnabled(false);
         super.createChildren();
      }
      
      private function setGame(param1:MatchHistoryGame) : void
      {
         this._game = param1;
         if(Boolean(this._game) && Boolean(this._game.searchedParticipant))
         {
            this._content.setCurrentState(MatchHistoryContentHelper.shouldShowObjectiveScoreForMap(this._game.mapId) ? "objectiveScore" : "default");
            this._victoryIndicator.setCurrentState(this._game.searchedParticipant.stats.win ? "victory" : "defeat");
            this._championIcon.setChampion(this._game.searchedParticipant.champion);
            this._spell1Icon.setSpell(this._game.searchedParticipant.spell1);
            this._spell2Icon.setSpell(this._game.searchedParticipant.spell2);
            this._mapNameText.setText(EMatchHistoryLocalization.getLocalizedString(MatchHistoryContentHelper.getMapLocalizationKey(this._game.mapId)));
            this._gameTypeText.setText(EMatchHistoryLocalization.getLocalizedString(MatchHistoryContentHelper.getQueueLocalizationKey(this._game.queueId)));
            this._gameResultTextContainer.setCurrentState(this._game.searchedParticipant.stats.win ? "green" : "red");
            this._gameResultText.setText(EMatchHistoryLocalization.getLocalizedString(this._game.searchedParticipant.stats.win ? "GAME_VICTORY" : "GAME_DEFEAT"));
            this._item1.setGameItem(this._game.searchedParticipant.stats.item0);
            this._item2.setGameItem(this._game.searchedParticipant.stats.item1);
            this._item3.setGameItem(this._game.searchedParticipant.stats.item2);
            this._item4.setGameItem(this._game.searchedParticipant.stats.item3);
            this._item5.setGameItem(this._game.searchedParticipant.stats.item4);
            this._item6.setGameItem(this._game.searchedParticipant.stats.item5);
            this._item7.setGameItem(this._game.searchedParticipant.stats.item6);
            this._kdaText.setText(this.getFormattedKDA());
            this._goldText.setText(this.getFormattedGold());
            this._csText.setText(this._game.searchedParticipant.stats.totalMinionsKilled.toString());
            this._objectiveScoreText.setText(this._game.searchedParticipant.stats.totalPlayerScore.toString());
            this._durationText.setText(DateUtil.secondsToTimeString(this._game.gameDuration));
            this._dateText.setText(this.getFormattedDate());
            this._levelText.setText(this._game.searchedParticipant.stats.champLevel.toString());
            this._dominionRank.setCurrentState(this._game.searchedParticipant.stats.totalScoreRank.toString());
         }
      }
      
      private function getFormattedDate() : String
      {
         var _loc1_:Date = new Date();
         _loc1_.setTime(this._game.gameCreation);
         return DateUtil.getDateString(_loc1_);
      }
      
      private function getFormattedKDA() : String
      {
         return this._game.searchedParticipant.stats.kills.toString() + "/" + this._game.searchedParticipant.stats.deaths.toString() + "/" + this._game.searchedParticipant.stats.assists.toString();
      }
      
      private function getFormattedGold() : String
      {
         var _loc1_:int = this._game.searchedParticipant.stats.goldEarned;
         var _loc2_:String = EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.THOUSAND);
         return Math.round(_loc1_ / 1000).toString() + _loc2_;
      }
      
      private function handleClick(param1:MouseEvent = null) : void
      {
         this._controller.viewGameDetails(this._game);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._championIcon.setExplicitSize(this._championIconSizer.getWidth(),this._championIconSizer.getHeight());
         this._championIcon.setExplicitPosition(this._championIconSizer.getX(),this._championIconSizer.getY());
         this._spell1Icon.setExplicitSize(this._spell1IconSizer.getWidth(),this._spell1IconSizer.getHeight());
         this._spell1Icon.setExplicitPosition(this._spell1IconSizer.getX(),this._spell1IconSizer.getY());
         this._spell2Icon.setExplicitSize(this._spell2IconSizer.getWidth(),this._spell2IconSizer.getHeight());
         this._spell2Icon.setExplicitPosition(this._spell2IconSizer.getX(),this._spell2IconSizer.getY());
         this._item1.setExplicitSize(this._item1IconSizer.getWidth(),this._item1IconSizer.getHeight());
         this._item1.setExplicitPosition(this._item1IconSizer.getX(),this._item1IconSizer.getY());
         this._item2.setExplicitSize(this._item2IconSizer.getWidth(),this._item2IconSizer.getHeight());
         this._item2.setExplicitPosition(this._item2IconSizer.getX(),this._item2IconSizer.getY());
         this._item3.setExplicitSize(this._item3IconSizer.getWidth(),this._item3IconSizer.getHeight());
         this._item3.setExplicitPosition(this._item3IconSizer.getX(),this._item3IconSizer.getY());
         this._item4.setExplicitSize(this._item4IconSizer.getWidth(),this._item4IconSizer.getHeight());
         this._item4.setExplicitPosition(this._item4IconSizer.getX(),this._item4IconSizer.getY());
         this._item5.setExplicitSize(this._item5IconSizer.getWidth(),this._item5IconSizer.getHeight());
         this._item5.setExplicitPosition(this._item5IconSizer.getX(),this._item5IconSizer.getY());
         this._item6.setExplicitSize(this._item6IconSizer.getWidth(),this._item6IconSizer.getHeight());
         this._item6.setExplicitPosition(this._item6IconSizer.getX(),this._item6IconSizer.getY());
         this._item7.setExplicitSize(this._item7IconSizer.getWidth(),this._item7IconSizer.getHeight());
         this._item7.setExplicitPosition(this._item7IconSizer.getX(),this._item7IconSizer.getY());
         return super.updateLayout(param1,param2);
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override public function setData(param1:*) : void
      {
         this.setGame(param1 as MatchHistoryGame);
      }
      
      override public function getData() : *
      {
         return this._game;
      }
   }
}

