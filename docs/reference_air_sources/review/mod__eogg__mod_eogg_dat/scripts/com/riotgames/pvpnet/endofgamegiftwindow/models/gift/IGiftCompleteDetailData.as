package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public interface IGiftCompleteDetailData
   {
      
      function get isErrorState() : Boolean;
      
      function get giftDetailData() : IEndOfGameGiftDetailData;
      
      function get errorData() : IGiftErrorData;
   }
}

