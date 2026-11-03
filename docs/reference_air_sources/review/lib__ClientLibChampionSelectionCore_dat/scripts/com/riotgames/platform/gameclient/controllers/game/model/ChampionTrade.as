package com.riotgames.platform.gameclient.controllers.game.model
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ChampionTrade extends EventDispatcher
   {
      
      public static const PENDING_TRADE_CHANGED:String = "pendingTradeChanged";
      
      public static const TRADE_HOST_CHANGED:String = "tradeHostChanged";
      
      public static const PENDING_CHAMPION_CHANGED:String = "pendingChampionChanged";
      
      public static const SELECTED_CHAMPION_CHANGED:String = "selectedChampionChanged";
      
      public static const PENDING_TRADER_NAME_CHANGED:String = "pendingTraderNameChanged";
      
      public static const TRADE_CANCELLABLE_CHANGED:String = "tradeCancellableChanged";
      
      public static const TRADE_MESSAGE_CHANGED:String = "tradeMessageChanged";
      
      public static const TRADE_TITLE_CHANGED:String = "tradeTitleChanged";
      
      private var _selectedChampion:Champion = null;
      
      private var _pendingTraderDisplayName:String = "";
      
      private var _tradeTitle:String;
      
      private var _pendingChampion:Champion = null;
      
      private var _397711579cancellableTradeParticipant:String = "";
      
      private var _tradeHost:Boolean = false;
      
      private var _tradeCancellable:Boolean = false;
      
      private var _pendingTraderName:String = null;
      
      private var _pendingTrade:Boolean = false;
      
      private var _tradeMessage:String = "";
      
      public function ChampionTrade()
      {
         super();
      }
      
      public function set pendingChampion(param1:Champion) : void
      {
         if(this._pendingChampion == param1)
         {
            return;
         }
         this._pendingChampion = param1;
         dispatchEvent(new Event(PENDING_CHAMPION_CHANGED));
      }
      
      public function set selectedChampion(param1:Champion) : void
      {
         if(this._selectedChampion == param1)
         {
            return;
         }
         this._selectedChampion = param1;
         dispatchEvent(new Event(SELECTED_CHAMPION_CHANGED));
      }
      
      [Bindable(event="tradeMessageChanged")]
      public function get tradeMessage() : String
      {
         return this._tradeMessage;
      }
      
      [Bindable(event="pendingTradeChanged")]
      public function get pendingTrade() : Boolean
      {
         return this._pendingTrade;
      }
      
      [Bindable(event="tradeCancellableChanged")]
      public function get tradeCancellable() : Boolean
      {
         return this._tradeCancellable;
      }
      
      public function set pendingTraderDisplayName(param1:String) : void
      {
         if(this._pendingTraderDisplayName == param1)
         {
            return;
         }
         this._pendingTraderDisplayName = param1;
      }
      
      [Bindable(event="tradeTitleChanged")]
      public function get tradeTitle() : String
      {
         return this._tradeTitle;
      }
      
      public function set tradeCancellable(param1:Boolean) : void
      {
         if(param1 == this._tradeCancellable)
         {
            return;
         }
         this._tradeCancellable = param1;
         if(!this.tradeCancellable)
         {
            this.cancellableTradeParticipant = "";
         }
         else
         {
            this.cancellableTradeParticipant = this._pendingTraderName;
         }
         dispatchEvent(new Event(TRADE_CANCELLABLE_CHANGED));
      }
      
      [Bindable(event="propertyChange")]
      public function get cancellableTradeParticipant() : String
      {
         return this._397711579cancellableTradeParticipant;
      }
      
      public function set tradeMessage(param1:String) : void
      {
         if(this._tradeMessage == param1)
         {
            return;
         }
         this._tradeMessage = param1;
         dispatchEvent(new Event(TRADE_MESSAGE_CHANGED));
      }
      
      public function set tradeHost(param1:Boolean) : void
      {
         if(this._tradeHost == param1)
         {
            return;
         }
         this._tradeHost = param1;
         dispatchEvent(new Event(TRADE_HOST_CHANGED));
      }
      
      [Bindable(event="pendingChampionChanged")]
      public function get pendingChampion() : Champion
      {
         return this._pendingChampion;
      }
      
      [Bindable(event="selectedChampionChanged")]
      public function get selectedChampion() : Champion
      {
         return this._selectedChampion;
      }
      
      public function set pendingTraderName(param1:String) : void
      {
         if(this._pendingTraderName == param1)
         {
            return;
         }
         this._pendingTraderName = param1;
         dispatchEvent(new Event(PENDING_TRADER_NAME_CHANGED));
      }
      
      [Bindable(event="pendingTraderDisplayNameChanged")]
      public function get pendingTraderDisplayName() : String
      {
         return this._pendingTraderDisplayName;
      }
      
      [Bindable(event="tradeHostChanged")]
      public function get tradeHost() : Boolean
      {
         return this._tradeHost;
      }
      
      public function set tradeTitle(param1:String) : void
      {
         if(this._tradeTitle == param1)
         {
            return;
         }
         this._tradeTitle = param1;
         dispatchEvent(new Event(TRADE_TITLE_CHANGED));
      }
      
      [Bindable(event="pendingTraderNameChanged")]
      public function get pendingTraderName() : String
      {
         return this._pendingTraderName;
      }
      
      public function set pendingTrade(param1:Boolean) : void
      {
         if(param1 == this._pendingTrade)
         {
            return;
         }
         this._pendingTrade = param1;
         dispatchEvent(new Event(PENDING_TRADE_CHANGED));
      }
      
      public function set cancellableTradeParticipant(param1:String) : void
      {
         var _loc2_:Object = this._397711579cancellableTradeParticipant;
         if(_loc2_ !== param1)
         {
            this._397711579cancellableTradeParticipant = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancellableTradeParticipant",_loc2_,param1));
         }
      }
   }
}

