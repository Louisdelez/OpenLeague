package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.actions.ICapFaultHandler;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.rpc.Fault;
   
   public class CapSelectChampionServiceCall extends AsyncLcdsProxyServiceCall implements ICapFaultHandler
   {
      
      public static const METHOD_NAME:String = "pickChampionV2";
      
      private var _champion:Champion;
      
      private var _model:CapModel;
      
      public function CapSelectChampionServiceCall(param1:Champion, param2:ILcdsProxyServiceMessenger, param3:IEncode, param4:CapModel)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._champion = param1;
         this._model = param4;
      }
      
      public function handleFault(param1:Fault) : void
      {
         this._model.pendingChampionSelection = null;
         var _loc2_:AlertAction = new AlertAction("Error","**" + param1.faultCode);
         _loc2_.add();
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.championId = this._champion.championId;
         return param1;
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      override public function invoke() : void
      {
         this._model.pendingChampionSelection = this._champion;
         super.invoke();
      }
   }
}

