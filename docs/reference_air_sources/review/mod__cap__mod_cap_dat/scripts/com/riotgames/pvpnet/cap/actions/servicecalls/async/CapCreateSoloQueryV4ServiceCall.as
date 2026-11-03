package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapCreateSoloQueryV4ServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "createSoloQueryV4";
      
      private var _model:CapModel;
      
      private var _actionFactory:ICapActionFactory;
      
      private var _queueId:int;
      
      public function CapCreateSoloQueryV4ServiceCall(param1:CapModel, param2:int, param3:ILcdsProxyServiceMessenger, param4:IEncode, param5:ICapActionFactory)
      {
         this._queueId = param2;
         this._model = param1;
         this._actionFactory = param5;
         super(param3,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param4);
      }
      
      private function trackDemandBoardData() : void
      {
         var _loc1_:IAction = this._actionFactory.getTrackDemandBoardMetricsAction();
         _loc1_.invoke();
      }
      
      override protected function doInvocation() : void
      {
         this._model.creatingSoloQuery = true;
         this.trackDemandBoardData();
         super.doInvocation();
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.championId = this._model.localPlayerSelection.champion.championId;
         if(Boolean(this._model.localPlayerSelection.skin) && Boolean(this._model.localPlayerSelection.skin.isAvailable()))
         {
            param1.skinId = this._model.localPlayerSelection.skin.skinId;
         }
         else
         {
            param1.skinId = 0;
         }
         param1.role = this._model.localPlayerSelection.role.id;
         param1.position = this._model.localPlayerSelection.position.id;
         param1.spell1Id = this._model.localPlayerSelection.spell1.spellId;
         param1.spell2Id = this._model.localPlayerSelection.spell2.spellId;
         param1.queueId = this._queueId;
         return param1;
      }
   }
}

