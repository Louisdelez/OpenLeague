package com.riotgames.pvpnet.accountcreation.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class SummonerNameModel
   {
      
      public var createSummonerMode:Boolean;
      
      public var numberOfTries:int = 0;
      
      public var errorAlertShown:Boolean = false;
      
      private var _newSummonerName:String;
      
      private var _newSummonerNameChanged:Signal = new Signal();
      
      private var _summonerRenamed:Signal = new Signal();
      
      public function SummonerNameModel()
      {
         super();
      }
      
      public function get newSummonerName() : String
      {
         return this._newSummonerName;
      }
      
      public function set newSummonerName(param1:String) : void
      {
         this._newSummonerName = param1;
         this._newSummonerNameChanged.dispatch(this._newSummonerNameChanged,this._newSummonerName);
      }
      
      public function getNewSummonerNameChanged() : ISignal
      {
         return this._newSummonerNameChanged;
      }
      
      public function getSummonerRenamed() : ISignal
      {
         return this._summonerRenamed;
      }
      
      public function setSummonerRenamed() : void
      {
         this._newSummonerName = null;
         this._summonerRenamed.dispatch();
      }
   }
}

