package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface ISpellsProvider extends IProvider
   {
      
      function show(param1:DisplayAdapter, param2:SummonerLevel) : void;
      
      function hide() : void;
   }
}

