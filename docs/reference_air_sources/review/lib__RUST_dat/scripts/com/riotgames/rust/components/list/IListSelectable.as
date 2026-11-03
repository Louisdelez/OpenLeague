package com.riotgames.rust.components.list
{
   import blix.signals.ISignal;
   
   public interface IListSelectable
   {
      
      function get selectSignal() : ISignal;
      
      function get toggleSelectSignal() : ISignal;
      
      function get selectToSignal() : ISignal;
      
      function setSelected(param1:Boolean) : void;
   }
}

