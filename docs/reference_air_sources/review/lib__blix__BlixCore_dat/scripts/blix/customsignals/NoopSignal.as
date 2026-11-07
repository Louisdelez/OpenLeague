package blix.customsignals
{
   import blix.signals.ISignal;
   import blix.signals.ListenerListItem;
   
   public class NoopSignal implements ISignal
   {
      
      public function NoopSignal()
      {
         super();
      }
      
      public function add(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         return null;
      }
      
      public function addItem(param1:ListenerListItem) : void
      {
      }
      
      public function addOnce(param1:Function, param2:Boolean = false) : ListenerListItem
      {
         return null;
      }
      
      public function remove(param1:Function) : void
      {
      }
      
      public function removeItem(param1:ListenerListItem) : void
      {
      }
      
      public function removeAll() : void
      {
      }
      
      public function getHasListeners() : Boolean
      {
         return false;
      }
   }
}

