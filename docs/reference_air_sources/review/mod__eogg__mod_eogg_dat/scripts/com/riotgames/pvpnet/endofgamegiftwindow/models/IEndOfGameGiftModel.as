package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.dto.SendGiftRequestDTO;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.player.IPlayerSummary;
   
   public interface IEndOfGameGiftModel extends IDestructible
   {
      
      function sessionPlayerCanGift() : Boolean;
      
      function getPlayerGiftable(param1:IPlayerSummary) : Boolean;
      
      function getGiftButtonToolTip(param1:IPlayerSummary) : String;
      
      function getGiftWindowTitleString() : String;
      
      function getNextButtonLabel() : String;
      
      function getBackButtonLabel() : String;
      
      function getBucketLabel(param1:String) : String;
      
      function updateGiftRecipient(param1:IPlayerSummary) : void;
      
      function updateGiftList(param1:Vector.<AvailableGiftCategory>) : void;
      
      function changeGiftSelection(param1:IEndOfGameGift) : void;
      
      function updateGiftSelected() : void;
      
      function revertGiftSelected() : void;
      
      function changeMessageSelection(param1:Object) : void;
      
      function getUnlockGiftPayload() : SendGiftRequestDTO;
      
      function setEOGGServiceError(param1:Number, param2:String) : void;
      
      function updateGiftSentSuccess(param1:IEndOfGameGift) : void;
      
      function resetGiftingSessionData() : void;
      
      function getGiftListUpdated() : ISignal;
      
      function getGiftRecipientUpdate() : ISignal;
      
      function getSelectedGiftUpdated() : ISignal;
      
      function getSelectedMessageUpdate() : ISignal;
      
      function getUnlockGiftPayloadReady() : ISignal;
      
      function getServiceErrorReceived() : ISignal;
      
      function getGiftSentSuccess() : ISignal;
   }
}

