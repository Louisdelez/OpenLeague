package com.riotgames.pvpnet.chrome
{
   import com.riotgames.platform.provider.IProvider;
   
   public interface IChromePopupsProvider extends IProvider
   {
      
      function showPreferencesPopup() : void;
      
      function showSummonerIconChoosePopup() : void;
      
      function showHelpPopup() : void;
   }
}

