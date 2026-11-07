package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.services.MessageRouterService;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.commands.trades.AttemptChampionTradeCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.trades.DismissTradeCommand;
   import com.riotgames.platform.gameclient.controllers.game.commands.trades.GetPotentialTradersCommand;
   import com.riotgames.platform.gameclient.controllers.game.enums.TradeContractEnum;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.trade.TradeContractDTO;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import mx.managers.CursorManager;
   import mx.messaging.events.MessageEvent;
   import mx.resources.ResourceManager;
   
   public class PlatformChampionTradeController extends ChampionTradeControllerBase
   {
      
      private var _messageRouterService:MessageRouterService;
      
      private var _tradeService:IChampionTradeService;
      
      private var _gameMessageQueue:MessageQueue;
      
      public function PlatformChampionTradeController(param1:MessageRouterService, param2:IChampionTradeService, param3:ChampionSelectionModel, param4:ChampionTrade, param5:IChampionSelectionCommandFactory, param6:IInventory)
      {
         super(param3,param4,param5,param6);
         this._tradeService = param2;
         this._messageRouterService = param1;
      }
      
      private function dismissTrade() : void
      {
         var _loc1_:ICommand = new DismissTradeCommand(this._tradeService);
         _loc1_.execute();
      }
      
      private function connectToLCDS() : void
      {
         this._gameMessageQueue = new MessageQueue("gameQueue",this.onServerGameMessageReceived);
         this._messageRouterService.addGameMessageListener(this._gameMessageQueue.onMessageReceived);
      }
      
      override protected function invokeTradeReject() : void
      {
         this.dismissTrade();
      }
      
      private function abortTrade(param1:*, param2:String, param3:Array) : void
      {
         setPendingTrade(false,false,null,null,"");
         showRejectChatMessage(param1,param2,param3);
         this.getPotentialTraders();
         setTradeMessage(param1,param2,param3);
      }
      
      private function processTradeMessageLCDS(param1:TradeContractDTO) : void
      {
         switch(param1.state)
         {
            case TradeContractEnum.PENDING:
               this.handleTradeRequestLCDS(param1);
               break;
            case TradeContractEnum.CANCELED:
               this.abortTrade("champion_trading_trade_canceled_title","champion_trading_trade_cancelled",[getNameFromInternalName(param1.requesterInternalSummonerName)]);
               break;
            case TradeContractEnum.BUSY:
               this.abortTrade("champion_trading_trade_busy_title","champion_trading_trade_busy",[_championTrade.pendingTraderDisplayName]);
               break;
            case TradeContractEnum.DECLINED:
               this.abortTrade("champion_trading_trade_rejected_title","champion_trading_trade_rejected",[getNameFromInternalName(param1.responderInternalSummonerName)]);
               break;
            case TradeContractEnum.INVALID:
               if(param1.requesterInternalSummonerName == _championSelectionModel.currentPlayerParticipant.summonerInternalName)
               {
                  this.onAttemptTradeError(null);
               }
               else
               {
                  clearChampionTrade();
               }
         }
      }
      
      private function onAttemptTradeError(param1:Object) : void
      {
         this.abortTrade("champion_trading_trade_error_title","champion_trading_champion_changed",[_championTrade.pendingTraderDisplayName]);
      }
      
      private function onServerGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is TradeContractDTO)
         {
            this.processTradeMessageLCDS(_loc2_ as TradeContractDTO);
         }
      }
      
      private function getPotentialTraders() : void
      {
         var _loc1_:ICommand = new GetPotentialTradersCommand(_championSelectionModel.currentTeamSelections,areTradesAllowed(),this._tradeService);
         _loc1_.execute();
      }
      
      private function attemptTrade(param1:String, param2:Champion, param3:Boolean) : void
      {
         var _loc4_:ICommand = new AttemptChampionTradeCommand(param1,param2.championId,param3,this._tradeService,ResourceManager.getInstance(),CursorManager.getInstance());
         _loc4_.addResponder(null,this.onAttemptTradeError,null);
         _loc4_.execute();
      }
      
      override public function initialize() : void
      {
         super.initialize();
         this.connectToLCDS();
      }
      
      override protected function invokeTradeRequest(param1:PlayerParticipant, param2:Champion) : void
      {
         this.attemptTrade(param1.summonerInternalName,param2,false);
      }
      
      override protected function invokeTradeCancel() : void
      {
         this.dismissTrade();
      }
      
      override protected function updateAllTradeAvailability(param1:Boolean) : void
      {
         this.getPotentialTraders();
      }
      
      private function handleTradeRequestLCDS(param1:TradeContractDTO) : void
      {
         var _loc2_:ICommand = _championSelectionCommandFactory.getPlaySoundCommand(AudioKeys.SOUND_TRADE_REQUEST);
         _loc2_.execute();
         var _loc3_:Champion = _inventory.championIdMapping[param1.requesterChampionId];
         var _loc4_:Champion = _inventory.championIdMapping[param1.responderChampionId];
         setPendingTrade(true,false,_loc3_,_loc4_,param1.requesterInternalSummonerName);
      }
      
      private function disconnectFromLCDS() : void
      {
         this._messageRouterService.removeGameMessageListener(this._gameMessageQueue.onMessageReceived);
         this._gameMessageQueue = null;
      }
      
      override protected function updateTradeAvailable(param1:PlayerSelection, param2:Boolean) : void
      {
         this.getPotentialTraders();
      }
      
      override protected function invokeTradeAccept() : void
      {
         this.attemptTrade(_championTrade.pendingTraderName,_championTrade.pendingChampion,true);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.disconnectFromLCDS();
      }
   }
}

