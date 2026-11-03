package com.riotgames.pvpnet.cap.actions.responses.captain
{
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.actions.responses.CapPlayerRemovedV3Action;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapPlayerSelectionUtil;
   
   public class CapPlayerRemovedAsCaptainV3Action extends CapPlayerRemovedV3Action
   {
      
      public function CapPlayerRemovedAsCaptainV3Action(param1:CapModel, param2:IDecode, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function updatePlayerRemovedState(param1:CapPlayerSelection) : void
      {
         var _loc3_:Number = NaN;
         if(CapPlayerSelectionUtil.isCaptainSettingUp(param1))
         {
            return;
         }
         var _loc2_:Boolean = !param1.role && !param1.position || param1.isInvitedPlayer;
         if(_loc2_)
         {
            _loc3_ = param1.slotId;
         }
         super.updatePlayerRemovedState(param1);
         if(_loc2_)
         {
            param1.slotId = _loc3_;
         }
      }
   }
}

