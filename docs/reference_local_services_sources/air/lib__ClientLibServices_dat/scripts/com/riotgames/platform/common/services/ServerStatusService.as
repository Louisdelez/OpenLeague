package com.riotgames.platform.common.services
{
   import blix.signals.ISignal;
   import flash.events.IEventDispatcher;
   
   public interface ServerStatusService extends IEventDispatcher
   {
      
      function getStatusRefreshed() : ISignal;
      
      function set hostString(param1:String) : void;
      
      function getServerStatus() : void;
      
      function set endpointString(param1:String) : void;
   }
}

