package com.riotgames.platform.module.masteries.views.renderers
{
   import blix.components.button.ButtonX;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class CreateMasteryPageButtonProxy extends ButtonX
   {
      
      public function CreateMasteryPageButtonProxy(param1:IContext)
      {
         super(param1);
         setLinkage("PageCreationButton");
         assignToolTip(this,RiotResourceLoader.getString("masteries_button_newPage_tooltip","Create Page"));
      }
   }
}

