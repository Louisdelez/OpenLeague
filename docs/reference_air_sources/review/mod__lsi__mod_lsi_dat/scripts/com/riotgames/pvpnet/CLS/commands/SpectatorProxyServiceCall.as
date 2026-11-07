package com.riotgames.pvpnet.CLS.commands
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class SpectatorProxyServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      private var _jsonDecoder:IDecode;
      
      public function SpectatorProxyServiceCall(param1:ILcdsProxyServiceMessenger, param2:String, param3:IEncode, param4:IDecode)
      {
         this._jsonDecoder = param4;
         super(param1,ClientNotificationProxyServiceName.SPECTATOR,param2,param3);
      }
      
      override protected function decodePayload(param1:String = null) : Object
      {
         return this._jsonDecoder.decode(param1);
      }
   }
}

