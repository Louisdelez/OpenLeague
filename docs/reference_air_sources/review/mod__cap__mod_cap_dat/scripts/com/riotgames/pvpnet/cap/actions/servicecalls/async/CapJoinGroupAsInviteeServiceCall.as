package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapJoinGroupAsInviteeServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      private static const METHOD_NAME:String = "joinGroupAsInviteeV1";
      
      protected var _model:CapModel;
      
      public function CapJoinGroupAsInviteeServiceCall(param1:CapModel, param2:ILcdsProxyServiceMessenger, param3:IEncode)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._model = param1;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:CapPlayerSelection = null;
         var _loc3_:Boolean = false;
         for each(_loc2_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            _loc3_ = _loc2_.slotId != CapPlayerSelection.NO_INDEX;
            _loc2_.isInvitedPlayer = _loc3_;
            _loc2_.visible = _loc3_;
         }
         CapModelUtil.refreshCollection(this._model);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_.groupId = this._model.groupId;
         return _loc2_;
      }
   }
}

