package com.riotgames.pvpnet.cap.actions.responses.solo
{
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.actions.responses.CapPlayerRemovedV3Action;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapPlayerRemovedAsSoloV3Action extends CapPlayerRemovedV3Action
   {
      
      public function CapPlayerRemovedAsSoloV3Action(param1:CapModel, param2:IDecode, param3:String = null)
      {
         super(param1,param2,param3);
      }
      
      override protected function updatePlayerRemovedState(param1:CapPlayerSelection) : void
      {
         if(!param1.isLocalPlayer)
         {
            super.updatePlayerRemovedState(param1);
         }
      }
   }
}

