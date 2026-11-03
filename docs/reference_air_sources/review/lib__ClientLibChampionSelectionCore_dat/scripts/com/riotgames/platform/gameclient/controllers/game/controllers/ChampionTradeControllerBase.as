package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import avmplus.getQualifiedClassName;
   import com.riotgames.platform.common.commands.ICommand;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.gameclient.controllers.game.builders.IChampionSelectionCommandFactory;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionTrade;
   import com.riotgames.platform.gameclient.controllers.game.model.PlayerSelection;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ChampionTradeControllerBase implements IChampionTradeController
   {
      
      private static const WAIT_FOR_ACCEPT_RESPONSE_TIMEOUT:uint = 5000;
      
      protected var _championSelectionCommandFactory:IChampionSelectionCommandFactory;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      protected var _inventory:IInventory;
      
      protected var _championSelectionModel:ChampionSelectionModel;
      
      private var _tradeTimeoutId:uint = 0;
      
      protected var _championTrade:ChampionTrade;
      
      public function ChampionTradeControllerBase(param1:ChampionSelectionModel, param2:ChampionTrade, param3:IChampionSelectionCommandFactory, param4:IInventory)
      {
         super();
         this._championSelectionModel = param1;
         this._championTrade = param2;
         this._championSelectionCommandFactory = param3;
         this._inventory = param4;
      }
      
      protected function showRejectChatMessage(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:ICommand = this._championSelectionCommandFactory.getShowDockedPromptMessageCommand(param1,param2,param3,"resources","champion_trading_prompt_origin","common_button_close");
         _loc4_.execute();
      }
      
      public function rejectTrade() : void
      {
         this.invokeTradeReject();
         this.clearChampionTrade();
      }
      
      protected function setTradeActive(param1:Boolean) : void
      {
         var _loc2_:PlayerSelection = null;
         for each(_loc2_ in this._championSelectionModel.currentTeamSelections)
         {
            _loc2_.tradeActive = param1;
         }
      }
      
      protected function invokeTradeReject() : void
      {
      }
      
      protected function setPendingTrade(param1:Boolean, param2:Boolean, param3:Champion, param4:Champion, param5:String) : void
      {
         this.setTradeActive(!param1);
         this._championTrade.pendingTrade = param1;
         this._championTrade.tradeHost = param2;
         this._championTrade.pendingChampion = param3;
         this._championTrade.selectedChampion = param4;
         this._championTrade.pendingTraderName = param5;
         this._championTrade.pendingTraderDisplayName = this.getNameFromInternalName(param5);
         this._championSelectionModel.championTradeIsActive = param1;
         if(this._tradeTimeoutId != 0)
         {
            clearTimeout(this._tradeTimeoutId);
            this._tradeTimeoutId = 0;
         }
         if(param1 && Boolean(this._championSelectionModel.currentPlayerSelection))
         {
            this._championSelectionModel.currentPlayerSelection.championTrade = this._championTrade;
         }
      }
      
      public function cancelTrade() : void
      {
         if(this._championTrade.pendingTrade && this._championTrade.tradeCancellable)
         {
            this.invokeTradeCancel();
            this.clearChampionTrade();
         }
      }
      
      private function onPlayerChampionChanged(param1:Event) : void
      {
         var _loc2_:PlayerSelection = param1.currentTarget as PlayerSelection;
         if(_loc2_.participant.isMe)
         {
            if(_loc2_.champion == null)
            {
               this.clearChampionTrade();
            }
            else if(this._championTrade.pendingTrade && _loc2_.champion.skinName == this._championTrade.pendingChampion.skinName)
            {
               this.clearChampionTrade();
            }
            else if(this._championTrade.pendingTrade && !this._championTrade.tradeHost && _loc2_.champion.championId != this._championTrade.pendingChampion.championId)
            {
               this.invokeTradeAccept();
               this.clearChampionTrade();
            }
            this.updateAllTradeAvailability(!this.areTradesAllowed());
         }
         else
         {
            this.updateTradeAvailable(param1.currentTarget as PlayerSelection,!this.areTradesAllowed());
         }
      }
      
      protected function getNameFromInternalName(param1:String) : String
      {
         var _loc2_:IParticipant = null;
         for each(_loc2_ in this._championSelectionModel.currentTeam)
         {
            if(param1 == _loc2_.getSummonerInternalName())
            {
               return _loc2_.getSummonerName();
            }
         }
         return "";
      }
      
      public function acceptTrade() : void
      {
         this.invokeTradeAccept();
         if(this._tradeTimeoutId != 0)
         {
            clearTimeout(this._tradeTimeoutId);
         }
         this._tradeTimeoutId = setTimeout(this.clearChampionTrade,WAIT_FOR_ACCEPT_RESPONSE_TIMEOUT);
      }
      
      private function tradeRequestTimeout() : void
      {
         this._tradeTimeoutId = 0;
         this._championTrade.tradeCancellable = true;
      }
      
      public function requestTrade(param1:PlayerParticipant, param2:Champion) : void
      {
         if(!this.areTradesAllowed())
         {
            return;
         }
         if(!param2)
         {
            return;
         }
         if(!this._championSelectionModel.currentPlayerSelection.champion)
         {
            return;
         }
         if(this._championTrade.pendingTrade)
         {
            return;
         }
         this.invokeTradeRequest(param1,param2);
         if(this._tradeTimeoutId != 0)
         {
            clearTimeout(this._tradeTimeoutId);
         }
         this.setPendingTrade(true,true,param2,this._championSelectionModel.currentPlayerSelection.champion,param1.summonerInternalName);
         this._tradeTimeoutId = setTimeout(this.tradeRequestTimeout,WAIT_FOR_ACCEPT_RESPONSE_TIMEOUT);
      }
      
      public function initialize() : void
      {
         var _loc1_:PlayerSelection = null;
         this.clearChampionTrade();
         for each(_loc1_ in this._championSelectionModel.currentTeamSelections)
         {
            _loc1_.addEventListener(PlayerSelection.CHAMPION_CHANGED,this.onPlayerChampionChanged,false,0,true);
         }
         this.setTradeActive(true);
         this.updateAllTradeAvailability(!this.areTradesAllowed());
      }
      
      protected function invokeTradeRequest(param1:PlayerParticipant, param2:Champion) : void
      {
      }
      
      protected function invokeTradeCancel() : void
      {
      }
      
      protected function updateAllTradeAvailability(param1:Boolean) : void
      {
         var _loc2_:PlayerSelection = null;
         for each(_loc2_ in this._championSelectionModel.currentTeamSelections)
         {
            this.updateTradeAvailable(_loc2_,param1);
         }
      }
      
      private function onMessageTimeout(param1:Object) : void
      {
         this.clearChampionTrade();
      }
      
      protected function areTradesAllowed() : Boolean
      {
         if(this._championSelectionModel.championSelectionState != GameState.POST_CHAMPION_SELECTION)
         {
            return false;
         }
         if(!this._championSelectionModel.gameTypeConfig)
         {
            return false;
         }
         return this._championSelectionModel.gameTypeConfig.allowTrades;
      }
      
      protected function setTradeMessage(param1:String, param2:String, param3:Array) : void
      {
         var _loc4_:ICommand = this._championSelectionCommandFactory.getShowTradeMessageCommand(this._championTrade,param1,param2,param3);
         _loc4_.addResponder(this.onMessageTimeout);
         _loc4_.execute();
      }
      
      protected function invokeTradeAccept() : void
      {
      }
      
      protected function clearChampionTrade() : void
      {
         this.setPendingTrade(false,false,null,null,"");
         if(Boolean(this._championSelectionModel.currentPlayerSelection))
         {
            this._championSelectionModel.currentPlayerSelection.championTrade = null;
         }
         this._championTrade.tradeCancellable = false;
         if(this._tradeTimeoutId != 0)
         {
            clearTimeout(this._tradeTimeoutId);
            this._tradeTimeoutId = 0;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:PlayerSelection = null;
         this.clearChampionTrade();
         for each(_loc1_ in this._championSelectionModel.currentTeamSelections)
         {
            _loc1_.removeEventListener(PlayerSelection.CHAMPION_CHANGED,this.onPlayerChampionChanged);
         }
         this.setTradeActive(false);
         this.updateAllTradeAvailability(false);
      }
      
      protected function updateTradeAvailable(param1:PlayerSelection, param2:Boolean) : void
      {
      }
   }
}

