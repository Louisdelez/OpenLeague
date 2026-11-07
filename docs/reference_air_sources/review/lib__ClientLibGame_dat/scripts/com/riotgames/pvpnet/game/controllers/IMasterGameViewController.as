package com.riotgames.pvpnet.game.controllers
{
   public interface IMasterGameViewController extends ICycleViewController
   {
      
      function initChatRoom(param1:String, param2:String, param3:String, param4:Function = null) : void;
      
      function leaveChatRoom() : void;
   }
}

