package com.riotgames.pvpnet.cap.actions
{
   import mx.rpc.Fault;
   
   public interface ICapFaultHandler
   {
      
      function handleFault(param1:Fault) : void;
   }
}

