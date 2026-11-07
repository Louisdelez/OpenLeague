package com.riotgames.pvpnet.game.alerts
{
   import blix.signals.ISignal;
   import mx.collections.ArrayCollection;
   
   public interface ILeaverBusterAlertAction
   {
      
      function showDialogueForLeavers(param1:ArrayCollection, param2:Boolean) : void;
      
      function getDialogueAborted() : ISignal;
      
      function getDialogueWaitCompleted() : ISignal;
      
      function removeDialogue() : void;
   }
}

