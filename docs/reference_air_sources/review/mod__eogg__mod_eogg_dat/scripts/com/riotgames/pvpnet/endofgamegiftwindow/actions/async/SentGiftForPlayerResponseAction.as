package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IGiftListValueObjectFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftServiceResponseTypes;
   
   public class SentGiftForPlayerResponseAction extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "purchaseGiftConfirmation";
      
      private static const PROPERTY_NAME_ERROR_MESSAGE:String = "errorMessages";
      
      private static const PROPERTY_NAME_ERROR_CODE:String = "errorCode";
      
      private static const PROPERTY_NAME_GIFTED_ITEM:String = "giftedItem";
      
      private var _model:IEndOfGameGiftModel;
      
      private var _validator:IGiftListValueObjectFactory;
      
      public function SentGiftForPlayerResponseAction(param1:IEndOfGameGiftModel, param2:IGiftListValueObjectFactory, param3:String, param4:IDecode, param5:String = null)
      {
         this._model = param1;
         this._validator = param2;
         super(param3,param4,param5);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:IEndOfGameGift = null;
         if(this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_ERROR_MESSAGE,Array))
         {
            if(this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_ERROR_CODE,Number))
            {
               _loc2_ = Number(param1[PROPERTY_NAME_ERROR_CODE]);
            }
            _loc3_ = param1[PROPERTY_NAME_ERROR_MESSAGE][0];
            this._model.setEOGGServiceError(_loc2_,_loc3_);
         }
         else if(this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_GIFTED_ITEM,Object))
         {
            if(!this._validator.validateEndOfGameGiftDTO(param1[PROPERTY_NAME_GIFTED_ITEM]))
            {
               this._model.setEOGGServiceError(EndOfGameGiftServiceResponseTypes.DEFAULT_DTO_PARSING_ERROR_ID,EndOfGameGiftServiceResponseTypes.DEFAULT_ASYNC_TIMEOUT_ERROR_MESSAGE);
            }
            else
            {
               _loc4_ = this._validator.parseEndOfGameGift(param1[PROPERTY_NAME_GIFTED_ITEM]);
               this._model.updateGiftSentSuccess(_loc4_);
            }
         }
         super.doDecode(param1);
      }
   }
}

