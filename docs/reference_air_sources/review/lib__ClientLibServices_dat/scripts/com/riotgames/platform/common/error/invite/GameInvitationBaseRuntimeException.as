package com.riotgames.platform.common.error.invite
{
   import com.riotgames.platform.common.exception.PlatformException;
   
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.error.GameInvitationBaseRuntimeException")]
   public class GameInvitationBaseRuntimeException extends PlatformException
   {
      
      public function GameInvitationBaseRuntimeException()
      {
         super();
      }
   }
}

