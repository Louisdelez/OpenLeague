package com.riotgames.platform.common.error.invite
{
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.error.PlayerDoesNotExistException")]
   public class PlayerDoesNotExistException extends GameInvitationBaseRuntimeException
   {
      
      public function PlayerDoesNotExistException()
      {
         super();
      }
   }
}

