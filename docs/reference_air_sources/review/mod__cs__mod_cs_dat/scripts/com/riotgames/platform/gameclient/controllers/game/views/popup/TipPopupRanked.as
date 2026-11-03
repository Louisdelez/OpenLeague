package com.riotgames.platform.gameclient.controllers.game.views.popup
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.MouseEvent;
   import mx.controls.CheckBox;
   
   public class TipPopupRanked extends TipPopup
   {
      
      private static const TOOLTIP_PADDING_Y:int = 65;
      
      public function TipPopupRanked()
      {
         super();
         tipType = "ranked";
      }
      
      override protected function onPreferencesChanged(param1:MouseEvent) : void
      {
         UserPreferencesManager.userPrefs.rankedChampionSelectTipsEnabled = !toggleCheckbox.selected;
      }
      
      override protected function createToggleCheckBox() : void
      {
         toggleCheckbox = new CheckBox();
         toggleCheckbox.selected = !UserPreferencesManager.userPrefs.rankedChampionSelectTipsEnabled;
         toggleCheckbox.addEventListener(MouseEvent.CLICK,this.onPreferencesChanged);
      }
      
      override protected function createFooterLabel() : void
      {
         super.createFooterLabel();
         if(footer == null || footer == "")
         {
            footerLabel.text = resourceManager.getString("resources","rankedTip_footer_toggleOff");
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2 + TOOLTIP_PADDING_Y);
      }
   }
}

