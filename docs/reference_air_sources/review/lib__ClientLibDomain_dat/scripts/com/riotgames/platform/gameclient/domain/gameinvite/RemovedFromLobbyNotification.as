package com.riotgames.platform.gameclient.domain.gameinvite
{
   [RemoteClass(alias="com.riotgames.platform.gameinvite.contract.RemovedFromLobbyNotification")]
   public class RemovedFromLobbyNotification
   {
      
      private var _removalReason:String;
      
      public function RemovedFromLobbyNotification()
      {
         super();
      }
      
      public function get removalReason() : String
      {
         return this._removalReason;
      }
      
      public function set removalReason(param1:String) : void
      {
         this._removalReason = param1;
      }
   }
}

