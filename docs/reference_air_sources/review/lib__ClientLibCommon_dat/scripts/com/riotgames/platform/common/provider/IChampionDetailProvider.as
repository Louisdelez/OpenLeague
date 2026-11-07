package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IChampionDetailProvider extends IProvider
   {
      
      function close() : void;
      
      function displayChampionDetailView(param1:String, param2:Champion, param3:int = 0, param4:Boolean = false) : void;
   }
}

