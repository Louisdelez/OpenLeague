package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapIndicateGroupDeclineAsCandidateServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "indicateGroupAcceptanceAsCandidateV1";
      
      private var _model:CapModel;
      
      public function CapIndicateGroupDeclineAsCandidateServiceCall(param1:CapModel, param2:ILcdsProxyServiceMessenger, param3:IEncode)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._model = param1;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_.acceptance = false;
         _loc2_.slotId = this._model.localPlayerSelection.slotId;
         _loc2_.groupId = this._model.groupId;
         return _loc2_;
      }
   }
}

