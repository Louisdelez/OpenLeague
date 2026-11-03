package blix.signals
{
   public interface ISignal
   {
      
      function add(param1:Function, param2:Boolean = false) : ListenerListItem;
      
      function addOnce(param1:Function, param2:Boolean = false) : ListenerListItem;
      
      function addItem(param1:ListenerListItem) : void;
      
      function remove(param1:Function) : void;
      
      function removeItem(param1:ListenerListItem) : void;
      
      function removeAll() : void;
      
      function getHasListeners() : Boolean;
   }
}

