package com.riotgames.pvpnet.endofgamegiftwindow.actions.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.pvpnet.endofgamegiftwindow.services.EndOfGameGiftService;
   
   public class LoadGiftsForPlayerServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "getGiftsForUser";
      
      private var _serviceCallPayload:Object;
      
      public function LoadGiftsForPlayerServiceCall(param1:String, param2:ILcdsProxyServiceMessenger, param3:IEncode = null)
      {
         super(param2,EndOfGameGiftService.DESTINATION_SERVICE_NAME,METHOD_NAME,param3);
         if(param1)
         {
            this._serviceCallPayload = JSON.parse(param1);
         }
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         return this._serviceCallPayload;
      }
   }
}

