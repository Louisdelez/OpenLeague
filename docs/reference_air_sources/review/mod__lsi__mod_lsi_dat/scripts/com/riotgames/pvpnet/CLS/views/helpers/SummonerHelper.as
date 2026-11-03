package com.riotgames.pvpnet.CLS.views.helpers
{
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   
   public class SummonerHelper implements ISummonerHelper
   {
      
      private var _currentSummoner:String;
      
      private var _summonerProfileController:ISummonerProfileProvider;
      
      public function SummonerHelper()
      {
         super();
      }
      
      public function get currentSummoner() : String
      {
         return this._currentSummoner;
      }
      
      public function set currentSummoner(param1:String) : void
      {
         this._currentSummoner = param1;
      }
      
      public function get summonerProfileController() : ISummonerProfileProvider
      {
         return this._summonerProfileController;
      }
      
      public function set summonerProfileController(param1:ISummonerProfileProvider) : void
      {
         this._summonerProfileController = param1;
      }
   }
}

