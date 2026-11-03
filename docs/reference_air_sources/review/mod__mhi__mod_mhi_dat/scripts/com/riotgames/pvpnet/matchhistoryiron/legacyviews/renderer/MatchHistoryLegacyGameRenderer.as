package com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.GameStatusLogicTable;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLinkage;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import flash.geom.Rectangle;
   
   public class MatchHistoryLegacyGameRenderer extends ButtonX implements IItemRenderer
   {
      
      private static const GAME_RESULT_PADDING:int = 4;
      
      private static const MAX_ITEMS_PER_GAME:int = 7;
      
      protected var _index:int;
      
      private var _mapName:TextFieldProxy;
      
      private var _gameTypeText:TextFieldProxy;
      
      private var _gameResult:StatefulView;
      
      private var _gameResultText:TextFieldProxy;
      
      private var _gameDate:TextFieldProxy;
      
      private var _killScore:TextFieldProxy;
      
      private var _deathScore:TextFieldProxy;
      
      private var _assistScore:TextFieldProxy;
      
      private var _dominionScore:TextFieldProxy;
      
      private var _gameModeText:TextFieldProxy;
      
      private var _rewardText:TextFieldProxy;
      
      private var _gameGold:StatefulView;
      
      private var _gameGoldText:TextFieldProxy;
      
      private var _kdaContainer:StatefulView;
      
      private var _dominionRank:StatefulView;
      
      private var _model:MatchHistoryStatModel;
      
      private var _renderStyle:String = "";
      
      private var _items:Vector.<MatchHistoryItemIconRenderer>;
      
      private var _spell1:MatchHistorySpellIconRenderer;
      
      private var _spell2:MatchHistorySpellIconRenderer;
      
      private var _championIcon:MatchHistoryChampionIconRenderer;
      
      public function MatchHistoryLegacyGameRenderer(param1:IContext, param2:String = "")
      {
         super(param1);
         setMouseChildren(false);
         this._renderStyle = param2;
         setLinkage(EMatchHistoryLinkage.GAME_RENDERER_VICTORY);
         this.setCurrentState("up");
      }
      
      private static function getFormattedGold(param1:String) : String
      {
         var _loc2_:String = EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.THOUSAND);
         return Math.round(parseInt(param1) / 1000).toString() + _loc2_;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._mapName = new TextFieldProxy(this);
         this._gameTypeText = new TextFieldProxy(this);
         this._gameResultText = new TextFieldProxy(this);
         this._gameDate = new TextFieldProxy(this);
         this._killScore = new TextFieldProxy(this);
         this._deathScore = new TextFieldProxy(this);
         this._assistScore = new TextFieldProxy(this);
         this._dominionScore = new TextFieldProxy(this);
         this._gameModeText = new TextFieldProxy(this);
         this._rewardText = new TextFieldProxy(this);
         this._gameResult = new StatefulView(this);
         this._dominionRank = new StatefulView(this);
         this._kdaContainer = new StatefulView(this);
         this._gameGold = new StatefulView(this);
         this._gameGoldText = new TextFieldProxy(this._gameGold);
         this._championIcon = new MatchHistoryChampionIconRenderer(this);
         this._championIcon.getLayoutInvalidated().add(invalidateLayout);
         this._items = new Vector.<MatchHistoryItemIconRenderer>();
         var _loc1_:int = 0;
         while(_loc1_ < MAX_ITEMS_PER_GAME)
         {
            this._items.push(new MatchHistoryItemIconRenderer(this));
            _loc1_++;
         }
         this._spell1 = new MatchHistorySpellIconRenderer(this);
         this._spell2 = new MatchHistorySpellIconRenderer(this);
         this.setTimelineChildren();
         this._dominionRank.setMouseEnabled(false);
         this._dominionRank.setMouseChildren(false);
         this._dominionRank.setCurrentState(EMatchHistoryLinkage.DOMINION_NO_RANK);
         this._gameGold.setCurrentState(EMatchHistoryLinkage.GAME_GOLD_HIDE_STATE);
      }
      
      private function setTimelineChildren() : void
      {
         setTimelineChildByName(EMatchHistoryLinkage.GAME_MAP_NAME,this._mapName);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_TYPE_INDICATOR_TEXT,this._gameTypeText);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_RESULT,this._gameResult);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_RESULT_TEXT,this._gameResultText);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_DATE,this._gameDate);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_KILL_SCORE_OLD_TEXT,this._killScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_DEATH_SCORE_OLD_TEXT,this._deathScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_ASSISTS_SCORE_OLD_TEXT,this._assistScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_DOMINION_SCORE_OLD_TEXT,this._dominionScore);
         setTimelineChildByName(EMatchHistoryLinkage.DOMINION_RANK,this._dominionRank);
         setTimelineChildByName(EMatchHistoryLinkage.KDA_CONTAINER,this._kdaContainer);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_MODE_TEXT,this._gameModeText);
         setTimelineChildByName(EMatchHistoryLinkage.REWARD_TEXT,this._rewardText);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_CHAMPION_ICON,this._championIcon);
         setTimelineChildByName(EMatchHistoryLinkage.GAME_GOLD,this._gameGold);
         this._gameGold.setTimelineChildByName(EMatchHistoryLinkage.GAME_GOLD_TEXT,this._gameGoldText);
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            setTimelineChildByName(EMatchHistoryLinkage.GAME_ITEM_PREFIX + _loc1_,this._items[_loc1_]);
            _loc1_++;
         }
         setTimelineChildByName("spell1",this._spell1);
         setTimelineChildByName("spell2",this._spell2);
      }
      
      public function updateData() : void
      {
         this.setRendererType();
         this.setGameStatText();
         this.setXpAndIp();
         this.setDominionRank();
         this.setItemData();
         this.loadIconRenderer();
      }
      
      private function setItemData() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            this._items[_loc1_].loadItemVisual(this._model.itemList.length > _loc1_ ? this._model.itemList[_loc1_] : null);
            _loc1_++;
         }
         this._spell1.loadSpellVisual(this._model.spellCast1);
         this._spell2.loadSpellVisual(this._model.spellCast2);
      }
      
      private function setXpAndIp() : void
      {
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(this._model.stat.experienceEarned > 0)
         {
            _loc1_ = RiotResourceLoader.getString(EMatchHistoryLocalization.LEGACY_XP_LABEL,"***" + EMatchHistoryLocalization.LEGACY_XP_LABEL,[this._model.stat.experienceEarned]);
            _loc2_ = ", ";
         }
         if(this._model.stat.ipEarned > 0)
         {
            _loc1_ += _loc2_;
            _loc1_ += RiotResourceLoader.getString(EMatchHistoryLocalization.LEGACY_IP_LABEL,"***" + EMatchHistoryLocalization.LEGACY_IP_LABEL,[this._model.stat.ipEarned]);
         }
         this._rewardText.setText(_loc1_);
      }
      
      private function loadIconRenderer() : void
      {
         this._championIcon.loadChampionIcon(this._model.champion);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1 + this._renderStyle);
      }
      
      override public function setData(param1:*) : void
      {
         this._model = param1 as MatchHistoryStatModel;
         this.updateData();
      }
      
      override public function getData() : *
      {
         return this._model;
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      private function setDominionRank() : void
      {
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this._model.stat.gameMutators,this._model.stat.gameMode);
         var _loc2_:String = _loc1_.getGameStatsType(this._model.stat.gameMapId);
         if(GameStatsType.DOMINION == _loc2_)
         {
            this._gameGold.setCurrentState(EMatchHistoryLinkage.GAME_GOLD_HIDE_STATE);
            if(this._model.dominionRank == 1)
            {
               this._dominionRank.setCurrentState(EMatchHistoryLinkage.DOMINION_FIRST_RANK);
            }
            else if(this._model.dominionRank == 2)
            {
               this._dominionRank.setCurrentState(EMatchHistoryLinkage.DOMINION_SECOND_RANK);
            }
            else if(this._model.dominionRank == 3)
            {
               this._dominionRank.setCurrentState(EMatchHistoryLinkage.DOMINION_THIRD_RANK);
            }
            this._kdaContainer.setCurrentState(EMatchHistoryLinkage.GAME_STAT_DOMINION_STATE);
         }
         else
         {
            this._kdaContainer.setCurrentState(EMatchHistoryLinkage.GAME_STAT_NORMAL_STATE);
            this._gameGold.setCurrentState(EMatchHistoryLinkage.GAME_GOLD_SHOW_STATE);
            this._dominionRank.setCurrentState(EMatchHistoryLinkage.DOMINION_NO_RANK);
         }
      }
      
      private function setRendererType() : void
      {
         var _loc4_:GameFlowVariant = null;
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:uint = uint(GameStatusLogicTable.determineGameResult(this._model.isVictory,this._model.stat.leaver,this._model.stat.invalid));
         switch(_loc3_)
         {
            case GameStatusLogicTable.LEAVER:
               _loc1_ = EMatchHistoryLinkage.STATE_LEAVER;
               _loc2_ = EMatchHistoryLocalization.GAME_LEAVER;
               break;
            case GameStatusLogicTable.LOSS_P:
               _loc1_ = EMatchHistoryLinkage.STATE_INVALID;
               _loc2_ = EMatchHistoryLocalization.GAME_INVALID;
               break;
            case GameStatusLogicTable.VICTORY:
               _loc1_ = EMatchHistoryLinkage.STATE_VICTORY;
               _loc2_ = EMatchHistoryLocalization.GAME_VICTORY;
               break;
            case GameStatusLogicTable.DEFEAT:
               _loc1_ = EMatchHistoryLinkage.STATE_DEFEAT;
               _loc2_ = EMatchHistoryLocalization.GAME_DEFEAT;
         }
         if(_loc2_ != null)
         {
            this._gameResult.setCurrentState(_loc1_);
            _loc4_ = GameFlowVariantFactory.instance.getVariant(this._model.stat.gameMutators,this._model.stat.gameMode);
            this._gameResultText.setText(_loc4_.getGameResultOverrideText(EMatchHistoryLocalization.BUNDLE_ID,_loc2_));
         }
      }
      
      private function setGameStatText() : void
      {
         this._mapName.setText(RiotResourceLoader.getMapResourceString(EMatchHistoryLocalization.MAP_NAME_PREFIX,this._model.stat.gameMapId,""));
         this._killScore.setText(this._model.killScore.toString());
         this._deathScore.setText(this._model.deathScore.toString());
         this._assistScore.setText(this._model.assistScore.toString());
         this._dominionScore.setText(this._model.dominionScore.toString());
         if(this._model.goldScore != null)
         {
            this._gameGold.setCurrentState(EMatchHistoryLinkage.GAME_GOLD_SHOW_STATE);
            this._gameGoldText.setText(getFormattedGold(this._model.goldScore));
         }
         else
         {
            this._gameGold.setCurrentState(EMatchHistoryLinkage.GAME_GOLD_HIDE_STATE);
         }
         this.setGameDate();
         this._gameTypeText.setText(RiotResourceLoader.getString(EMatchHistoryLocalization.LEGACY_GAME_TYPE_PREFIX + this._model.stat.gameTypeString,this._model.stat.gameTypeString));
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this._model.stat.gameMutators,this._model.stat.gameMode);
         this._gameModeText.setText(_loc1_.getGameFlowName());
      }
      
      private function setGameDate() : void
      {
         var _loc1_:Date = this._model.stat.createDate as Date;
         this._gameDate.setText(DateUtil.getDateString(_loc1_));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = super.updateLayout(param1,param2);
         this._gameTypeText.setX(this._gameResult.getX() + this._gameResultText.getTextWidth() + GAME_RESULT_PADDING);
         return _loc3_;
      }
   }
}

