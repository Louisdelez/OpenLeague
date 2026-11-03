package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.PrivacyListController;
   import com.riotgames.platform.gameclient.components.GradientTextField;
   import com.riotgames.platform.gameclient.configurations.PlayerInventoryConfig;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.PlayerStat;
   import com.riotgames.platform.gameclient.domain.RawStatType;
   import com.riotgames.platform.gameclient.domain.game.practice.Team;
   import com.riotgames.platform.gameclient.utils.RiotNumberFormatter;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImages;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.game.variants.GameStatsType;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextFieldAutoSize;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.controls.FlexNativeMenu;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.core.FlexBitmap;
   import mx.events.FlexNativeMenuEvent;
   import mx.events.ToolTipEvent;
   
   public class EndOfGameScoreboardPlayerRenderer extends Canvas
   {
      
      private static const LARGE_ICON_SIZE:uint = 32;
      
      private static const SMALL_ICON_SIZE:uint = 24;
      
      private var kdaDisplay:GradientTextField;
      
      [Inject]
      public var privacyListController:PrivacyListController;
      
      private var _selected:Boolean = false;
      
      [Inject]
      public var applicationController:IAppController;
      
      private var championName:Label;
      
      private var isUserBlocked:Boolean = false;
      
      private var inventoryController:IInventoryController;
      
      [Inject]
      public var chatController:ChatController;
      
      private var userIsParticipant:Boolean = true;
      
      private var staySelected:Boolean = false;
      
      private var showAddFriend:Boolean = false;
      
      private var itemContextMenu:FlexNativeMenu;
      
      private var summonerImage:Image;
      
      private var isBot:Boolean = false;
      
      private var menuXML:XML = <root>
				<menuitem label='**Add Buddy' data='addBudy'/>
				<menuitem label='**Block' data='blockUser'/>
				<menuitem label='**Report Player' data='reportPlayer'/>
			</root>;
      
      private var showHandCursorOnPlayer:Boolean = true;
      
      private var isBuddy:Boolean = false;
      
      private var goldDisplay:GradientTextField;
      
      private var goldFormatter:RiotNumberFormatter;
      
      private var scoreDisplay:GradientTextField;
      
      private var showReportAPlayer:Boolean = true;
      
      public var endOfGameStatsController:EndOfGameStatsController;
      
      private var levelText:GradientTextField;
      
      private var champImage:Image;
      
      private var pointsInfoDisplay:GradientTextField;
      
      private var isMe:Boolean = false;
      
      private var gameItemRenderers:ArrayCollection;
      
      private var minionDisplay:GradientTextField;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      private var gameItemRendererFactory:GameItemRendererFactory;
      
      private var reportEnabled:Boolean = true;
      
      private var spellItemRenderers:ArrayCollection;
      
      private var rendererY:int = -1;
      
      private var summonerName:Label;
      
      private var rendererX:int = -1;
      
      public function EndOfGameScoreboardPlayerRenderer(param1:PlayerParticipantStatsSummary, param2:EndOfGameStatsController, param3:Boolean = true)
      {
         super();
         this.endOfGameStatsController = param2;
         this.clipContent = false;
         this.width = 805;
         this.height = 38;
         this.goldFormatter = new RiotNumberFormatter();
         this.goldFormatter.precision = 1;
         this.goldFormatter.rounding = "none";
         this.setStyle("backgroundColor",16777215);
         this.setStyle("backgroundAlpha",0);
         this.userIsParticipant = param3;
         this.data = param1;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
      }
      
      private function onContextMenuClick(param1:FlexNativeMenuEvent) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:int = int(param1.index);
         var _loc3_:PlayerParticipantStatsSummary = this.data as PlayerParticipantStatsSummary;
         var _loc4_:String = ChatController.jidFromSummonerId(_loc3_.userId);
         if(_loc2_ == 0)
         {
            this.onAddBuddyClick();
         }
         else if(_loc2_ == 1)
         {
            _loc5_ = Boolean(param1.nativeMenuItem.checked);
            if(_loc5_)
            {
               if(this.privacyListController.unblock(_loc4_))
               {
                  this.isUserBlocked = false;
                  this.showAddFriend = true;
               }
            }
            else
            {
               this.privacyListController.blockAndConfirm(_loc4_,_loc3_.summonerName,this.onBlockAndConfirm);
            }
         }
         else if(_loc2_ == 2)
         {
            this.onReportButtonClicked();
         }
      }
      
      private function renderScoreDisplay(param1:int, param2:int) : void
      {
         if(this.scoreDisplay)
         {
            this.removeChild(this.scoreDisplay);
         }
         this.scoreDisplay = new GradientTextField();
         this.scoreDisplay.width = 50;
         this.scoreDisplay.x = param1;
         this.scoreDisplay.y = param2;
         this.scoreDisplay.textAlign = TextFieldAutoSize.CENTER;
         this.scoreDisplay.setStyle("fontFamily","ApplicationFont2");
         this.scoreDisplay.setStyle("fontSize",16);
         this.scoreDisplay.setStyle("fillColors",GradientTextField.GOLD_COLORS);
         var _loc3_:PlayerStat = PlayerStat.findStat(RawStatType.TOTAL_PLAYER_SCORE,data.statistics);
         if(_loc3_)
         {
            this.scoreDisplay.text = _loc3_.value.toString();
            this.scoreDisplay.toolTip = _loc3_.displayName;
         }
         this.addChild(this.scoreDisplay);
      }
      
      private function renderPointsInfoDisplay(param1:int, param2:int) : void
      {
         var _loc5_:GameFlowVariant = null;
         if(this.pointsInfoDisplay)
         {
            this.removeChild(this.pointsInfoDisplay);
         }
         if(this.endOfGameStatsController.endOfGameStats != null)
         {
            _loc5_ = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
            if(!_loc5_.showPointsInfo())
            {
               return;
            }
         }
         this.pointsInfoDisplay = new GradientTextField();
         this.pointsInfoDisplay.width = 50;
         this.pointsInfoDisplay.x = param1;
         this.pointsInfoDisplay.y = param2;
         this.pointsInfoDisplay.textAlign = TextFieldAutoSize.CENTER;
         this.pointsInfoDisplay.setStyle("fontFamily","ApplicationFont2");
         this.pointsInfoDisplay.setStyle("fontSize",16);
         this.pointsInfoDisplay.setStyle("fillColors",GradientTextField.SILVER_COLORS);
         var _loc3_:PlayerStat = PlayerStat.findStat(RawStatType.NODE_CAPTURE,data.statistics);
         var _loc4_:PlayerStat = PlayerStat.findStat(RawStatType.NODE_NEUTRALIZE,data.statistics);
         if(_loc4_)
         {
            this.pointsInfoDisplay.text = _loc3_.value.toString() + "/" + _loc4_.value.toString();
            this.pointsInfoDisplay.toolTip = RiotResourceLoader.getString("dominion_points_captured_or_neutralized");
         }
         this.addChild(this.pointsInfoDisplay);
      }
      
      private function localizeContextMenuXML() : void
      {
         this.menuXML.menuitem[0].@label = RiotResourceLoader.getString("BuddyListTreeRenderer_groupAddBuddy");
         this.menuXML.menuitem[1].@label = RiotResourceLoader.getString("summonerContext_blockUser_label");
         this.menuXML.menuitem[2].@label = RiotResourceLoader.getString("summonerContext_reportPlayer_label");
      }
      
      private function onContextMenuShow(param1:FlexNativeMenuEvent) : void
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:String = null;
         this.staySelected = true;
         if(this.isMe || this.isBot)
         {
            param1.nativeMenu.removeAllItems();
            return;
         }
         if(!this.showReportAPlayer)
         {
            if(param1.nativeMenu.numItems > 2)
            {
               param1.nativeMenu.removeItemAt(2);
            }
         }
         if(this.data is PlayerParticipantStatsSummary)
         {
            _loc2_ = this.data as PlayerParticipantStatsSummary;
            _loc3_ = ChatController.jidFromSummonerId(_loc2_.userId);
            this.isUserBlocked = this.privacyListController.isBlocked(_loc3_);
            param1.nativeMenu.getItemAt(1).checked = this.isUserBlocked;
            param1.nativeMenu.getItemAt(0).enabled = !this.isMe && this.showAddFriend;
            if((!this.isPlayerReportable() || !this.endOfGameStatsController.localPlayer) && param1.nativeMenu.numItems > 2)
            {
               param1.nativeMenu.getItemAt(2).enabled = false;
            }
         }
         else
         {
            param1.nativeMenu.getItemAt(0).enabled = false;
         }
      }
      
      private function onReportButtonClicked() : void
      {
         var _loc1_:PlayerParticipantStatsSummary = this.data as PlayerParticipantStatsSummary;
         this.endOfGameStatsController.reportPlayer(_loc1_);
      }
      
      private function renderSpells(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         if(Boolean(this.spellItemRenderers) && this.spellItemRenderers.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.spellItemRenderers.length)
            {
               this.removeChild(this.spellItemRenderers.getItemAt(_loc4_) as DisplayObject);
               _loc4_++;
            }
         }
         this.spellItemRenderers = new ArrayCollection();
         var _loc3_:SpellItemRenderer = new SpellItemRenderer();
         _loc3_.inventory = this.endOfGameStatsController.inventory;
         _loc3_.data = data.spell1Id;
         _loc3_.x = param1;
         _loc3_.y = param2;
         _loc3_.width = SMALL_ICON_SIZE;
         _loc3_.height = SMALL_ICON_SIZE;
         this.addChild(_loc3_);
         this.spellItemRenderers.addItem(_loc3_);
         _loc3_ = new SpellItemRenderer();
         _loc3_.inventory = this.endOfGameStatsController.inventory;
         _loc3_.data = data.spell2Id;
         _loc3_.x = param1 + 32;
         _loc3_.y = param2;
         _loc3_.width = SMALL_ICON_SIZE;
         _loc3_.height = SMALL_ICON_SIZE;
         this.addChild(_loc3_);
         this.spellItemRenderers.addItem(_loc3_);
      }
      
      private function createContextMenu() : void
      {
         this.itemContextMenu = new FlexNativeMenu();
         this.itemContextMenu.labelField = "@label";
         this.itemContextMenu.showRoot = false;
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK,this.onContextMenuClick);
         this.itemContextMenu.addEventListener(FlexNativeMenuEvent.MENU_SHOW,this.onContextMenuShow);
         this.itemContextMenu.setContextMenu(this);
         if(!this.isMe)
         {
            this.itemContextMenu.dataProvider = this.menuXML;
         }
         this.localizeContextMenuXML();
      }
      
      private function isPlayerReportable() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:PlayerParticipantStatsSummary = this.data as PlayerParticipantStatsSummary;
         if(_loc2_ != null)
         {
            _loc1_ = this.isMe || Boolean(this.applicationController.reportTracker.isReported(_loc2_.summonerName));
         }
         return !_loc1_;
      }
      
      private function onPlayerReported() : void
      {
         this.reportEnabled = false;
      }
      
      private function onAddBuddyClick() : void
      {
         this.chatController.addBuddy(this.data.summonerName);
         this.showAddFriend = false;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         if(this.staySelected)
         {
            this._selected = true;
            this.staySelected = false;
         }
         if(this._selected)
         {
            this.setStyle("backgroundAlpha",0.09);
         }
         else
         {
            this.setStyle("backgroundAlpha",0);
         }
      }
      
      private function createPlayerTooltip(param1:ToolTipEvent) : void
      {
         var _loc2_:EndOfGamePlayerTooltip = new EndOfGamePlayerTooltip();
         _loc2_.endOfGameStatsController = this.endOfGameStatsController;
         _loc2_.data = this.data;
         param1.toolTip = _loc2_;
      }
      
      private function renderKDADisplay(param1:int, param2:int) : void
      {
         if(this.kdaDisplay)
         {
            removeChild(this.kdaDisplay);
         }
         this.kdaDisplay = new GradientTextField();
         this.kdaDisplay.width = 75;
         this.kdaDisplay.x = param1;
         this.kdaDisplay.y = param2;
         this.kdaDisplay.textAlign = TextFieldAutoSize.CENTER;
         this.kdaDisplay.setStyle("fontFamily","ApplicationFont2");
         this.kdaDisplay.setStyle("fontSize",16);
         this.kdaDisplay.setStyle("fillColors",GradientTextField.PLATINUM_COLORS);
         var _loc3_:PlayerStat = PlayerStat.findStat(RawStatType.CHAMPION_KILLS,data.statistics);
         var _loc4_:PlayerStat = PlayerStat.findStat(RawStatType.DEATHS,data.statistics);
         var _loc5_:PlayerStat = PlayerStat.findStat(RawStatType.ASSISTS,data.statistics);
         if(Boolean(_loc3_) && Boolean(_loc4_) && Boolean(_loc5_))
         {
            this.kdaDisplay.text = _loc3_.value.toString() + "/" + _loc4_.value.toString() + "/" + _loc5_.value.toString();
            this.updateKDAToolTip();
         }
         this.addChild(this.kdaDisplay);
      }
      
      private function renderGoldDisplay(param1:int, param2:int) : void
      {
         if(this.goldDisplay)
         {
            removeChild(this.goldDisplay);
         }
         this.goldDisplay = new GradientTextField();
         this.goldDisplay.width = 60;
         this.goldDisplay.x = param1;
         this.goldDisplay.y = param2;
         this.goldDisplay.textAlign = TextFieldAutoSize.CENTER;
         this.goldDisplay.setStyle("fontFamily","ApplicationFont2");
         this.goldDisplay.setStyle("fontSize",16);
         this.goldDisplay.setStyle("fillColors",GradientTextField.GOLD_COLORS);
         var _loc3_:PlayerStat = PlayerStat.findStat(RawStatType.GOLD_EARNED,data.statistics);
         if(_loc3_)
         {
            if(_loc3_.value < 1000000)
            {
               this.goldDisplay.text = this.goldFormatter.format(_loc3_.value * 0.001) + "k";
            }
            else
            {
               this.goldDisplay.text = this.goldFormatter.format(_loc3_.value * 0.000001) + "M";
            }
            this.goldDisplay.toolTip = _loc3_.displayName;
         }
         else
         {
            this.goldDisplay.text = "0k";
         }
         this.addChild(this.goldDisplay);
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventoryController = param1.getInventoryController();
         this.gameItemRendererFactory = new GameItemRendererFactory(this.inventoryController);
         if(this.rendererX > -1 && this.rendererY > -1)
         {
            this.renderItems(this.rendererX,this.rendererY);
            this.rendererX = this.rendererY = -1;
         }
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.initializeChatInfo();
         this.createContextMenu();
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:PlayerParticipantStatsSummary = null;
         var _loc3_:Boolean = false;
         var _loc4_:GameFlowVariant = null;
         var _loc5_:BitmapData = null;
         if(this.data === param1)
         {
            return;
         }
         super.data = param1;
         if(param1 is PlayerParticipantStatsSummary)
         {
            _loc2_ = param1 as PlayerParticipantStatsSummary;
            this.renderCommonInfo();
            _loc3_ = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
            if(_loc3_)
            {
               this.renderKDADisplay(285,7);
               this.renderSpells(367,7);
               this.renderItems(441,7);
               this.renderPointsInfoDisplay(695,7);
               this.renderScoreDisplay(757,7);
            }
            else
            {
               this.renderKDADisplay(290,7);
               this.renderSpells(395,7);
               this.renderItems(476,7);
               this.renderGoldDisplay(700,7);
               this.renderMinionDisplay(758,7);
            }
            if(_loc2_.isMe)
            {
               this.summonerName.setStyle("color",16764672);
               this.championName.setStyle("color",16764672);
            }
            else
            {
               this.summonerName.setStyle("color",15658734);
               this.championName.setStyle("color",15658734);
            }
            this.champImage.source = ChampionImages.getIconPath(_loc2_.skinName);
            this.champImage.toolTip = RiotResourceLoader.getChampionResourceString("name",_loc2_.skinName,_loc2_.skinName);
            _loc4_ = GameFlowVariantFactory.instance.getVariant(this.endOfGameStatsController.endOfGameStats.gameMutators,this.endOfGameStatsController.endOfGameStats.gameMode);
            _loc2_ = this.data as PlayerParticipantStatsSummary;
            _loc5_ = BuddyImages.getSummonerIconSafely(_loc4_.getEndOfGameProfileIcon(_loc2_));
            this.summonerImage.source = new FlexBitmap(_loc5_,"auto",true);
         }
      }
      
      private function renderItems(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:GameItemRenderer = null;
         if(!this.gameItemRendererFactory)
         {
            this.rendererX = param1;
            this.rendererY = param2;
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
            return;
         }
         if(Boolean(this.gameItemRenderers) && this.gameItemRenderers.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < this.gameItemRenderers.length)
            {
               this.removeChild(this.gameItemRenderers.getItemAt(_loc4_) as GameItemRenderer);
               _loc4_++;
            }
            this.gameItemRenderers.removeAll();
         }
         if(!this.gameItemRenderers)
         {
            this.gameItemRenderers = new ArrayCollection();
         }
         var _loc3_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ < data.gameItems.length)
            {
               _loc5_ = this.gameItemRendererFactory.getRenderer(data.gameItems[_loc4_]);
            }
            else
            {
               _loc5_ = this.gameItemRendererFactory.getRenderer(GameItemRenderer.EMPTY_ITEM_SLOT);
            }
            _loc5_.x = param1 + _loc4_ * 32;
            _loc5_.y = param2;
            _loc5_.width = SMALL_ICON_SIZE;
            _loc5_.height = SMALL_ICON_SIZE;
            _loc5_.glowEnabled = true;
            this.addChild(_loc5_);
            this.gameItemRenderers.addItem(_loc5_);
            _loc4_++;
         }
      }
      
      private function initializeChatInfo() : void
      {
         var _loc1_:PlayerParticipantStatsSummary = null;
         var _loc2_:String = null;
         if(Boolean(this.data) && Boolean(this.privacyListController))
         {
            _loc1_ = this.data as PlayerParticipantStatsSummary;
            _loc2_ = ChatController.jidFromSummonerId(_loc1_.userId);
            this.isMe = this.privacyListController.isMe(_loc2_);
            this.isUserBlocked = this.privacyListController.isBlocked(_loc2_);
            this.isBuddy = this.chatController.isSummonerBuddy(_loc1_.summonerName);
            this.showAddFriend = !this.isBuddy && !this.isMe && !this.isUserBlocked && Boolean(this.chatController.canAddBuddyToBuddyList) && !_loc1_.isBotPlayer();
            this.showHandCursorOnPlayer = !_loc1_.isBotPlayer();
            this.isBot = _loc1_.isBotPlayer();
            this.reportEnabled = true;
            this.showReportAPlayer = Boolean(this.clientConfig.reportAPlayerAvailable) && !this.isBot && !this.isMe;
         }
      }
      
      private function updateKDAToolTip() : void
      {
         var _loc1_:Boolean = GameStatsType.DOMINION == this.endOfGameStatsController.getCurrentStatsType();
         if(_loc1_)
         {
            this.kdaDisplay.toolTip = RiotResourceLoader.getStatResourceString("CHAMPION_KDA_DOMINION","k/d/a DOMINION");
         }
         else
         {
            this.kdaDisplay.toolTip = RiotResourceLoader.getStatResourceString("CHAMPION_KDA_CLASSIC","k/d/a");
         }
      }
      
      private function renderCommonInfo() : void
      {
         this.champImage = new Image();
         this.champImage.x = 3;
         this.champImage.y = 3;
         this.champImage.height = LARGE_ICON_SIZE;
         this.champImage.width = LARGE_ICON_SIZE;
         this.addChild(this.champImage);
         this.levelText = new GradientTextField();
         this.levelText.width = 40;
         this.levelText.x = 26;
         this.levelText.y = 7;
         this.levelText.textAlign = TextFieldAutoSize.CENTER;
         this.levelText.setStyle("fontFamily","ApplicationFont2");
         this.levelText.setStyle("fontSize",16);
         this.levelText.setStyle("fillColors",GradientTextField.PLATINUM_COLORS);
         var _loc1_:PlayerStat = PlayerStat.findStat(RawStatType.LEVEL,data.statistics,true);
         if(_loc1_)
         {
            this.levelText.text = _loc1_.value.toString();
            this.levelText.toolTip = _loc1_.displayName;
         }
         else
         {
            this.levelText.text = "0";
         }
         this.addChild(this.levelText);
         this.summonerImage = new Image();
         this.summonerImage.x = 60;
         this.summonerImage.y = 7;
         this.summonerImage.width = SMALL_ICON_SIZE;
         this.summonerImage.height = SMALL_ICON_SIZE;
         this.addChild(this.summonerImage);
         var _loc2_:Number = this.data.teamId == Team.TEAM_ID_BLUE ? 5082111 : 10702335;
         var _loc3_:Number = this.data.teamId == Team.TEAM_ID_BLUE ? 3 : 2;
         var _loc4_:GlowFilter = new GlowFilter(_loc2_,0.5,8,8,_loc3_);
         this.summonerName = new Label();
         this.summonerName.x = 88;
         this.summonerName.y = 1;
         this.summonerName.height = 25;
         this.summonerName.text = PlayerParticipantStatsSummary(data).teamTagText + data.summonerName;
         this.summonerName.setStyle("fontSize",14);
         this.summonerName.setStyle("color",15658734);
         this.summonerName.filters = [_loc4_];
         this.addChild(this.summonerName);
         this.championName = new Label();
         this.championName.x = 88;
         this.championName.y = 16;
         this.championName.height = 25;
         this.championName.text = RiotResourceLoader.getChampionResourceString("name",data.skinName,"**" + data.skinName);
         this.championName.setStyle("fontSize",14);
         this.championName.setStyle("color",15658734);
         this.championName.filters = [_loc4_];
         this.addChild(this.championName);
         var _loc5_:Canvas = new Canvas();
         _loc5_.x = this.summonerImage.x;
         _loc5_.y = 4;
         _loc5_.width = 150;
         _loc5_.height = this.height - 8;
         _loc5_.toolTip = "**unused";
         _loc5_.addEventListener(ToolTipEvent.TOOL_TIP_CREATE,this.createPlayerTooltip,false,0,true);
         this.addChild(_loc5_);
      }
      
      private function onBlockAndConfirm(param1:Boolean) : void
      {
         if(param1)
         {
            this.isUserBlocked = true;
            this.showAddFriend = false;
         }
      }
      
      private function renderMinionDisplay(param1:int, param2:int) : void
      {
         if(this.minionDisplay)
         {
            this.removeChild(this.minionDisplay);
         }
         this.minionDisplay = new GradientTextField();
         this.minionDisplay.width = 60;
         this.minionDisplay.x = param1;
         this.minionDisplay.y = param2;
         this.minionDisplay.textAlign = TextFieldAutoSize.CENTER;
         this.minionDisplay.setStyle("fontFamily","ApplicationFont2");
         this.minionDisplay.setStyle("fontSize",16);
         this.minionDisplay.setStyle("fillColors",GradientTextField.PLATINUM_COLORS);
         var _loc3_:PlayerStat = PlayerStat.findStat(RawStatType.MINIONS_KILLED,data.statistics);
         var _loc4_:PlayerStat = PlayerStat.findStat(RawStatType.NEUTRAL_MINIONS_KILLED,data.statistics);
         var _loc5_:int = 0;
         if(_loc3_)
         {
            _loc5_ += _loc3_.value;
            this.minionDisplay.toolTip = _loc3_.displayName;
         }
         if(_loc4_)
         {
            _loc5_ += _loc4_.value;
         }
         this.minionDisplay.text = _loc5_.toString();
         this.addChild(this.minionDisplay);
      }
   }
}

