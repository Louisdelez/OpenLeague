package com.riotgames.pvpnet.championinventory.views
{
   import blix.context.IContext;
   import com.riotgames.rust.components.dropdown.Dropdown;
   import com.riotgames.rust.context.popup.IPopupContext;
   import flash.events.MouseEvent;
   
   public class ChampionInventoryDropdown extends Dropdown
   {
      
      public function ChampionInventoryDropdown(param1:IContext)
      {
         super(param1);
      }
      
      override protected function showList() : void
      {
         var _loc1_:int = int(list.getSelectedIndex());
         super.showList();
         if(_loc1_ != -1)
         {
            list.setSelectedIndex(_loc1_);
         }
         else
         {
            list.setSelectedIndex(0);
         }
         var _loc2_:IPopupContext = getFirstContext(IPopupContext);
         _loc2_.setPosition(list,this,button.getX(),button.getY() + button.getHeight());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         button.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         button.setCurrentState("up");
      }
   }
}

