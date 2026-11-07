package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.util.CapPlayerSelectionUtil;
   
   public class CapReadinessIndicatedV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "readinessIndicatedV1";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const READY_KEY:String = "ready";
      
      private var _model:CapModel;
      
      public function CapReadinessIndicatedV1Action(param1:String, param2:CapModel, param3:IDecode)
      {
         super(METHOD_NAME,param3,param1);
         this._model = param2;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc5_:Boolean = false;
         var _loc2_:Number = Number(param1[SLOT_ID_KEY]);
         var _loc3_:Boolean = Boolean(param1[READY_KEY]);
         var _loc4_:CapPlayerSelection = CapModelUtil.getPlayerSelectionSlotById(this._model,_loc2_);
         if(_loc4_)
         {
            _loc4_.isReady = _loc3_;
            _loc5_ = CapModelUtil.isFullPremadeGroup(this._model);
            _loc4_.currentState = CapPlayerSelectionUtil.determineReadyState(_loc3_,_loc4_,!_loc5_);
         }
      }
   }
}

