package com.riotgames.pvpnet.suggestedplayers
{
   import com.riotgames.platform.gameclient.domain.EndOfGameStats;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import mx.collections.ArrayCollection;
   
   [GenerateProxy]
   public interface ISuggestedPlayersProvider extends IProvider
   {
      
      function getSuggestedPlayerModels(param1:GameQueueConfig, param2:Function) : void;
      
      function handleEndOfGameEvent(param1:EndOfGameStats) : void;
      
      function declineSuggestedPlayerAndGetReplacement(param1:ArrayCollection, param2:SuggestedPlayer) : void;
      
      function updateSuggestedPlayerVisibility(param1:ArrayCollection) : void;
      
      function notifyGameLaunched(param1:Number, param2:Number) : void;
      
      function notifyLobbyDisbanded(param1:Number) : void;
      
      function handlePlayerHonored(param1:String) : void;
      
      function handlePlayerReported(param1:String) : void;
   }
}

