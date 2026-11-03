package com.riotgames.pvpnet.cap.views
{
   import com.riotgames.pvpnet.cap.views.components.ICapButtonsFooterComponent;
   import com.riotgames.pvpnet.cap.views.popups.CapSoloGroupFoundPopup;
   
   public interface ICapView
   {
      
      function get soloGroupFoundPopup() : CapSoloGroupFoundPopup;
      
      function showTeamViewForInvitee() : void;
      
      function get buttonsFooter() : ICapButtonsFooterComponent;
      
      function hideGroupFoundPopup() : void;
      
      function showSoloView() : void;
      
      function showTeamViewForSolo() : void;
      
      function showTeamViewForCaptain() : void;
      
      function showGroupFoundPopup() : void;
   }
}

