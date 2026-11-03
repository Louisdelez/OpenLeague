package com.riotgames.platform.common.xmpp.logging
{
   import com.riotgames.platform.common.services.ChatService;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   
   public class XMPPSessionLogger
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _id:String = "";
      
      private var _chatService:ChatService;
      
      public function XMPPSessionLogger()
      {
         super();
      }
      
      private function onConnect(param1:ConnectionSuccessEvent) : void
      {
         this.constructId();
      }
      
      private function onXMPPSessionIncomingData(param1:IncomingDataEvent) : void
      {
      }
      
      public function startLoggingIfNecessary(param1:Boolean) : void
      {
         if(param1)
         {
            this._chatService.removeConnectionEventListener(IncomingDataEvent.INCOMING_DATA,this.onXMPPSessionIncomingData);
            this._chatService.removeConnectionEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onXMPPSessionOutgoingData);
            this._chatService.removeConnectionEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnect);
         }
      }
      
      private function onXMPPSessionOutgoingData(param1:OutgoingDataEvent) : void
      {
      }
      
      private function constructId() : void
      {
         var port:int = 0;
         var server:String = null;
         try
         {
            port = int(this._chatService.getConnection().port);
            server = this._chatService.getConnection().server;
            if(Boolean(server))
            {
               this._id = server + ":" + port;
            }
            else
            {
               this._id = "connecting...";
            }
         }
         catch(error:Error)
         {
            logger.error("Failed to extract connection details [" + error.message + "]");
         }
      }
      
      public function setChatService(param1:ChatService) : void
      {
         this._chatService = param1;
         if(this._chatService != null)
         {
            this._chatService.addConnectionEventListener(IncomingDataEvent.INCOMING_DATA,this.onXMPPSessionIncomingData);
            this._chatService.addConnectionEventListener(OutgoingDataEvent.OUTGOING_DATA,this.onXMPPSessionOutgoingData);
            this._chatService.addConnectionEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.onConnect);
            this.constructId();
         }
      }
   }
}

