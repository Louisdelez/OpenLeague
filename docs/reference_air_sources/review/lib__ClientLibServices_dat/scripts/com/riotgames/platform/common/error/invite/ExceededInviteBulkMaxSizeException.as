package com.riotgames.platform.common.error.invite
{
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.error.ExceededInviteBulkMaxSizeException")]
   public class ExceededInviteBulkMaxSizeException extends GameInvitationBaseRuntimeException
   {
      
      private var _inviteBulkMaxSize:int;
      
      public function ExceededInviteBulkMaxSizeException()
      {
         super();
      }
      
      public function get inviteBulkMaxSize() : int
      {
         return this._inviteBulkMaxSize;
      }
      
      public function set inviteBulkMaxSize(param1:int) : void
      {
         this._inviteBulkMaxSize = param1;
      }
   }
}

