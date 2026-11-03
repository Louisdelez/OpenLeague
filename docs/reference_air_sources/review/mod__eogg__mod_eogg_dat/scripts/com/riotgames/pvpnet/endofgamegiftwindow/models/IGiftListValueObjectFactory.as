package com.riotgames.pvpnet.endofgamegiftwindow.models
{
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   
   public interface IGiftListValueObjectFactory
   {
      
      function validatePropertyNameAndType(param1:Object, param2:String, param3:Class) : Boolean;
      
      function validateEndOfGameGiftDTO(param1:Object) : Boolean;
      
      function validateSentGiftDTO(param1:Object) : Boolean;
      
      function parseEndOfGameGift(param1:Object) : IEndOfGameGift;
      
      function parseSentGift(param1:Object) : IEndOfGameGift;
   }
}

