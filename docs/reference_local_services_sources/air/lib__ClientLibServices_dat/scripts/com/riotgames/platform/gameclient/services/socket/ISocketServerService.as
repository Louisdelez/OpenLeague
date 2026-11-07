package com.riotgames.platform.gameclient.services.socket
{
   import blix.signals.ISignal;
   import flash.utils.ByteArray;
   
   public interface ISocketServerService
   {
      
      function init(param1:int = -1) : void;
      
      function get port() : int;
      
      function get clientConnectedSignal() : ISignal;
      
      function destroy() : void;
      
      function get socketDataReceived() : ISignal;
      
      function sendMessage(param1:ByteArray) : void;
   }
}

