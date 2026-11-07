package com.riotgames.platform.gameclient.module.rt.view.stats
{
   import blix.context.Context;
   import com.riotgames.rust.components.list.renderer.DefaultListItem;
   
   public class QueueDropdownRenderer extends DefaultListItem
   {
      
      public function QueueDropdownRenderer(param1:Context)
      {
         super(param1);
      }
      
      override protected function updateText() : void
      {
         var _loc1_:Object = getData();
         if(_loc1_ != null)
         {
            setText(_loc1_.label);
         }
      }
   }
}

