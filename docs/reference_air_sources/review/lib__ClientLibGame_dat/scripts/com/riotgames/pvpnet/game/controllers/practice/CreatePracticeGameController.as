package com.riotgames.pvpnet.game.controllers.practice
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.Models.GameModel;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.ICycleViewController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.practice.ICreatePracticeGameProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import mx.utils.StringUtil;
   
   public class CreatePracticeGameController implements ICycleViewController, ICreatePracticeGameProvider, IEventDispatcher
   {
      
      public static const GAME_TYPE_BLIND_PICK:int = 1;
      
      public static const GAME_TYPE_DRAFT_MODE:int = 2;
      
      public var masterGameController:MasterGameController;
      
      public var wordFilter:WordFilter = WordFilter.instance;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _1180619197isBusy:Boolean = false;
      
      private var _3165170game:PracticeGameConfig;
      
      public var canCreateGameChanged:Signal = new Signal();
      
      public var gameCreationError:Signal = new Signal();
      
      public var mapChanged:Signal = new Signal();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function CreatePracticeGameController()
      {
         super();
         this.game = new PracticeGameConfig();
         this.game.allowSpectators = UserPreferencesManager.userPrefs.allowSpectatorMode;
         this.game.gameMode = GameMode.CLASSIC;
         this.game.gameTypeConfig = GAME_TYPE_BLIND_PICK;
         this.gameCreationError.add(this.onCreateGameError);
         ProviderLookup.publishProvider(ICreatePracticeGameProvider,this);
      }
      
      public static function isMapBeta(param1:GameMap) : Boolean
      {
         return false;
      }
      
      private function onCreateGameError(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         _loc3_.add();
      }
      
      public function setGameName(param1:String) : void
      {
         this.game.gameName = param1;
         this.canCreateGameChanged.dispatch();
      }
      
      public function setGamePassword(param1:String) : void
      {
         this.game.gamePassword = param1;
      }
      
      public function setNumberOfPlayers(param1:int) : void
      {
         this.game.maxNumPlayers = param1;
         this.canCreateGameChanged.dispatch();
      }
      
      public function setRegion(param1:String) : void
      {
         this.game.region = param1;
         this.canCreateGameChanged.dispatch();
      }
      
      public function setGameMap(param1:GameMap) : void
      {
         this.game.gameMap = param1;
         this.canCreateGameChanged.dispatch();
         this.mapChanged.dispatch();
      }
      
      public function setAllowSpectators(param1:String) : void
      {
         UserPreferencesManager.userPrefs.allowSpectatorMode = param1;
         this.game.allowSpectators = param1;
      }
      
      public function setGameTypeIndex(param1:int) : void
      {
         this.game.gameTypeConfig = param1;
      }
      
      public function canCreateGame() : Boolean
      {
         return this.game.gameName != null && StringUtil.trim(this.game.gameName).length >= 3 && this.game.gameMap != null && this.game.maxNumPlayers > 0 && this.game.maxNumPlayers <= this.practiceGameParameters.getMaxTeamSize(this.game.gameMap,ClientConfig.instance.maxPracticeGameSize) * 2 && this.game.maxNumPlayers >= ClientConfig.instance.minNumPlayersForPracticeGame;
      }
      
      public function createGame() : void
      {
         var _loc1_:ServerError = null;
         if(this.wordFilter.containsOffensiveWords(this.game.gameName,false))
         {
            _loc1_ = new ServerError(null);
            _loc1_.errorCode = MessageDictionary.GAME_NAME_CONTAINS_OFFENSIVE_WORDS;
            this.gameCreationError.dispatch(_loc1_);
            return;
         }
         this.isBusy = true;
         this.practiceGameParameters.applyGameTypeToConfig(this.game,this.game.gameMap.mapId);
         this.serviceProxy.gameService.createGame(this.game,this.onGameCreated,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function joinOrCreateGame() : void
      {
         this.serviceProxy.gameService.joinOrCreateGame(this.game,this.onGameCreated,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function setGameConfig(param1:PracticeGameConfig) : void
      {
         this.game = param1;
      }
      
      public function cancelGame() : void
      {
         this.masterGameController.playAnotherGame();
      }
      
      public function get practiceGameParameters() : PracticeGameParameters
      {
         var _loc1_:GameModel = this.masterGameController.gameModel;
         var _loc2_:String = _loc1_ != null ? _loc1_.gameMode : PracticeGameParametersFactory.CUSTOM_MODE_ID;
         return PracticeGameParametersFactory.instance.getPracticeGameParameters(_loc2_);
      }
      
      public function initialize() : void
      {
      }
      
      public function initializeCycle() : void
      {
         this.initializeGameMap();
      }
      
      public function abortCycle() : void
      {
      }
      
      public function cleanup() : void
      {
      }
      
      public function cleanupCycle() : void
      {
      }
      
      public function activate() : void
      {
         this.game.gamePassword = "";
      }
      
      public function deactivate() : void
      {
         this.game.gameName = null;
         this.game.gameMap = null;
         this.game.gamePassword = null;
         this.game.maxNumPlayers = -1;
         this.isBusy = false;
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         this.isBusy = false;
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         this.gameCreationError.dispatch(param1);
      }
      
      private function onGameCreated(param1:ResultEvent) : void
      {
         this.masterGameController.joinPracticeGame(param1.result as GameDTO);
      }
      
      private function initializeGameMap() : void
      {
         if(AppConfig.instance.availableMaps != null && AppConfig.instance.availableMaps.length > 0)
         {
            this.game.gameMap = AppConfig.instance.availableMaps.getItemAt(0) as GameMap;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get game() : PracticeGameConfig
      {
         return this._3165170game;
      }
      
      public function set game(param1:PracticeGameConfig) : void
      {
         var _loc2_:Object = this._3165170game;
         if(_loc2_ !== param1)
         {
            this._3165170game = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"game",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

