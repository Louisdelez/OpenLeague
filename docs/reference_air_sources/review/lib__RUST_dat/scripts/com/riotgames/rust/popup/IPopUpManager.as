package com.riotgames.rust.popup
{
   import blix.signals.ISignal;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   
   public interface IPopUpManager
   {
      
      function addPopUp(param1:ILayoutElement, param2:ILayoutData = null, param3:Boolean = false) : void;
      
      function removePopUp(param1:ILayoutElement) : Boolean;
      
      function removeAllPopUps() : void;
      
      function getInModalModeChanged() : ISignal;
      
      function getInModalMode() : Boolean;
   }
}

