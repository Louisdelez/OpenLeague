package com.riotgames.platform.gameclient.domain.broadcast
{
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.ClientLoginRankedTeamDeletedNotification")]
   public class ClientLoginRankedTeamDeletedNotification implements IClientNotification
   {
      
      public var teamName:String;
      
      public var teamTag:String;
      
      public var teamId:TeamId;
      
      public function ClientLoginRankedTeamDeletedNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.LOGIN_DELETED;
      }
   }
}

