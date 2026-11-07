package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapPlayerRemovedV3Action extends LcdsProxyMessageAction
   {
      
      public static const SOLO_SEARCHED_FOR_ANOTHER_GROUP_METHOD_NAME:String = "soloSearchedForAnotherGroupV1";
      
      public static const PLAYER_REMOVED_METHOD_NAME:String = "playerRemovedV3";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const REASON_KEY:String = "reason";
      
      public static const KICK_REASON:String = "KICKED";
      
      private static const PENALTY_TIME_PROPERTY:String = "penaltyInSeconds";
      
      protected var _model:CapModel;
      
      public function CapPlayerRemovedV3Action(param1:CapModel, param2:IDecode, param3:String = null)
      {
         super("",param2,param3);
         this._model = param1;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc5_:int = 0;
         var _loc2_:Number = Number(param1[SLOT_ID_KEY]);
         var _loc3_:String = param1[REASON_KEY];
         var _loc4_:CapPlayerSelection = CapModelUtil.getPlayerSelectionSlotById(this._model,_loc2_);
         if(_loc4_ != null)
         {
            if(_loc3_ == KICK_REASON)
            {
               _loc4_.kicked = true;
            }
            this.updatePlayerRemovedState(_loc4_);
            _loc5_ = int(param1[PENALTY_TIME_PROPERTY]);
            if(_loc5_ > 0)
            {
               _loc4_.penaltyTimeInSeconds = _loc5_;
               _loc4_.currentState = CapPlayerSelection.PENALTY_STATE;
            }
            CapModelUtil.refreshCollection(this._model);
         }
      }
      
      protected function updatePlayerRemovedState(param1:CapPlayerSelection) : void
      {
         if(param1.isInvitedPlayer)
         {
            param1.clearValues();
         }
         else
         {
            param1.clearValuesForSolo();
         }
      }
   }
}

