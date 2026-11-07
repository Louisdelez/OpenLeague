package com.riotgames.pvpnet.matchhistoryiron.legacyviews
{
   import blix.assets.proxy.InteractiveObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.ds.IListX;
   import blix.ds.ListX;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.configurations.PlayerInventoryConfig;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLinkage;
   import com.riotgames.pvpnet.matchhistoryiron.enum.EMatchHistoryLocalization;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer.MatchHistoryItemIconRenderer;
   import com.riotgames.pvpnet.matchhistoryiron.legacyviews.renderer.MatchHistoryItemTooltip;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.watch.IWatchReplayButton;
   import com.riotgames.pvpnet.watch.WatchReplayButtonTypes;
   import com.riotgames.pvpnet.watch.WatchTabProviderProxy;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MatchHistoryStatContainerLegacyView extends StatefulView
   {
      
      private var _itemList:Vector.<MatchHistoryItemIconRenderer>;
      
      private var _gameStatContainer:MatchHistoryStatDataGroupLegacyView;
      
      private var _kdaContainer:StatefulView;
      
      private var _killScore:TextFieldProxy;
      
      private var _deathScore:TextFieldProxy;
      
      private var _assistScore:TextFieldProxy;
      
      private var _dominionScore:TextFieldProxy;
      
      private var _statContainerSizer:SpriteProxy;
      
      private var _replayButtonContainer:SpriteProxy;
      
      private var _title:TextFieldProxy;
      
      private var _instructionText:TextFieldProxy;
      
      private var _downloadReplayButton:IWatchReplayButton;
      
      private var _model:MatchHistoryStatModel;
      
      private var _size:Point = new Point();
      
      private var replaysforMatchHistoryEnabled:Boolean = false;
      
      private var _adjustedContainerHeight:Number;
      
      public function MatchHistoryStatContainerLegacyView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._gameStatContainer = new MatchHistoryStatDataGroupLegacyView(this);
         this._kdaContainer = new StatefulView(this);
         this._killScore = new TextFieldProxy(this);
         this._deathScore = new TextFieldProxy(this);
         this._assistScore = new TextFieldProxy(this);
         this._dominionScore = new TextFieldProxy(this);
         this._title = new TextFieldProxy(this);
         this._instructionText = new TextFieldProxy(this);
         this._statContainerSizer = new SpriteProxy(this);
         this._statContainerSizer.getAssetChanged().addOnce(this.measureAssets);
         this._gameStatContainer.getLayoutInvalidated().add(invalidateLayout);
         this._replayButtonContainer = new SpriteProxy(this);
         this._replayButtonContainer.getAssetChanged().addOnce(this.measureAssets);
         this.setTimelineChildren();
         this.localizeText();
         setCurrentState(EMatchHistoryLinkage.STATE_STAT_INTRO);
         this._kdaContainer.setCurrentState(EMatchHistoryLinkage.GAME_STAT_NORMAL_STATE);
         this.createItemIconRenderer();
         ClientConfig.instance.getReplaySystemStatesChanged().add(this.updateReplayButton);
      }
      
      private function localizeText() : void
      {
         var _loc1_:String = "<font Color=\'#0099ff\'>";
         var _loc2_:String = "</font>";
         this._instructionText.setHtmlText(RiotResourceLoader.getString(EMatchHistoryLocalization.INSTRUCTION_LABEL,"**" + EMatchHistoryLocalization.INSTRUCTION_LABEL,[_loc1_,_loc2_]));
         this._title.setText(EMatchHistoryLocalization.getLocalizedString(EMatchHistoryLocalization.STAT_CONTAINER_TITLE));
      }
      
      private function setTimelineChildren() : void
      {
         setTimelineChildByName(EMatchHistoryLinkage.STAT_GAME_STAT,this._gameStatContainer);
         setTimelineChildByName(EMatchHistoryLinkage.KDA_CONTAINER,this._kdaContainer);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_KILL_SCORE_OLD_TEXT,this._killScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_DEATH_SCORE_OLD_TEXT,this._deathScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_ASSISTS_SCORE_OLD_TEXT,this._assistScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_DOMINION_SCORE_OLD_TEXT,this._dominionScore);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_CONTAINER_SIZER,this._statContainerSizer);
         setTimelineChildByName(EMatchHistoryLinkage.STAT_CONTAINER_TITLE,this._title);
         setTimelineChildByName(EMatchHistoryLinkage.INSTRUCTION_TEXT,this._instructionText);
         setTimelineChildByName(EMatchHistoryLinkage.REPLAY_BUTTON_CONTAINER,this._replayButtonContainer);
      }
      
      public function updateView(param1:MatchHistoryStatModel) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
            this.populateStatView();
            this.setGameType();
            this.setGameStat();
            this.loadItemIconRenderer();
            this.updateReplayButton();
         }
         setCurrentState(EMatchHistoryLinkage.STATE_STAT_DISPLAY);
         invalidateLayout();
      }
      
      private function setGameStat() : void
      {
         this._killScore.setText(this._model.killScore.toString());
         this._deathScore.setText(this._model.deathScore.toString());
         this._assistScore.setText(this._model.assistScore.toString());
         this._dominionScore.setText(this._model.dominionScore.toString());
      }
      
      private function measureAssets() : void
      {
         if(this._statContainerSizer.getAsset() != null)
         {
            this._size.x = this._statContainerSizer.getWidth();
            this._size.y = this._statContainerSizer.getHeight();
            this._adjustedContainerHeight = this._size.y;
            if(this._replayButtonContainer.getAsset() != null)
            {
               this._adjustedContainerHeight = this._replayButtonContainer.getAsset().y - this._statContainerSizer.getAsset().y - 5;
            }
            invalidateLayout();
         }
      }
      
      private function setGameType() : void
      {
         var _loc1_:GameFlowVariant = GameFlowVariantFactory.instance.getVariant(this._model.stat.gameMutators,this._model.stat.gameMode);
         var _loc2_:String = _loc1_.getGameStatsType(this._model.stat.gameMapId);
         if(GameStatsType.DOMINION == _loc2_)
         {
            this._kdaContainer.setCurrentState(EMatchHistoryLinkage.GAME_STAT_DOMINION_STATE);
         }
         else
         {
            this._kdaContainer.setCurrentState(EMatchHistoryLinkage.GAME_STAT_NORMAL_STATE);
         }
      }
      
      private function createItemIconRenderer() : void
      {
         var _loc3_:MatchHistoryItemIconRenderer = null;
         this._itemList = new Vector.<MatchHistoryItemIconRenderer>();
         var _loc1_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = new MatchHistoryItemIconRenderer(this);
            setTimelineChildByName(EMatchHistoryLinkage.STAT_ITEM_PRE_FIXE + _loc2_,_loc3_);
            this._itemList.push(_loc3_);
            _loc2_++;
         }
      }
      
      private function loadItemIconRenderer() : void
      {
         var _loc1_:int = int(this._model.itemList.length);
         var _loc2_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            unassignToolTip(this._itemList[_loc3_] as InteractiveObjectProxy);
            if(_loc3_ < _loc1_)
            {
               this._itemList[_loc3_].loadItemVisual(this._model.itemList[_loc3_]);
               TipsProviderProxy.instance.assignCustomToolTip(this._itemList[_loc3_] as InteractiveObjectProxy,this._model.itemList[_loc3_],MatchHistoryItemTooltip);
            }
            else
            {
               this._itemList[_loc3_].loadIconEmptyVisual();
            }
            _loc3_++;
         }
      }
      
      private function populateStatView() : void
      {
         var _loc1_:Array = [];
         var _loc2_:int = int(this._model.statRendererModelList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.push(this._model.statRendererModelList[_loc3_]);
            _loc3_++;
         }
         var _loc4_:IListX = new ListX(_loc1_);
         this._gameStatContainer.setDataProvider(_loc4_);
      }
      
      private function updateReplayButton() : void
      {
         this.replaysforMatchHistoryEnabled = Boolean(WatchTabProviderProxy.instance.isEnabled()) && Boolean(ClientConfig.instance.replaySystemStates.matchHistoryEnabled);
         if(this._downloadReplayButton)
         {
            this._downloadReplayButton.removeFromParent();
            this._downloadReplayButton = null;
         }
         if(this.replaysforMatchHistoryEnabled && this._model != null && this._model.stat != null)
         {
            this._downloadReplayButton = WatchTabProviderProxy.instance.createWatchButton(WatchReplayButtonTypes.MATCH_HISTORY,null,this._model.stat.gameId,null,this.replaysforMatchHistoryEnabled,false,this._model.isLocalSummoner);
            this._downloadReplayButton.addToParent(this._replayButtonContainer);
         }
         invalidateLayout();
      }
      
      public function cleanView() : void
      {
         setCurrentState(EMatchHistoryLinkage.STATE_STAT_INTRO);
         this._gameStatContainer.setDataProvider(new ListX([]));
         this._gameStatContainer.invalidateCache();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = this.replaysforMatchHistoryEnabled ? this._adjustedContainerHeight : this._size.y;
         this._gameStatContainer.setExplicitSize(this._size.x,_loc3_);
         this._gameStatContainer.setScrollRect(new Rectangle(0,0,this._size.x,_loc3_));
         return super.updateLayout(param1,param2);
      }
   }
}

