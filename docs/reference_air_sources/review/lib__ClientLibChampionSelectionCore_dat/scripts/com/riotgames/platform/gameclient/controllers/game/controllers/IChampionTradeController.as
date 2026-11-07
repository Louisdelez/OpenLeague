package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   
   public interface IChampionTradeController
   {
      
      function initialize() : void;
      
      function cancelTrade() : void;
      
      function requestTrade(param1:PlayerParticipant, param2:Champion) : void;
      
      function rejectTrade() : void;
      
      function destroy() : void;
      
      function acceptTrade() : void;
   }
}

