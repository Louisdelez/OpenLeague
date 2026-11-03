package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   
   public class CapKickPlayerV1ServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "kickPlayerV1";
      
      private var _player:CapPlayerSelection;
      
      public function CapKickPlayerV1ServiceCall(param1:CapPlayerSelection, param2:ILcdsProxyServiceMessenger, param3:IEncode)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._player = param1;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_.slotId = this._player.slotId;
         return _loc2_;
      }
   }
}

