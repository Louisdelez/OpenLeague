package blix.ds
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   
   public interface IListX extends IDestructible
   {
      
      function getReset() : ISignal;
      
      function getItemsUpdated() : ISignal;
      
      function getItemsAdded() : ISignal;
      
      function getItemsRemoved() : ISignal;
      
      function addItem(param1:Object) : void;
      
      function addItemAt(param1:Object, param2:int) : void;
      
      function setItemAt(param1:Object, param2:int) : void;
      
      function getItemAt(param1:int) : Object;
      
      function getItemIndex(param1:Object, param2:int = 0) : int;
      
      function removeItem(param1:Object) : Boolean;
      
      function removeItemAt(param1:int) : Object;
      
      function removeAll() : void;
      
      function updateItems(param1:Array) : void;
      
      function getLength() : uint;
      
      function setLength(param1:uint) : void;
      
      function getIterator(param1:int = -1) : IIterator;
      
      function getSource() : Object;
      
      function setSource(param1:Object) : void;
      
      function toArray() : Array;
   }
}

