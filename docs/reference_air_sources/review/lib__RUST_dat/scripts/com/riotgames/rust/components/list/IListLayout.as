package com.riotgames.rust.components.list
{
   import blix.signals.ISignal;
   
   public interface IListLayout
   {
      
      function set data(param1:Array) : void;
      
      function get data() : Array;
      
      function doLayout() : void;
      
      function resetLayout() : void;
      
      function snap() : void;
      
      function step(param1:int) : void;
      
      function page(param1:int) : void;
      
      function getSelectionChanged() : ISignal;
      
      function getSelectedIndex() : int;
      
      function setSelectedIndex(param1:int) : void;
      
      function getSelectedIndexes() : Array;
      
      function setSelectedIndexes(param1:Array) : void;
      
      function get allowMultiSelection() : Boolean;
      
      function set allowMultiSelection(param1:Boolean) : void;
   }
}

