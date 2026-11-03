package com.riotgames.platform.gameclient.controllers.game.controllers.reconnect
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   
   public class NetworkReconnectDetector
   {
      
      private var _disconnectedFromNetwork:Signal = new Signal();
      
      private var _lastConnected:Boolean = true;
      
      private var _reconnectedToNetwork:Signal = new Signal();
      
      public function NetworkReconnectDetector()
      {
         super();
      }
      
      public function startDisconnectDetection() : void
      {
         this.reset();
         this._lastConnected = ServiceProxy.instance.loginService.isConnectedToLCDS;
         ServiceProxy.instance.loginService.LCDSconnectionStatusChanged.add(this.onConnectionChanged);
      }
      
      public function get disconnectedFromNetwork() : ISignal
      {
         return this._disconnectedFromNetwork;
      }
      
      public function stopDisconnectDetection() : void
      {
         this.reset();
      }
      
      private function reset() : void
      {
         ServiceProxy.instance.loginService.LCDSconnectionStatusChanged.remove(this.onConnectionChanged);
      }
      
      private function onConnectionChanged(param1:Boolean) : void
      {
         if(this._lastConnected != param1)
         {
            this._lastConnected = param1;
            if(param1)
            {
               this._reconnectedToNetwork.dispatch(this._reconnectedToNetwork);
            }
            else
            {
               this._disconnectedFromNetwork.dispatch(this._disconnectedFromNetwork);
            }
         }
      }
      
      public function get reconnectedToNetwork() : ISignal
      {
         return this._reconnectedToNetwork;
      }
   }
}

