package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftCompleteDetailData implements IGiftCompleteDetailData
   {
      
      private var _isErrorState:Boolean = false;
      
      private var _giftDetailData:IEndOfGameGiftDetailData;
      
      private var _errorData:IGiftErrorData;
      
      public function GiftCompleteDetailData(param1:IEndOfGameGiftDetailData, param2:IGiftErrorData = null)
      {
         super();
         this._giftDetailData = param1;
         if(param2 != null)
         {
            this._isErrorState = true;
            this._errorData = param2;
         }
      }
      
      public function get isErrorState() : Boolean
      {
         return this._isErrorState;
      }
      
      public function get giftDetailData() : IEndOfGameGiftDetailData
      {
         return this._giftDetailData;
      }
      
      public function get errorData() : IGiftErrorData
      {
         return this._errorData;
      }
   }
}

