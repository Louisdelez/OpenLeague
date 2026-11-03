package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IEndOfGameGiftModel;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IGiftListValueObjectFactory;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.AvailableGiftCategory;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftServiceResponseTypes;
   
   public class LoadGiftsForPlayerResponseAction extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "giftListForUser";
      
      private static const PROPERTY_NAME_ERROR_MESSAGE:String = "errorMessages";
      
      private static const PROPERTY_NAME_ERROR_CODE:String = "errorCode";
      
      private static const PROPERTY_NAME_GIFT_LIST:String = "giftList";
      
      private static const PROPERTY_NAME_GROUP_NAME:String = "group";
      
      private static const PROPERTY_NAME_ITEM_LIST:String = "items";
      
      private var _model:IEndOfGameGiftModel;
      
      private var _validator:IGiftListValueObjectFactory;
      
      public function LoadGiftsForPlayerResponseAction(param1:IEndOfGameGiftModel, param2:IGiftListValueObjectFactory, param3:String, param4:IDecode, param5:String = null)
      {
         super(param3,param4,param5);
         this._model = param1;
         this._validator = param2;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:Vector.<AvailableGiftCategory> = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:AvailableGiftCategory = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Object = null;
         if(this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_ERROR_MESSAGE,Array))
         {
            if(this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_ERROR_CODE,Number))
            {
               _loc2_ = Number(param1[PROPERTY_NAME_ERROR_CODE]);
            }
            _loc3_ = param1[PROPERTY_NAME_ERROR_MESSAGE][0];
            this._model.setEOGGServiceError(_loc2_,_loc3_);
         }
         else
         {
            if(!this._validator.validatePropertyNameAndType(param1,PROPERTY_NAME_GIFT_LIST,Array))
            {
               this._model.setEOGGServiceError(EndOfGameGiftServiceResponseTypes.DEFAULT_DTO_PARSING_ERROR_ID,EndOfGameGiftServiceResponseTypes.DEFAULT_ASYNC_TIMEOUT_ERROR_MESSAGE);
               super.doDecode(param1);
               return;
            }
            _loc4_ = new Vector.<AvailableGiftCategory>();
            _loc5_ = param1[PROPERTY_NAME_GIFT_LIST];
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc7_ = _loc5_[_loc6_];
               if(!(!this._validator.validatePropertyNameAndType(_loc7_,PROPERTY_NAME_GROUP_NAME,String) && !this._validator.validatePropertyNameAndType(_loc7_,PROPERTY_NAME_ITEM_LIST,Array)))
               {
                  _loc8_ = _loc7_[PROPERTY_NAME_GROUP_NAME];
                  _loc9_ = this._model.getBucketLabel(_loc8_);
                  _loc10_ = new AvailableGiftCategory(_loc9_,_loc8_,true);
                  _loc11_ = _loc7_[PROPERTY_NAME_ITEM_LIST];
                  _loc12_ = 0;
                  while(_loc12_ < _loc11_.length)
                  {
                     _loc13_ = _loc11_[_loc12_];
                     if(this._validator.validateEndOfGameGiftDTO(_loc13_))
                     {
                        _loc10_.addGift(this._validator.parseEndOfGameGift(_loc13_));
                     }
                     _loc12_++;
                  }
                  _loc4_.push(_loc10_);
               }
               _loc6_++;
            }
            this._model.updateGiftList(_loc4_);
         }
         super.doDecode(param1);
      }
   }
}

