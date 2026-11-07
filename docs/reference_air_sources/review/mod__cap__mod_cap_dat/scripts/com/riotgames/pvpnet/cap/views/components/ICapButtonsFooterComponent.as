package com.riotgames.pvpnet.cap.views.components
{
   import blix.signals.ISignal;
   
   public interface ICapButtonsFooterComponent
   {
      
      function showSoloView() : void;
      
      function setActionButtonMouseEnabled(param1:Boolean) : void;
      
      function setActionButtonVisible(param1:Boolean) : void;
      
      function setFindAnotherGroupButtonVisible(param1:Boolean) : void;
      
      function setActionButtonLabel(param1:String) : void;
      
      function get quitButtonClicked() : ISignal;
      
      function showTeamViewForSolo() : void;
      
      function showTeamViewForInvitee() : void;
      
      function setActionButtonEnabled(param1:Boolean) : void;
      
      function setActionButtonReadyState(param1:uint) : void;
      
      function showTeamViewForCaptain() : void;
      
      function get actionButtonClicked() : ISignal;
   }
}

