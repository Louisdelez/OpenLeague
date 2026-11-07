package com.riotgames.pvpnet.CLS.dataprovider
{
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.CLS.models.SummonerObjectModel;
   
   public interface ILeagueDataProviderLocal extends IProvider
   {
      
      function get summoner() : SummonerObjectModel;
      
      function get self() : Boolean;
   }
}

