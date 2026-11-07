package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.actions.ICapFaultHandler;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.Fault;
   
   public class CapStartMatchmakingPhaseServiceCall extends AsyncLcdsProxyServiceCall implements ICapFaultHandler
   {
      
      public static const METHOD_NAME:String = "startMatchmakingPhaseV1";
      
      private var _model:CapModel;
      
      public function CapStartMatchmakingPhaseServiceCall(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:CapModel)
      {
         this._model = param3;
         super(param1,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param2);
      }
      
      override public function invoke() : void
      {
         this._model.isInMatchmaking = true;
         super.invoke();
      }
      
      public function handleFault(param1:Fault) : void
      {
         this._model.isInMatchmaking = false;
         var _loc2_:AlertAction = new AlertAction("Error","**" + param1.faultCode);
         _loc2_.add();
      }
   }
}

