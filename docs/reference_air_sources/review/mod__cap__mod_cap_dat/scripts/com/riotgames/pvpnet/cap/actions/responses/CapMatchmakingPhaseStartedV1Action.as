package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapMatchmakingPhaseStartedV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "matchmakingPhaseStartedV1";
      
      private var _model:CapModel;
      
      public function CapMatchmakingPhaseStartedV1Action(param1:CapModel, param2:IDecode, param3:String = null)
      {
         super(METHOD_NAME,param2,param3);
         this._model = param1;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         this._model.inMatchmakingQueue = true;
         var _loc2_:CapPlayerSelection = CapModelUtil.getCaptain(this._model);
         if(_loc2_)
         {
            _loc2_.isReady = true;
            _loc2_.currentState = CapPlayerSelection.READY_STATE;
         }
      }
   }
}

