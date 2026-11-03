package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.util.LcdsProxyMessageActionDataUtil;
   
   public class CapCandidateDeclinedV2Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "candidateDeclinedV2";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      private static const PENALTY_TIME_PROPERTY:String = "penaltyInSeconds";
      
      private var _model:CapModel;
      
      public function CapCandidateDeclinedV2Action(param1:String, param2:CapModel, param3:IDecode)
      {
         super("",param3,param1);
         this._model = param2;
      }
      
      protected function updateDeclinedPlayer(param1:CapPlayerSelection) : void
      {
         param1.clearValuesForSolo();
         param1.currentState = CapPlayerSelection.SEARCHING_STATE;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc4_:int = 0;
         LcdsProxyMessageActionDataUtil.validate(param1,[SLOT_ID_KEY]);
         var _loc2_:Number = Number(param1[SLOT_ID_KEY]);
         var _loc3_:CapPlayerSelection = CapModelUtil.getPlayerSelectionSlotById(this._model,_loc2_);
         if(_loc3_ != null)
         {
            this.updateDeclinedPlayer(_loc3_);
            _loc4_ = int(param1[PENALTY_TIME_PROPERTY]);
            if(_loc4_ > 0)
            {
               _loc3_.penaltyTimeInSeconds = _loc4_;
               _loc3_.currentState = CapPlayerSelection.PENALTY_STATE;
            }
         }
      }
   }
}

