package com.riotgames.platform.gameclient.services.socket
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.ServerSocketConnectEvent;
   import flash.net.ServerSocket;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class SocketServerService implements ISocketServerService
   {
      
      private var _clientConnectedSignal:Signal = new Signal();
      
      private var _socketDataReceived:Signal = new Signal();
      
      protected var _port:int;
      
      private var _logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _serverSocket:ServerSocket;
      
      protected var _clientSocket:Socket;
      
      public function SocketServerService()
      {
         super();
      }
      
      public function destroy() : void
      {
         this._socketDataReceived.removeAll();
         this._socketDataReceived = null;
         this._clientConnectedSignal.removeAll();
         this._clientConnectedSignal = null;
         this.destroyClientSocket();
         this.destroyServerSocket();
         this._logger = null;
      }
      
      public function get clientConnectedSignal() : ISignal
      {
         return this._clientConnectedSignal;
      }
      
      private function onServerConnect(param1:ServerSocketConnectEvent) : void
      {
         if(Boolean(this._clientSocket))
         {
            this._logger.error("com.riotgames.platform.gameclient.services.socket.SocketServerService :: Client socket already exists.");
            return;
         }
         this.setClientSocket(param1.socket);
      }
      
      private function onReceivedProgressSocketData(param1:ProgressEvent) : void
      {
         var _loc2_:ByteArray = null;
         if(this._clientSocket.bytesAvailable > 0)
         {
            _loc2_ = new ByteArray();
            this._clientSocket.readBytes(_loc2_,0,this._clientSocket.bytesAvailable);
            _loc2_.position = 0;
            this._clientSocket.flush();
            this._socketDataReceived.dispatch(_loc2_);
         }
      }
      
      public function init(param1:int = -1) : void
      {
         if(param1 == -1)
         {
            this._logger.error("com.riotgames.platform.gameclient.services.socket.SocketServerService :: Set a valid port to create your server socket.");
            return;
         }
         if(Boolean(this._serverSocket))
         {
            this._logger.error("com.riotgames.platform.gameclient.services.socket.SocketServerService :: Server socket already exists.");
            return;
         }
         this._port = param1;
         this.configureServerSocket();
      }
      
      public function get port() : int
      {
         return this._port;
      }
      
      private function configureServerSocket() : void
      {
         this._serverSocket = new ServerSocket();
         this._serverSocket.addEventListener(Event.CONNECT,this.onServerConnect);
         this._serverSocket.bind(this._port,"127.0.0.1");
         this._serverSocket.listen(1);
      }
      
      public function sendMessage(param1:ByteArray) : void
      {
         if(!this._clientSocket || !this._clientSocket.connected)
         {
            this._logger.error("com.riotgames.platform.gameclient.services.socket.SocketServerService :: Cannot send message: Client socket is not connected!");
            return;
         }
         this._clientSocket.writeBytes(param1,0,param1.length);
         this._clientSocket.flush();
      }
      
      private function setClientSocket(param1:Socket) : void
      {
         this._clientSocket = param1;
         this._clientSocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onReceivedProgressSocketData);
         this._clientSocket.addEventListener(Event.CLOSE,this.onClientSocketClosed);
         this._clientConnectedSignal.dispatch();
      }
      
      private function onClientSocketClosed(param1:Event) : void
      {
         this.destroyClientSocket();
      }
      
      private function destroyServerSocket() : void
      {
         if(Boolean(this._serverSocket))
         {
            this._serverSocket.removeEventListener(Event.CONNECT,this.onServerConnect);
            if(this._serverSocket.listening)
            {
               this._serverSocket.close();
            }
         }
         this._serverSocket = null;
      }
      
      private function destroyClientSocket() : void
      {
         if(Boolean(this._clientSocket))
         {
            this._clientSocket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onReceivedProgressSocketData);
            this._clientSocket.removeEventListener(Event.CLOSE,this.onClientSocketClosed);
            if(this._clientSocket.connected)
            {
               this._clientSocket.close();
            }
         }
         this._clientSocket = null;
      }
      
      public function get socketDataReceived() : ISignal
      {
         return this._socketDataReceived;
      }
   }
}

