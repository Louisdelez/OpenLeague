package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IPresenceProvider extends IProvider
   {
      
      function get selfPresenceData() : PresenceStatusData;
      
      function setSummonerProfileIcon(param1:int, param2:Boolean = false) : void;
      
      function setStatusMessage(param1:String, param2:Boolean = true) : void;
      
      function setGameStatus(param1:String, param2:String, param3:Boolean, param4:Boolean) : void;
      
      function setRankedSoloRestricted(param1:Boolean, param2:Boolean = false) : void;
      
      function sendPresenceUpdateToChatRoom(param1:ChatRoom) : void;
      
      function setSkinName(param1:String, param2:Boolean = true) : void;
      
      function setAwayFlag(param1:Boolean, param2:Boolean = true) : void;
      
      function get presenceStatus() : PresenceStatusXML;
   }
}

