package com.riotgames.platform.gameclient.chat.views.chatpanel
{
   import mx.core.Container;
   
   public interface IChatWindow
   {
      
      function set supressRemoveHandler(param1:Boolean) : void;
      
      function clearMessageWaiting() : void;
      
      function bindSize(param1:Container) : void;
   }
}

