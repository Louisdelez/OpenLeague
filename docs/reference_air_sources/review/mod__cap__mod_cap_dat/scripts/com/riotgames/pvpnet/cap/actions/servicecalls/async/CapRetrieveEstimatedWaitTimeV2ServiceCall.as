package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   
   public class CapRetrieveEstimatedWaitTimeV2ServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "retrieveEstimatedWaitTimeV2";
      
      public var champion:Champion;
      
      public var queueId:int;
      
      public var role:CapRole;
      
      public var position:CapPosition;
      
      public function CapRetrieveEstimatedWaitTimeV2ServiceCall(param1:Champion, param2:CapRole, param3:CapPosition, param4:int, param5:ILcdsProxyServiceMessenger, param6:IEncode)
      {
         super(param5,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param6);
         this.champion = param1;
         this.role = param2;
         this.position = param3;
         this.queueId = param4;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.championId = this.champion.championId;
         param1.role = this.role.id;
         param1.position = this.position.id;
         param1.queueId = this.queueId;
         return param1;
      }
   }
}

