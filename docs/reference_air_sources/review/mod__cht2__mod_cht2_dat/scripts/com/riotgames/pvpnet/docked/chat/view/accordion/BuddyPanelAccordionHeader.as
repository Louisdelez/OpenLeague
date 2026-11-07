package com.riotgames.pvpnet.docked.chat.view.accordion
{
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   
   public class BuddyPanelAccordionHeader extends LabelButtonX
   {
      
      public function BuddyPanelAccordionHeader(param1:IContext)
      {
         super(param1);
         setLinkage("SectionHeader");
      }
      
      override public function setData(param1:*) : void
      {
         super.setData(param1);
         if(param1 is String)
         {
            setText(param1);
         }
      }
   }
}

