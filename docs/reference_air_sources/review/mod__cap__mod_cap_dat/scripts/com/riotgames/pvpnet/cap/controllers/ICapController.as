package com.riotgames.pvpnet.cap.controllers
{
   import blix.IDestructible;
   import blix.action.IAction;
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   
   public interface ICapController extends IDestructible
   {
      
      function trackPlayAgainMetrics() : void;
      
      function get quitCompletedSignal() : ISignal;
      
      function selectRunePage(param1:SpellBookPageDTO) : void;
      
      function hideView() : void;
      
      function hasQuit() : void;
      
      function get isInitialized() : Boolean;
      
      function selectChampion(param1:Champion) : void;
      
      function declineSuggestedPlayer(param1:SuggestedPlayer) : void;
      
      function selectAdvertisedRole(param1:CapRole, param2:int = -1) : void;
      
      function initialize() : void;
      
      function selectRole(param1:CapRole, param2:int = -1) : void;
      
      function displayStatusMessage(param1:String) : void;
      
      function selectPosition(param1:CapPosition, param2:int = -1) : void;
      
      function launchInvites() : void;
      
      function selectSkin(param1:ChampionSkin) : void;
      
      function inviteSuggestedPlayer(param1:SuggestedPlayer) : void;
      
      function searchForAnotherGroup() : void;
      
      function retrieveEstimatedWaitTime() : IAction;
      
      function get intializedSignal() : ISignal;
      
      function leaveChatRoom() : void;
      
      function joinChatRoom() : void;
      
      function selectMasteryPage(param1:MasteryPageInfoSummary) : void;
      
      function unreadyGroup() : Boolean;
      
      function closeLobbyToAdditionalInvitees() : void;
      
      function requestQuit(param1:Boolean = false, param2:Function = null, param3:Function = null) : void;
   }
}

