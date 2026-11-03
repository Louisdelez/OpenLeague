package com.riotgames.pvpnet.game.controllers.actions
{
   import com.riotgames.platform.gameclient.domain.GameDTO;
   
   public class LeaverActionFactory
   {
      
      public function LeaverActionFactory()
      {
         super();
      }
      
      public function getIdentifyLeaversFromAFKAction(param1:GameDTO) : IdentifyLeaversFromAFKAction
      {
         return new IdentifyLeaversFromAFKAction(param1.statusOfParticipants,param1.teamOne,param1.teamTwo);
      }
   }
}

