package com.riotgames.platform.common.services
{
   import blix.signals.ISignal;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import flash.events.IEventDispatcher;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPSocketConnection;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.privatedata.IPrivatePayload;
   
   public interface ChatService extends IEventDispatcher
   {
      
      function updateRosterNote(param1:RosterItemVO, param2:String, param3:String) : void;
      
      function set reconnectionRetryLimit(param1:int) : void;
      
      function sendBuddyMessage(param1:String, param2:String) : void;
      
      function setPrivateData(param1:IPrivatePayload) : void;
      
      function removeConnectionEventListener(param1:String, param2:Function) : void;
      
      function addConnectionEventListener(param1:String, param2:Function) : void;
      
      function getPrivateDataWithPayload(param1:IPrivatePayload, param2:Function) : void;
      
      function changePresence(param1:String, param2:XMLNode) : void;
      
      function getConnection() : XMPPSocketConnection;
      
      function removeChatServiceEventListener(param1:String, param2:Function) : void;
      
      function getPrivateData(param1:String, param2:String, param3:Function) : void;
      
      function get currentState() : String;
      
      function set keepAliveInterval(param1:int) : void;
      
      function disconnect(param1:Boolean = false, param2:Boolean = true) : void;
      
      function reconnect() : void;
      
      function sendMessage(param1:UnescapedJID, param2:String, param3:XMLNode = null) : void;
      
      function get reconnectionRetryLimit() : int;
      
      function addInviteListener(param1:String, param2:Function) : void;
      
      function connect(param1:String, param2:String, param3:String, param4:MultiValueProperty, param5:int, param6:String = "standard", param7:Boolean = false, param8:Boolean = false) : void;
      
      function createMessage(param1:UnescapedJID, param2:String, param3:XMLNode = null) : Message;
      
      function get connectionInfo() : String;
      
      function get keepAliveInterval() : int;
      
      function addChatServiceEventListener(param1:String, param2:Function) : void;
      
      function set reconnectionInterval(param1:int) : void;
      
      function sendAlert(param1:String) : void;
      
      function get reconnectionInterval() : int;
      
      function get loginSuccessfulSignal() : ISignal;
   }
}

