package com.riotgames.pvpnet.CLS.views.helpers
{
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   
   public interface ISummonerHelper
   {
      
      function get currentSummoner() : String;
      
      function set currentSummoner(param1:String) : void;
      
      function get summonerProfileController() : ISummonerProfileProvider;
      
      function set summonerProfileController(param1:ISummonerProfileProvider) : void;
   }
}

