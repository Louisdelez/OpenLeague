package com.riotgames.platform.common
{
   import blix.IDestructible;
   import blix.ds.LinkedListItem;
   
   public class DestructibleListItem extends LinkedListItem implements IDestructible
   {
      
      public function DestructibleListItem(param1:* = null)
      {
         super(param1);
      }
      
      public function destroy() : void
      {
      }
   }
}

