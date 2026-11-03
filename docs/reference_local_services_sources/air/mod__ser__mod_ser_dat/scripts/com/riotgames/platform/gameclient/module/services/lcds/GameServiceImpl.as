package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.exception.ValidationException;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.featuredgame.MetadataServiceNotAvailableException;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameConfig;
   import com.riotgames.platform.gameclient.exception.GameException;
   import com.riotgames.platform.gameclient.exception.SkinRentalAlreadyPurchasedException;
   import com.riotgames.platform.gameclient.exception.SkinRentalInsufficientFundsException;
   import com.riotgames.platform.gameclient.exception.SkinRentalStoreException;
   import com.riotgames.platform.gameclient.exception.SkinRentalsNotAvailableException;
   import com.riotgames.platform.gameclient.module.services.async.MessageRouterServiceImpl;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.platform.gameclient.services.GameZoneGameService;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.messaging.Consumer;
   
   public class GameServiceImpl extends BaseLcdsService implements GameService, GameZoneGameService
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _gameZoneConsumer:Consumer;
      
      private var _messageRouterService:MessageRouterServiceImpl;
      
      private var _gameZoneChannelSet:ChannelSet;
      
      public function GameServiceImpl()
      {
         super();
      }
      
      public function banObserverFromGame(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function, param6:Object = null) : void
      {
         var _loc7_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc7_[GameException] = param5;
         }
         this.invokeServiceWithoutSession("gameService","banObserverFromGame",[param1,param2],param3,param4,_loc7_,param6);
      }
      
      public function selectChampion(param1:Champion, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
            _loc5_[ValidationException] = param4;
         }
         invokeServiceWithoutSession("gameService","selectChampion",[param1.championId],param2,param3,_loc5_);
      }
      
      public function championSelectCompleted(param1:Function, param2:Function) : void
      {
         this.invokeServiceWithoutSession("gameService","championSelectCompleted",[],param1,param2);
      }
      
      public function setClientReceivedGameMessage(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","setClientReceivedGameMessage",[param1,param2],param3,param4,_loc6_);
      }
      
      public function getGameState(param1:GameDTO, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","getLatestGameTimerState",[param1.id,param1.gameStateString,param1.pickTurn],param2,param3,_loc5_);
      }
      
      public function acceptOrDeclinePoppedGame(param1:Boolean, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         invokeServiceWithoutSession("gameService","acceptPoppedGame",[param1],param2,param3,_loc5_);
      }
      
      public function getAvailablePracticeGames(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("gameService","listAllPracticeGames",[],param1,param2);
      }
      
      public function createTutorialGame(param1:uint, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[GameException] = param4;
         invokeServiceWithoutSession("gameService","createTutorialGame",[param1],param2,param3,_loc5_);
      }
      
      public function createGame(param1:PracticeGameConfig, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[GameException] = param4;
         invokeServiceWithoutSession("gameService","createPracticeGame",[param1],param2,param3,_loc5_);
      }
      
      public function banChampion(param1:int, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","banChampion",[param1],param2,param3,_loc5_);
      }
      
      public function getChampionsForBan(param1:Function, param2:Function) : void
      {
         this.invokeServiceWithoutSession("gameService","getChampionsForBan",[],param1,param2);
      }
      
      public function quitGzGame(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("gameService","quitGame",[],param1,param2);
      }
      
      public function getFeaturedGameMetadata(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[GameException] = param3;
            _loc4_[MetadataServiceNotAvailableException] = param3;
         }
         this.invokeServiceWithoutSession("gameService","getFeaturedGameMetadata",[Session.instance.accountSummary.accountId],param1,param2,_loc4_);
      }
      
      public function switchPlayerToObserver(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","switchPlayerToObserver",[param1],param2,param3,_loc5_);
      }
      
      public function cancelSelectChampion(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[GameException] = param3;
         }
         invokeServiceWithoutSession("gameService","cancelSelectChampion",[],param1,param2,_loc4_);
      }
      
      public function joinOrCreateGame(param1:PracticeGameConfig, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         _loc5_[GameException] = param4;
         invokeServiceWithoutSession("gameService","joinOrCreatePracticeGame",[param1],param2,param3,_loc5_);
      }
      
      public function isGameZoneMatch(param1:String, param2:int, param3:int) : Boolean
      {
         if(this._gameZoneChannelSet != null && (this._gameZoneChannelSet.currentChannel.url == config.channel_protocol + "://" + param1 + ":" + param2 || this._gameZoneChannelSet.currentChannel.url == config.channel_protocol + "://" + param1 + ":" + param3))
         {
            return true;
         }
         return false;
      }
      
      public function getGameReconnectionInfo(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[GameException] = param3;
         }
         this.invokeServiceWithoutSession("gameService","retrieveInProgressGameInfo",[],param1,param2,_loc4_);
      }
      
      public function selectChampionSkin(param1:ChampionSkin, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","selectChampionSkin",[param1.championId,param1.skinId],param2,param3,_loc5_);
      }
      
      public function removeBotChampion(param1:Champion, param2:BotParticipant, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","removeBotChampion",[param1.championId,param2],param3,param4,_loc6_);
      }
      
      public function clearGameZoneConnection() : void
      {
         if(this._gameZoneChannelSet != null)
         {
            if(this._messageRouterService != null && this._gameZoneConsumer != null)
            {
               this._messageRouterService.unsubscribeGameConsumer(this._gameZoneConsumer);
               this._messageRouterService.subscribePlatformGameConsumer();
               this._gameZoneConsumer = null;
            }
            remoteObjectGenerator.expireAuthenticationChannel(this._gameZoneChannelSet);
            this._gameZoneChannelSet = null;
         }
         ServiceLogger.info("gameZoneGameService","clearGameZoneConnection");
      }
      
      public function observeGame(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         _loc6_[GameException] = param5;
         invokeServiceWithoutSession("gameService","observeGame",[param1,param2],param3,param4,_loc6_);
      }
      
      public function getCurrentTimerForGame(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[GameException] = param3;
         }
         this.invokeServiceWithoutSession("gameService","getCurrentTimerForGame",[],param1,param2,_loc4_);
      }
      
      public function selectBotChampion(param1:Champion, param2:BotParticipant, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","selectBotChampion",[param1.championId,param2],param3,param4,_loc6_);
      }
      
      public function spectateGameInProgress(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","retrieveInProgressSpectatorGameInfo",[param1],param2,param3,_loc5_);
      }
      
      public function switchObserverToPlayer(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         this.invokeServiceWithoutSession("gameService","switchObserverToPlayer",[param1,param2],param3,param4,_loc6_);
      }
      
      public function joinGame(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         _loc6_[GameException] = param5;
         invokeServiceWithoutSession("gameService","joinGame",[param1,param2],param3,param4,_loc6_);
      }
      
      override protected function prepareChannelSet() : ChannelSet
      {
         return this._gameZoneChannelSet != null ? this._gameZoneChannelSet : remoteObjectGenerator.defaultChannelSet;
      }
      
      public function set messageRouterService(param1:MessageRouterServiceImpl) : void
      {
         this._messageRouterService = param1;
      }
      
      public function declineObserverReconnect(param1:Function, param2:Function, param3:Function) : void
      {
         var _loc4_:Dictionary = new Dictionary();
         if(param3 != null)
         {
            _loc4_[GameException] = param3;
         }
         this.invokeServiceWithoutSession("gameService","declineObserverReconnect",[],param1,param2,_loc4_);
      }
      
      public function setClientReceivedMaestroMessage(param1:Number, param2:String, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","setClientReceivedMaestroMessage",[param1,param2],param3,param4,_loc6_);
      }
      
      public function banUserFromGame(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function, param6:Object = null) : void
      {
         var _loc7_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc7_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","banUserFromGame",[param1,param2],param3,param4,_loc7_,param6);
      }
      
      public function switchTeams(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         invokeServiceWithoutSession("gameService","switchTeams",[param1],param2,param3,_loc5_);
      }
      
      public function selectSpells(param1:ArrayCollection, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:int = param1.getItemAt(0) as int;
         var _loc6_:int = param1.getItemAt(1) as int;
         var _loc7_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc7_[GameException] = param4;
         }
         invokeServiceWithoutSession("gameService","selectSpells",[_loc5_,_loc6_],param2,param3,_loc7_);
      }
      
      public function startChampionSelection(param1:Number, param2:Number, param3:Function, param4:Function, param5:Function) : void
      {
         var _loc6_:Dictionary = new Dictionary();
         if(param5 != null)
         {
            _loc6_[GameException] = param5;
         }
         invokeServiceWithoutSession("gameService","startChampionSelection",[param1,param2],param3,param4,_loc6_);
      }
      
      public function unlockSkinsForTeam(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
            _loc5_[SkinRentalsNotAvailableException] = param4;
            _loc5_[SkinRentalInsufficientFundsException] = param4;
            _loc5_[SkinRentalAlreadyPurchasedException] = param4;
            _loc5_[SkinRentalStoreException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","unlockSkinsForTeam",[param1],param2,param3,_loc5_);
      }
      
      public function getGame(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","getGame",[param1],param2,param3,_loc5_);
      }
      
      public function getPracticeGameForUser(param1:Function, param2:Function) : void
      {
         invokeServiceWithoutSession("gameService","getGameForUser",[],param1,param2);
      }
      
      public function getSkinUnlockPrice(param1:String, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:Dictionary = new Dictionary();
         if(param4 != null)
         {
            _loc5_[GameException] = param4;
            _loc5_[SkinRentalsNotAvailableException] = param4;
            _loc5_[SkinRentalInsufficientFundsException] = param4;
            _loc5_[SkinRentalAlreadyPurchasedException] = param4;
            _loc5_[SkinRentalStoreException] = param4;
         }
         this.invokeServiceWithoutSession("gameService","getSkinUnlockPrice",[param1],param2,param3,_loc5_);
      }
      
      public function getAuditInfo(param1:Function, param2:Function, param3:Array) : void
      {
         invokeServiceWithoutSession("gameService","listAuditInfo",[param3],param1,param2);
      }
      
      public function setGameServiceZone(param1:String, param2:int, param3:int) : void
      {
         var _loc4_:MultiValueProperty = new MultiValueProperty();
         var _loc5_:Array = new Array();
         var _loc6_:String = config.channel_protocol + "://" + param1;
         if(config.channel_protocol == "rtmps")
         {
            _loc6_ += ":" + param3;
         }
         else
         {
            _loc6_ += ":" + param2;
         }
         _loc5_.push(_loc6_);
         _loc4_.values = _loc5_;
         this.clearGameZoneConnection();
         this._gameZoneChannelSet = remoteObjectGenerator.createChannelSet(_loc4_);
         remoteObjectGenerator.authenticateChannel(this._gameZoneChannelSet,session.accountSummary.username,"bogustoken");
         this._messageRouterService.unsubscribePlatformGameConsumer();
         this._gameZoneConsumer = new Consumer();
         this._gameZoneConsumer.destination = config.messaging_dest;
         this._gameZoneConsumer.channelSet = this._gameZoneChannelSet;
         this._messageRouterService.subscribeGameConsumer(this._gameZoneConsumer,this._messageRouterService.clientIdGame,this._messageRouterService.clientIdGame);
         ServiceLogger.info("gameZoneGameService","setGameServiceZone",[param1,param2]);
      }
      
      public function quitGame(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("gameService","quitGame",[],param1,param2);
      }
   }
}

