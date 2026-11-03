package com.riotgames.pvpnet.game.alerts
{
   import blix.action.IAction;
   import mx.collections.ArrayCollection;
   
   public interface IRankedQueueFailureAlertAction extends IAction
   {
      
      function add(param1:ArrayCollection, param2:int = 0) : void;
   }
}

