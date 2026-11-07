package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.CapRole;
   
   public class CapSelectRoleServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "specifyRoleV2";
      
      private var _slotId:int;
      
      private var _role:CapRole;
      
      public function CapSelectRoleServiceCall(param1:CapRole, param2:ILcdsProxyServiceMessenger, param3:IEncode, param4:int = -1)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._role = param1;
         this._slotId = param4;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.role = this._role.id;
         param1.slotId = this._slotId;
         return param1;
      }
   }
}

