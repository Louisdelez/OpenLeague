package com.riotgames.platform.gameclient.controllers.lobby
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.commands.featuredgame.FeaturedGameMetadataActions;
   import com.riotgames.platform.gameclient.commands.queueselection.SelectCapQueueCommand;
   import com.riotgames.platform.gameclient.commands.queueselection.SelectCoopVsAIQueueCommand;
   import com.riotgames.platform.gameclient.commands.queueselection.SelectNormalQueueCommand;
   import com.riotgames.platform.gameclient.commands.queueselection.SelectRankedQueue;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.featuredgame.FeaturedGameMetadataDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameOptionsList;
   import com.riotgames.platform.gameclient.domain.game.GamePropertiesListData;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameFlowViewLayoutDefinition;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.GameConfig;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParametersFactory;
   import com.riotgames.pvpnet.game.controllers.shutdown.ShutdownTimingTables;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.IInviteRankedTeamController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.binding.utils.ChangeWatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResourceEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   import mx.resources.ResourceManager;
   
   public class ChooseGameFlowViewController extends EventDispatcher implements IChooseGameFlowViewProvider
   {
      
      public static const COMMAND_JOIN:String = "join";
      
      public static const COMMAND_CREATE:String = "create";
      
      public static const COMMAND_BASIC_TUTORIAL:String = "basic_tutorial";
      
      public static const COMMAND_ADVANCED_TUTORIAL:String = "advanced_tutorial";
      
      public static const PARTY_QUEUE_PARTY:String = "party";
      
      public static const PARTY_QUEUE_DUO:String = "duo";
      
      public static const PARTY_QUEUE_TEAM:String = "team";
      
      private var _269543472masterGameController:MasterGameController;
      
      private var registeredViewStartupFunctions:ArrayCollection = new ArrayCollection();
      
      private var _1039200330selectionList:ArrayCollection = new ArrayCollection();
      
      public var applicationController:IAppController;
      
      private var _gameModeDisplayDescription:String;
      
      private var _gameMapDisplayDescription:String;
      
      private var inviteProvider:IInviteProvider;
      
      public var rankedTeamManagementController:IInviteRankedTeamController;
      
      private var _1895424275clientConfig:ClientConfig;
      
      private var hasDisplayedFWOTDLimitedInformationOnce:Boolean = false;
      
      private var inventory:IInventory;
      
      private var _821547127queueOptionsListCollection:Array = new Array();
      
      public var inviteController:IInviteController;
      
      public var defaultSelections:Array = [0,0];
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session = Session.instance;
      
      private var _1072127278animationsEnabled:Boolean = true;
      
      private var _gameMapDisplayName:String;
      
      private var rankedTeamPlayerWatcher:ChangeWatcher = null;
      
      public var pendingSelection:Array;
      
      private var _gameModeDisplayName:String;
      
      private var _onOptionsListsUpdated:Signal = new Signal();
      
      private var _gameQueueManager:GameQueueManager;
      
      private var gameModelWatcherArray:ArrayCollection = new ArrayCollection();
      
      public function ChooseGameFlowViewController(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get gameMapDisplayName() : String
      {
         return this._gameMapDisplayName;
      }
      
      [Bindable(event="propertyChange")]
      public function set gameMapDisplayName(param1:String) : void
      {
         var _loc2_:Object = this.gameMapDisplayName;
         if(_loc2_ !== param1)
         {
            this._1671139325gameMapDisplayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMapDisplayName",_loc2_,param1));
         }
      }
      
      private function onGameModelChange(param1:PropertyChangeEvent) : void
      {
         this.unwatchGameModel();
         if(param1.newValue != null)
         {
            this.watchGameModel();
         }
      }
      
      private function refreshOptionsLists() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.queueOptionsListCollection.length)
         {
            this.refreshItem(this.queueOptionsListCollection[_loc1_]);
            _loc1_++;
         }
         if(this.pendingSelection == null || Boolean(this.pendingSelection && this.pendingSelection.length > 0) && Boolean(this.pendingSelection[0] == 0))
         {
            if(this.queueOptionsListCollection[0].isAspirational)
            {
               if(this.queueOptionsListCollection[1].isAspirational)
               {
                  this.pendingSelection = [2];
               }
               else
               {
                  this.pendingSelection = [1,0,0,0];
               }
            }
         }
         this._onOptionsListsUpdated.dispatch();
      }
      
      public function getOnOptionsListsUpdated() : ISignal
      {
         return this._onOptionsListsUpdated;
      }
      
      private function get isPracticeGame() : Boolean
      {
         var _loc1_:GameModel = this.masterGameController.gameModel;
         return _loc1_ != null ? Boolean(PracticeGameParametersFactory.instance.isCustomGame(_loc1_.gameMode)) : false;
      }
      
      private function meetsQueuePrerequisites(param1:GamePropertiesListData, param2:XML) : Boolean
      {
         if(!param1.meetsQueuePrerequisites)
         {
            param2.@showAspirationalStep = true;
            param2.@message = param1.queuePrerequisiteNotMetMessage;
            param2.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_queue_level_tip_header");
            param2.@messageTipBody = param1.queuePrerequisiteNotMetTipMessage;
         }
         return param1.meetsQueuePrerequisites;
      }
      
      private function unwatchGameModel() : void
      {
         var _loc1_:ChangeWatcher = null;
         for each(_loc1_ in this.gameModelWatcherArray)
         {
            _loc1_.unwatch();
         }
         this.gameModelWatcherArray.removeAll();
      }
      
      private function userOwnsEnoughChampionsToDraft(param1:Boolean) : Boolean
      {
         var _loc4_:Champion = null;
         var _loc2_:Array = this.inventory.championRegistry;
         var _loc3_:int = 0;
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.isAvailable(param1))
            {
               _loc3_++;
            }
         }
         return _loc3_ >= GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT;
      }
      
      public function set queueOptionsListCollection(param1:Array) : void
      {
         var _loc2_:Object = this._821547127queueOptionsListCollection;
         if(_loc2_ !== param1)
         {
            this._821547127queueOptionsListCollection = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueOptionsListCollection",_loc2_,param1));
         }
      }
      
      public function prepareForDisplay(param1:Array) : void
      {
         var _loc2_:Function = null;
         this.pendingSelection = param1;
         this.refreshOptionsLists();
         for each(_loc2_ in this.registeredViewStartupFunctions)
         {
            _loc2_();
         }
         if(this.rankedTeamPlayerWatcher == null)
         {
            this.rankedTeamPlayerWatcher = ChangeWatcher.watch(this.rankedTeamManagementController,"teamPlayer",this.onRankedTeamPlayerChanged);
         }
         FeaturedGameMetadataActions.executeQueryMetadataAndUpdateGameOptionsAction(this.gameQueueManager,this.queueOptionsListCollection,this.refreshOptionsLists);
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      public function issueCommand(param1:String) : void
      {
         this.cancelFlow();
         switch(param1)
         {
            case COMMAND_JOIN:
               this.masterGameController.startPracticeGameFlowAtJoinGame();
               break;
            case COMMAND_CREATE:
               this.masterGameController.startPracticeGameFlowAtCreateGame();
               break;
            case COMMAND_BASIC_TUTORIAL:
               this.masterGameController.gameModel.tutorialType = GameModel.TUTORIAL_TYPE_BASIC;
               this.masterGameController.startTutorialGame();
               break;
            case COMMAND_ADVANCED_TUTORIAL:
               this.masterGameController.gameModel.tutorialType = GameModel.TUTORIAL_TYPE_ADVANCED;
               this.masterGameController.startTutorialGame();
         }
         this.masterGameController.gameModel.allowFreeChampions = true;
      }
      
      [Bindable(event="propertyChange")]
      public function set gameMapDisplayDescription(param1:String) : void
      {
         var _loc2_:Object = this.gameMapDisplayDescription;
         if(_loc2_ !== param1)
         {
            this._411301764gameMapDisplayDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMapDisplayDescription",_loc2_,param1));
         }
      }
      
      private function configureQueueStep(param1:GamePropertiesListData) : void
      {
         var _loc5_:String = null;
         var _loc2_:XML = param1.nextStep as XML;
         this.gameQueueManager.updateQueuesIfNeeded();
         var _loc3_:GameQueueConfig = this.gameQueueManager.getQueueForID(_loc2_.@soloid);
         var _loc4_:GameQueueConfig = this.gameQueueManager.getQueueForID(_loc2_.@partyid);
         _loc2_.@message = null;
         _loc2_.@messageTipHeader = null;
         _loc2_.@messageTipBody = null;
         _loc2_.@showAspirationalStep = false;
         _loc2_.@soloEnabled = false;
         if(_loc3_)
         {
            this.configureSoloQueue(param1,_loc3_,_loc2_);
         }
         _loc2_.@partyEnabled = false;
         if(_loc4_)
         {
            this.configurePartyQueue(param1,_loc4_,_loc2_);
         }
         var _loc6_:String = PARTY_QUEUE_PARTY;
         if(_loc2_.@partyEnabled == true)
         {
            if(_loc4_.teamOnly)
            {
               _loc6_ = PARTY_QUEUE_TEAM;
            }
         }
         else if(Boolean(_loc3_) && Boolean(_loc2_.@soloEnabled == "true") && _loc3_.maximumParticipantListSize == 2)
         {
            _loc6_ = PARTY_QUEUE_DUO;
            _loc2_.@partyEnabled = ShutdownTimingTables.canJoinQueueRightNow(_loc2_.@partyid);
         }
         _loc2_.@partyQueueType = _loc6_;
         _loc2_.@enabled = _loc2_.@partyEnabled == "true" || _loc2_.@soloEnabled == "true" || _loc2_.@showAspirationalStep == "true";
      }
      
      private function selectQueueMessagingHandler(param1:AlertAction) : void
      {
         var _loc2_:ICommand = null;
         if(param1.affirmativeResponse)
         {
            _loc2_ = param1.data.command as ICommand;
            this.cancelFlow();
            _loc2_.execute();
         }
      }
      
      private function set _2051556744gameModeDisplayName(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this._gameModeDisplayName = RiotResourceLoader.getString(param1 + "_game_mode_title");
         }
         else
         {
            this._gameModeDisplayName = "";
         }
         if(this.masterGameController.gameMap)
         {
            this.gameMapDisplayName = this.masterGameController.gameMap.displayName;
         }
      }
      
      private function watchGameModel() : void
      {
         this.gameModelWatcherArray.addItem(ChangeWatcher.watch(this.masterGameController.gameModel,"difficulty",this.onDifficultyChange));
         this.gameModelWatcherArray.addItem(ChangeWatcher.watch(this.masterGameController.gameModel,"gameMode",this.onGameModeChange));
         this.gameModelWatcherArray.addItem(ChangeWatcher.watch(this.masterGameController.gameModel,"gameMap",this.onGameMapChange));
         this.gameModelWatcherArray.addItem(ChangeWatcher.watch(this.masterGameController.gameModel,"gameType",this.onGameTypeChange));
      }
      
      private function onDifficultyChange(param1:PropertyChangeEvent) : void
      {
         this.setupGameModeDescription();
      }
      
      private function setupGameModeDescription() : void
      {
         var _loc3_:String = null;
         if(this.masterGameController.gameModel.gameMode == null)
         {
            this.gameModeDisplayDescription = "";
            return;
         }
         var _loc1_:String = this.masterGameController.gameModel.gameMode + "_game_mode_description";
         var _loc2_:String = RiotResourceLoader.getString(_loc1_);
         if(this.masterGameController.gameModel.difficulty != null)
         {
            _loc3_ = _loc1_ + "_" + this.masterGameController.gameModel.difficulty.toLowerCase();
            this.gameModeDisplayDescription = RiotResourceLoader.getString(_loc3_,_loc2_);
         }
         else
         {
            this.gameModeDisplayDescription = _loc2_;
         }
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
      }
      
      private function onGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is FeaturedGameMetadataDTO)
         {
            GameConfig.instance.featuredGameMetadataDTO = _loc2_ as FeaturedGameMetadataDTO;
            FeaturedGameMetadataActions.executeUpdateGameOptionsAction(this.gameQueueManager,this.queueOptionsListCollection);
         }
      }
      
      private function configurePartyQueue(param1:GamePropertiesListData, param2:GameQueueConfig, param3:XML) : void
      {
         var _loc5_:String = null;
         var _loc4_:Boolean = true;
         if(param2.ranked)
         {
            if(this.session.summonerLevel.summonerLevel >= this.gameQueueManager.getMinSummonerLevelForArrangedRanked())
            {
               _loc4_ = true;
               if(!this.userOwnsEnoughChampionsToDraft(!param2.disallowFreeChampions))
               {
                  _loc4_ = false;
                  param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
                  _loc5_ = param2.disallowFreeChampions ? "matchmaking_join_rankedqueue_message_champs_owned" : "matchmaking_join_rankedqueue_message_champs_available";
                  param3.@message = RiotResourceLoader.getString(_loc5_,null,[GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
                  if(param2.teamOnly)
                  {
                     this.showRankedTeamTip(param3 as XML,!param2.disallowFreeChampions);
                  }
                  else
                  {
                     this.showRankedArrangedTeamTip(param3 as XML,!param2.disallowFreeChampions);
                  }
               }
            }
            else
            {
               _loc4_ = false;
               param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
               param3.@message = RiotResourceLoader.getString("matchmaking_join_queue_message_level",null,[this.gameQueueManager.getMinSummonerLevelForSoloRanked()]);
               if(param2.teamOnly)
               {
                  this.showRankedTeamTip(param3 as XML,!param2.disallowFreeChampions);
               }
               else
               {
                  this.showRankedArrangedTeamTip(param3 as XML,!param2.disallowFreeChampions);
               }
            }
         }
         else
         {
            _loc4_ &&= this.session.summonerLevel.summonerLevel >= param2.minLevel;
            _loc4_ = (_loc4_) && this.meetsQueuePrerequisites(param1,param3);
         }
         if(param2.teamOnly)
         {
            _loc4_ = _loc4_ && Boolean(this.clientConfig.teamServiceEnabled) && this.rankedTeamManagementController.numTeams > 0;
         }
         _loc4_ &&= Boolean(ShutdownTimingTables.canJoinQueueRightNow(param3.@partyid));
         param3.@partyEnabled = _loc4_;
      }
      
      public function registerStartupFunction(param1:Function) : void
      {
         if(!this.registeredViewStartupFunctions.contains(param1))
         {
            this.registeredViewStartupFunctions.addItem(param1);
         }
      }
      
      private function showRankedArrangedTeamTip(param1:XML, param2:Boolean) : void
      {
         param1.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_rankedqueue_tip_header_arranged");
         var _loc3_:String = param2 ? "matchmaking_join_rankedqueue_tip_body_arranged" : "matchmaking_join_rankedqueue_tip_body_arranged_no_free_champs";
         param1.@messageTipBody = RiotResourceLoader.getString(_loc3_,null,[this.gameQueueManager.getMinSummonerLevelForSoloRanked(),GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectionList() : ArrayCollection
      {
         return this._1039200330selectionList;
      }
      
      private function set _411301764gameMapDisplayDescription(param1:String) : void
      {
         this._gameMapDisplayDescription = param1;
      }
      
      private function resourceBundleLoaded(param1:ResourceEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < ChooseGameFlowViewLayoutDefinition.viewLayoutDefinition.main.length())
         {
            this.queueOptionsListCollection[_loc2_] = this.createOptionsList(ChooseGameFlowViewLayoutDefinition.viewLayoutDefinition.main[_loc2_].option[0]);
            _loc2_++;
         }
      }
      
      private function configureSoloQueue(param1:GamePropertiesListData, param2:GameQueueConfig, param3:XML) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc4_:Boolean = true;
         if(param2.ranked)
         {
            if(this.session.summonerLevel.summonerLevel >= this.gameQueueManager.getMinSummonerLevelForSoloRanked())
            {
               _loc4_ = true;
               if(this.session.rankedRestrictedGamesRemaining > 0)
               {
                  _loc4_ = false;
                  param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
                  param3.@rankedRestricted = true;
                  _loc5_ = this.session.rankedRestrictedGamesRemaining == 1 ? "restrictedRanked_queuelock_tooltip" : "restrictedRanked_queuelock_tooltip_plural";
                  param3.@message = RiotResourceLoader.getString(_loc5_,null,[this.session.rankedRestrictedGamesRemaining]);
                  param3.@shortMessage = RiotResourceLoader.getString("restrictedRanked_queuelock_shortmsg",null);
                  this.showRankedSoloDuoTip(param3,false);
               }
               else if(!this.userOwnsEnoughChampionsToDraft(!param2.disallowFreeChampions))
               {
                  _loc4_ = false;
                  param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
                  param3.@championCountRequirementNotMet = true;
                  _loc5_ = param2.disallowFreeChampions ? "matchmaking_join_rankedqueue_message_champs_owned" : "matchmaking_join_rankedqueue_message_champs_available";
                  param3.@message = RiotResourceLoader.getString(_loc5_,null,[GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
                  this.showRankedSoloDuoTip(param3,!param2.disallowFreeChampions);
               }
            }
            else
            {
               _loc4_ = false;
               param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
               param3.@queueLevelRequirement = this.gameQueueManager.getMinSummonerLevelForSoloRanked();
               param3.@message = RiotResourceLoader.getString("matchmaking_join_queue_message_level",null,[this.gameQueueManager.getMinSummonerLevelForSoloRanked()]);
               this.showRankedSoloDuoTip(param3 as XML,!param2.disallowFreeChampions);
            }
         }
         else
         {
            _loc4_ = this.session.summonerLevel.summonerLevel >= param2.minLevel;
            if(param2.gameTypeConfigId == 2 && !this.userOwnsEnoughChampionsToDraft(!param2.disallowFreeChampions))
            {
               _loc4_ = false;
               param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
               param3.@queueLevelRequirement = param2.minLevel;
               param3.@championCountRequirementNotMet = true;
               _loc6_ = param2.disallowFreeChampions ? "matchmaking_join_normaldraftqueue_message_champs_owned" : "matchmaking_join_normaldraftqueue_message_champs_available";
               param3.@message = RiotResourceLoader.getString(_loc6_,null,[GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
               this.showNormalDraftTip(param3,!param2.disallowFreeChampions);
            }
            else if(this.session.summonerLevel.summonerLevel < param2.minLevel && Boolean(QueueType.isAspirationalQueue(param2.type)))
            {
               param3.@showAspirationalStep = QueueType.isAspirationalQueue(param2.type);
               param3.@queueLevelRequirement = param2.minLevel;
               param3.@message = RiotResourceLoader.getString("matchmaking_join_queue_message_level",null,[param2.minLevel]);
               this.showQueueLevelMinTip(param3 as XML,param2.minLevel);
            }
            else
            {
               param3.@showAspirationalStep = false;
            }
            _loc4_ &&= this.meetsQueuePrerequisites(param1,param3);
         }
         _loc4_ &&= Boolean(ShutdownTimingTables.canJoinQueueRightNow(param3.@soloid));
         param3.@soloEnabled = _loc4_;
      }
      
      public function get gameQueueManager() : GameQueueManager
      {
         return this._gameQueueManager;
      }
      
      public function get gameModeDisplayDescription() : String
      {
         return this._gameModeDisplayDescription;
      }
      
      public function selectQueue(param1:int, param2:Boolean) : void
      {
         var _loc8_:AlertAction = null;
         var _loc3_:GameQueueConfig = this.gameQueueManager.getQueueForID(param1);
         var _loc4_:Boolean = Boolean(_loc3_.isCap());
         var _loc5_:Boolean = Boolean(_loc3_.ranked);
         var _loc6_:Boolean = Boolean(this.masterGameController.gameModel.isCoopVsAi());
         var _loc7_:ICommand = null;
         if(_loc4_)
         {
            _loc7_ = new SelectCapQueueCommand(param2,param1,this.masterGameController,this.gameQueueManager,this.inviteProvider.getInviteGroup());
         }
         else if(_loc5_)
         {
            _loc7_ = new SelectRankedQueue(param2,param1,this.masterGameController,this.gameQueueManager,this.inviteProvider);
         }
         else if(_loc6_)
         {
            _loc7_ = new SelectCoopVsAIQueueCommand(param2,param1,this.masterGameController,this.gameQueueManager,this.inviteProvider);
         }
         else
         {
            _loc7_ = new SelectNormalQueueCommand(param2,param1,this.masterGameController,this.gameQueueManager,this.inviteProvider);
         }
         if(false === this.hasDisplayedFWOTDLimitedInformationOnce && this.session.summonerLevel.summonerLevel > _loc3_.maxSummonerLevelForFirstWinOfTheDay)
         {
            this.hasDisplayedFWOTDLimitedInformationOnce = true;
            _loc8_ = new AlertAction(ResourceManager.getInstance().getString("resources","enterChampionSelect_noFWOTDBonusTitle"),ResourceManager.getInstance().getString("resources","enterChampionSelect_noFWOTDBonusReason"));
            _loc8_.data = {"command":_loc7_};
            _loc8_.showNegative = true;
            _loc8_.setYesNoLabels();
            _loc8_.getCompleted().addOnce(this.selectQueueMessagingHandler);
            _loc8_.add();
         }
         else
         {
            this.cancelFlow();
            _loc7_.execute();
         }
      }
      
      public function get gameModeDisplayName() : String
      {
         return this._gameModeDisplayName;
      }
      
      private function updateGameModelProperty(param1:String, param2:Object) : void
      {
         var _loc3_:GameModel = this.masterGameController.gameModel;
         if(_loc3_.hasOwnProperty(param1))
         {
            if(_loc3_[param1] is Boolean)
            {
               _loc3_[param1] = param2 == "true" ? true : false;
            }
            else if(_loc3_[param1] is int)
            {
               _loc3_[param1] = param2 is String ? parseInt(String(param2)) : param2 as int;
            }
            else if(param1 == "gameMap")
            {
               _loc3_.gameMap = this.applicationController.getMapByName(String(param2));
            }
            else
            {
               _loc3_[param1] = param2;
            }
         }
         else
         {
            this.logger.error("0001 bad data in updateGameModel: ",param1,param2);
         }
      }
      
      private function onGameModeChange(param1:PropertyChangeEvent) : void
      {
         this.gameModeDisplayName = param1.newValue as String;
         this.setupGameModeDescription();
      }
      
      [Bindable(event="propertyChange")]
      public function get queueOptionsListCollection() : Array
      {
         return this._821547127queueOptionsListCollection;
      }
      
      public function get gameMapDisplayDescription() : String
      {
         return this._gameMapDisplayDescription;
      }
      
      public function updateGameModel(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:GamePropertiesListData = param1.selectedChild;
         if(_loc2_ != null)
         {
            for(_loc3_ in _loc2_.modifierProperties)
            {
               this.updateGameModelProperty(_loc3_ as String,_loc2_.modifierProperties[_loc3_]);
            }
         }
         else
         {
            _loc4_ = param1.associatedPropertyNames;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               this.updateGameModelProperty(_loc4_[_loc5_],null);
               _loc5_++;
            }
         }
      }
      
      private function setCommandState(param1:Object, param2:Boolean, param3:String) : void
      {
         var _loc4_:GamePropertiesListData = null;
         if(param1 is GameOptionsList)
         {
            for each(_loc4_ in param1)
            {
               this.setCommandState(_loc4_,param2,param3);
            }
         }
         else if(param1 is GamePropertiesListData)
         {
            this.setCommandState(param1.nextStep,param2,param3);
         }
         else if(param1 is XML)
         {
            if(Boolean(param3) && Boolean(param3 != "") && param1.@system == param3)
            {
               param1.@enabled = param2.toString();
            }
         }
      }
      
      private function getCurrentMapNameText(param1:GameMap) : String
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration("QueueImages","OverrideQueueImage",false);
         if(Boolean(_loc2_.getBoolean()) && param1.name == "SummonersRift" && this.masterGameController.gameModel["gameType"] == "blind_pick")
         {
            _loc3_ = "SummonersRiftUpdate_display";
            return RiotResourceLoader.getString(_loc3_);
         }
         return param1.displayName;
      }
      
      private function set _749924207gameModeDisplayDescription(param1:String) : void
      {
         if(param1 != null && param1 != "")
         {
            this._gameModeDisplayDescription = param1;
         }
         else
         {
            this._gameModeDisplayDescription = "";
         }
      }
      
      private function refreshItem(param1:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc2_:GameOptionsList = param1 as GameOptionsList;
         if(_loc2_)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.source.length)
            {
               this.refreshItem(_loc2_.source[_loc4_]);
               _loc4_++;
            }
            _loc2_.refresh();
            return;
         }
         var _loc3_:GamePropertiesListData = param1 as GamePropertiesListData;
         if(_loc3_)
         {
            if(_loc3_.nextStep is GameOptionsList)
            {
               this.refreshItem(_loc3_.nextStep);
            }
            else if(_loc3_.nextStep is XML)
            {
               if(_loc3_.nextStep.name() == "queue")
               {
                  this.configureQueueStep(_loc3_);
               }
               if(_loc3_.nextStep.name() == "command" && _loc3_.nextStep.@system == "custom_games")
               {
                  _loc5_ = Boolean(this.clientConfig.practiceGamesEnabled) && Boolean(ShutdownTimingTables.canJoinQueueRightNow("custom"));
                  _loc6_ = _loc3_.nextStep.@command;
                  switch(_loc6_)
                  {
                     case "tournament_code":
                        _loc3_.nextStep.@enabled = _loc5_ && this.clientConfig.tournamentSendStatsEnabled && this.clientConfig.tournamentSupportAvailable;
                        break;
                     case "featured":
                        _loc3_.nextStep.@enabled = _loc5_ && GameFlowVariantFactory.instance.getVariantForGameKey(_loc3_.gameKey).isEnabled();
                        break;
                     default:
                        _loc3_.nextStep.@enabled = _loc5_;
                  }
               }
            }
            _loc3_.refresh();
         }
      }
      
      [PostConstruct]
      public function initialize() : void
      {
         this.clientConfig = ClientConfig.instance;
         this.clientConfig.getPracticeGamesEnabledChanged().add(this.onPracticeGamesEnabledChange);
         if(ResourceManager.getInstance().getResourceBundle(this.clientConfig.locale,"resources") == null)
         {
            ResourceManager.getInstance().addEventListener(ResourceEvent.COMPLETE,this.resourceBundleLoaded);
         }
         else
         {
            this.resourceBundleLoaded(null);
         }
         ChangeWatcher.watch(this.masterGameController,"gameModel",this.onGameModelChange);
         this.watchGameModel();
         ProviderLookup.publishProvider(IChooseGameFlowViewProvider,this);
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProvider);
         ServiceProxy.instance.messageRouterService.addGameMessageListener(this.onGameMessageReceived);
      }
      
      public function set selectionList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1039200330selectionList;
         if(_loc2_ !== param1)
         {
            this._1039200330selectionList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionList",_loc2_,param1));
         }
      }
      
      private function showNormalDraftTip(param1:XML, param2:Boolean) : void
      {
         param1.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_normaldraftqueue_tip_header_solo");
         var _loc3_:String = param2 ? "matchmaking_join_normaldraftqueue_tip_body_solo" : "matchmaking_join_normaldraftqueue_tip_body_solo_no_free_champs";
         param1.@messageTipBody = RiotResourceLoader.getString(_loc3_,null,[param1.@queueLevelRequirement,GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
      }
      
      public function set animationsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1072127278animationsEnabled;
         if(_loc2_ !== param1)
         {
            this._1072127278animationsEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"animationsEnabled",_loc2_,param1));
         }
      }
      
      private function showRankedTeamTip(param1:XML, param2:Boolean) : void
      {
         param1.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_rankedqueue_tip_header_team");
         var _loc3_:String = param2 ? "matchmaking_join_rankedqueue_tip_body_team" : "matchmaking_join_rankedqueue_tip_body_team_no_free_champs";
         param1.@messageTipBody = RiotResourceLoader.getString(_loc3_,null,[this.gameQueueManager.getMinSummonerLevelForSoloRanked(),GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
      }
      
      private function onGameMapChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:GameMap = param1.newValue as GameMap;
         if(Boolean(_loc2_) && !this.isPracticeGame)
         {
            this.gameMapDisplayName = this.getCurrentMapNameText(_loc2_);
            this.gameMapDisplayDescription = RiotResourceLoader.getString(_loc2_.name + "_description");
         }
         else
         {
            this.gameMapDisplayName = "";
            this.gameMapDisplayDescription = "";
         }
      }
      
      private function set _1671139325gameMapDisplayName(param1:String) : void
      {
         this._gameMapDisplayName = param1;
      }
      
      private function showRankedSoloDuoTip(param1:XML, param2:Boolean) : void
      {
         var _loc3_:String = null;
         param1.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_rankedqueue_tip_header_solo");
         if(param1.@rankedRestricted == true)
         {
            _loc3_ = "restrictedRanked_queuelock_shortmsg";
            param1.@messageTipBody = RiotResourceLoader.getString(_loc3_,null);
         }
         else
         {
            _loc3_ = param2 ? "matchmaking_join_rankedqueue_tip_body_solo" : "matchmaking_join_rankedqueue_tip_body_solo_no_free_champs";
            param1.@messageTipBody = RiotResourceLoader.getString(_loc3_,null,[this.gameQueueManager.getMinSummonerLevelForSoloRanked(),GameQueueConfig.CHAMPS_NEEDED_FOR_DRAFT]);
         }
      }
      
      private function createOptionsList(param1:XML) : GameOptionsList
      {
         var _loc5_:XML = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:GamePropertiesListData = null;
         var _loc10_:XML = null;
         var _loc2_:String = param1.@properties;
         var _loc3_:GameOptionsList = new GameOptionsList(param1.@name,param1.@localeKey,_loc2_.split(";"));
         var _loc4_:XMLList = param1.value;
         for each(_loc5_ in _loc4_)
         {
            _loc2_ = _loc5_.@data;
            _loc6_ = _loc2_.split(";");
            _loc7_ = new Object();
            _loc8_ = 0;
            while(_loc8_ < _loc6_.length)
            {
               _loc7_[_loc3_.associatedPropertyNames[_loc8_]] = _loc6_[_loc8_];
               _loc8_++;
            }
            _loc9_ = null;
            if(_loc5_.option.length() != 0)
            {
               _loc9_ = _loc3_.addValue(_loc7_,_loc5_.@localeKey,_loc5_.@name,_loc5_.@gameKey);
               _loc9_.nextStep = this.createOptionsList(_loc5_.option[0]);
            }
            else if(_loc5_.queue.length() != 0)
            {
               _loc9_ = _loc3_.addValue(_loc7_,_loc5_.@localeKey,_loc5_.@name,_loc5_.@gameKey);
               _loc9_.nextStep = _loc5_.queue[0];
            }
            else if(_loc5_.command.length() != 0)
            {
               for each(_loc10_ in _loc5_.command)
               {
                  _loc9_ = _loc3_.addValue(_loc7_,_loc5_.@localeKey,_loc5_.@name,_loc5_.@gameKey);
                  _loc9_.nextStep = _loc5_.command[0];
               }
            }
         }
         return _loc3_;
      }
      
      public function resetGameModel() : void
      {
         this.masterGameController.resetGameModel();
      }
      
      private function onRankedTeamPlayerChanged(param1:PropertyChangeEvent) : void
      {
         this.refreshOptionsLists();
      }
      
      public function cancelFlow() : void
      {
         this.applicationController.home();
         this.cleanupWatchers();
      }
      
      [Bindable(event="propertyChange")]
      public function get animationsEnabled() : Boolean
      {
         return this._1072127278animationsEnabled;
      }
      
      private function onInviteProvider(param1:IInviteProvider) : void
      {
         this.inviteProvider = param1;
         this.inviteController = param1.getInviteController();
         this.rankedTeamManagementController = param1.getRankedInviteController();
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      private function onGameTypeChange(param1:PropertyChangeEvent) : void
      {
         if(param1.newValue == "cap" || this.masterGameController.currentState == GameViewState.CAP_STATE)
         {
            this.gameModeDisplayName = "cap";
         }
         else
         {
            this.gameModeDisplayName = GameModel(param1.source).gameMode;
         }
         if(param1.currentTarget.gameMap != null)
         {
            this.gameMapDisplayName = this.getCurrentMapNameText(param1.currentTarget.gameMap);
         }
      }
      
      public function set gameQueueManager(param1:GameQueueManager) : void
      {
         this._gameQueueManager = param1;
         this._gameQueueManager.getQueuesUpdated().add(this.refreshOptionsLists);
      }
      
      [Bindable(event="propertyChange")]
      public function set gameModeDisplayDescription(param1:String) : void
      {
         var _loc2_:Object = this.gameModeDisplayDescription;
         if(_loc2_ !== param1)
         {
            this._749924207gameModeDisplayDescription = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameModeDisplayDescription",_loc2_,param1));
         }
      }
      
      private function showQueueLevelMinTip(param1:XML, param2:int) : void
      {
         param1.@messageTipHeader = RiotResourceLoader.getString("matchmaking_join_queue_level_tip_header");
         param1.@messageTipBody = RiotResourceLoader.getString("matchmaking_join_queue_level_tip_body",null,[param2]);
      }
      
      public function onPracticeGamesEnabledChange(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.queueOptionsListCollection.length)
         {
            this.setCommandState(this.queueOptionsListCollection[_loc3_],param2,"custom_games");
            _loc3_++;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      [Bindable(event="propertyChange")]
      public function set gameModeDisplayName(param1:String) : void
      {
         var _loc2_:Object = this.gameModeDisplayName;
         if(_loc2_ !== param1)
         {
            this._2051556744gameModeDisplayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameModeDisplayName",_loc2_,param1));
         }
      }
      
      private function cleanupWatchers() : void
      {
         if(this.rankedTeamPlayerWatcher != null)
         {
            this.rankedTeamPlayerWatcher.unwatch();
            this.rankedTeamPlayerWatcher = null;
         }
      }
   }
}

