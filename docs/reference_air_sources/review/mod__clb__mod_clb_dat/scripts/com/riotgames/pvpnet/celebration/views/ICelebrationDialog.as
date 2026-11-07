package com.riotgames.pvpnet.celebration.views
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.view.ILayoutElement;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   
   public interface ICelebrationDialog extends ILayoutElement, IDestructible
   {
      
      function setModel(param1:SimpleDialogMessage, param2:String) : void;
      
      function getDialogDismissed() : ISignal;
   }
}

