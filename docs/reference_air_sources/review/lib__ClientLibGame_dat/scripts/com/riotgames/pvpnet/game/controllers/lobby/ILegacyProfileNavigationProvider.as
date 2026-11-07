package com.riotgames.pvpnet.game.controllers.lobby
{
   import com.riotgames.platform.gameclient.domain.BaseSummoner;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILegacyProfileNavigationProvider extends IProvider
   {
      
      function searchForSummoner(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function reviewSummonerProfile(param1:BaseSummoner, param2:String = null) : Boolean;
   }
}

