package com.riotgames.platform.gameclient.popup
{
   import com.riotgames.pvpnet.chrome.IChromePopupsProvider;
   
   public class PopupProvider implements IChromePopupsProvider
   {
      
      private var showHelpPopupAction:ShowHelpPopupAction = new ShowHelpPopupAction();
      
      private var showPreferencesPopupAction:ShowPreferencesPopupAction = new ShowPreferencesPopupAction();
      
      private var showChooseSummonerIconPopupAction:ShowChooseSummonerIconPopupAction = new ShowChooseSummonerIconPopupAction();
      
      public function PopupProvider()
      {
         super();
      }
      
      public function showSummonerIconChoosePopup() : void
      {
         this.showChooseSummonerIconPopupAction.add();
      }
      
      public function showHelpPopup() : void
      {
         this.showHelpPopupAction.add();
      }
      
      public function showPreferencesPopup() : void
      {
         this.showPreferencesPopupAction.add();
      }
   }
}

