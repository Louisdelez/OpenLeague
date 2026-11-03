package com.riotgames.platform.gameclient.module.services.rest
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.event.ServerStatusEvent;
   import com.riotgames.platform.common.services.ServerStatusService;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ServerStatusServiceImpl extends EventDispatcher implements ServerStatusService
   {
      
      internal var urlLoader:URLLoader = new URLLoader();
      
      private var _endpointString:String = null;
      
      private var _statusRefreshed:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _hostString:String = null;
      
      public function ServerStatusServiceImpl()
      {
         super();
      }
      
      private function parseResults(param1:String) : void
      {
         var data:Object = null;
         var serverStatusEvent:ServerStatusEvent = null;
         var messageIndex:int = 0;
         var message:Object = null;
         var broadcastMessage:BroadcastMessage = null;
         var currentLocale:String = null;
         var i:int = 0;
         var translation:Object = null;
         var json:String = param1;
         try
         {
            data = jsonDecode(json);
         }
         catch(error:Error)
         {
            dispatchEvent(new ServerStatusEvent(ServerStatusEvent.STATUS_FAILED));
            return;
         }
         if(data.messages != null && data.messages.length > 0)
         {
            serverStatusEvent = new ServerStatusEvent(ServerStatusEvent.STATUS_RECEIVED);
            serverStatusEvent.messages = new Vector.<BroadcastMessage>();
            messageIndex = 0;
            while(messageIndex < data.messages.length)
            {
               message = data.messages[messageIndex];
               broadcastMessage = new BroadcastMessage();
               broadcastMessage.severity = message.severity;
               broadcastMessage.content = message.content;
               if(message.translations.length > 0)
               {
                  currentLocale = ClientConfig.instance.locale;
                  i = 0;
                  while(i < message.translations.length)
                  {
                     translation = message.translations[i];
                     if(translation.locale == currentLocale)
                     {
                        broadcastMessage.content = translation.content;
                     }
                     i++;
                  }
               }
               serverStatusEvent.messages.push(broadcastMessage);
               messageIndex++;
            }
            dispatchEvent(serverStatusEvent);
         }
         else
         {
            dispatchEvent(new ServerStatusEvent(ServerStatusEvent.STATUS_FAILED));
         }
      }
      
      public function getServerStatus() : void
      {
         if(this._endpointString == null)
         {
            return;
         }
         var _loc1_:String = this._endpointString + "/shards/" + this._hostString + "/summary";
         var _loc2_:URLRequest = new URLRequest(_loc1_);
         _loc2_.requestHeaders = new Array(new URLRequestHeader("Connection","close"));
         this.urlLoader.addEventListener(Event.COMPLETE,this.onServerStatusReceived);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onServerStatusFault);
         this.urlLoader.load(_loc2_);
         this._statusRefreshed.dispatch();
      }
      
      public function set endpointString(param1:String) : void
      {
         this._endpointString = param1;
      }
      
      private function onServerStatusFault(param1:Event) : void
      {
         dispatchEvent(new ServerStatusEvent(ServerStatusEvent.STATUS_FAILED));
      }
      
      public function getStatusRefreshed() : ISignal
      {
         return this._statusRefreshed;
      }
      
      private function onServerStatusReceived(param1:Event) : void
      {
         this.parseResults(this.urlLoader.data);
      }
      
      public function set hostString(param1:String) : void
      {
         this._hostString = param1;
      }
   }
}

