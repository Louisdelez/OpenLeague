package com.riotgames.pvpnet.matchhistoryiron.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class MatchHistoryModel
   {
      
      private var _recentGameList:Vector.<MatchHistoryStatModel>;
      
      private var _onUpdateSignal:Signal;
      
      private var _isInitialized:Boolean;
      
      private var _accountId:Number;
      
      public function MatchHistoryModel()
      {
         super();
         this._isInitialized = false;
         this._onUpdateSignal = new Signal();
      }
      
      public function updateModel(param1:Vector.<MatchHistoryStatModel>, param2:Number) : void
      {
         this._accountId = param2;
         this._recentGameList = param1;
         this._onUpdateSignal.dispatch();
         this._isInitialized = true;
      }
      
      public function get recentGameList() : Vector.<MatchHistoryStatModel>
      {
         return this._recentGameList;
      }
      
      public function get onUpdateSignal() : ISignal
      {
         return this._onUpdateSignal;
      }
      
      public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      public function get accountId() : Number
      {
         return this._accountId;
      }
   }
}

