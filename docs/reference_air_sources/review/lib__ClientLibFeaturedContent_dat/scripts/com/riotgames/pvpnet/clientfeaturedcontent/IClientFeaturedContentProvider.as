package com.riotgames.pvpnet.clientfeaturedcontent
{
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IClientFeaturedContentProvider extends IProvider
   {
      
      function displayPopup(param1:String = null) : void;
      
      function enteredMatchmakingQueue() : void;
      
      function closeFromShowAFKFilterChampionSelectionPopupActionAccepted() : void;
      
      function closeFromShowLegacyChampionSelectionPopupActionAccepted() : void;
      
      function closeFromGameViewStateChampionSelection() : void;
      
      function closeFromKeyboardEscape() : void;
      
      function closeFromCloseButtonClicked() : void;
   }
}

