package com.riotgames.platform.gameclient.init
{
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.event.XMPPEvent;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   
   public class ChatPinger
   {
      
      private var shellDispatcher:ShellDispatcher;
      
      public function ChatPinger(param1:ChatController, param2:ShellDispatcher)
      {
         super();
         this.shellDispatcher = param2;
         param1.addEventListener(XMPPEvent.EVENT_INVITE_RECIEVED,this.onChatInviteRecieved);
         param1.getChatMessageReceivedSignal().add(this.onChatMessageRecieved);
      }
      
      private function onChatMessageRecieved() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.NOTIFY));
      }
      
      private function onChatInviteRecieved(param1:XMPPEvent) : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.NOTIFY));
      }
   }
}

