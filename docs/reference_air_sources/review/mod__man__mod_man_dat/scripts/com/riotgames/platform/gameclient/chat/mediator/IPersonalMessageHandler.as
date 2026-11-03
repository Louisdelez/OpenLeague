package com.riotgames.platform.gameclient.chat.mediator
{
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public interface IPersonalMessageHandler
   {
      
      function personalChatMessageReceived(param1:RosterItemVO, param2:Message) : void;
      
      function closePersonalPopupWindow(param1:UnescapedJID) : void;
      
      function closePersonalPopupWindowByName(param1:String) : void;
      
      function createPersonalPopUp(param1:RosterItemVO, param2:Boolean = false) : void;
   }
}

