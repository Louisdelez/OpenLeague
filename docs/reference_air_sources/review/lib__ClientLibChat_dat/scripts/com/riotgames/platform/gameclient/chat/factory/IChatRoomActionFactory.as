package com.riotgames.platform.gameclient.chat.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.ChatService;
   import org.igniterealtime.xiff.conference.Room;
   
   public interface IChatRoomActionFactory
   {
      
      function getSendInviteAction(param1:Room, param2:String, param3:Array) : IAction;
      
      function getSendResponseAction(param1:Room, param2:ChatService, param3:Array) : IAction;
   }
}

