package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class CapUpdateToSearchForCandidatesPhaseV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "groupBuildingPhaseStartedV1";
      
      protected var _model:CapModel;
      
      public function CapUpdateToSearchForCandidatesPhaseV1Action(param1:CapModel)
      {
         super(METHOD_NAME,null,null);
         this._model = param1;
      }
      
      override public function invoke() : void
      {
         super.invoke();
         this.displaySearchingSpinners();
      }
      
      private function displaySearchingSpinners() : void
      {
         var _loc1_:CapPlayerSelection = null;
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            if(!_loc1_.isPopulated)
            {
               _loc1_.currentState = CapPlayerSelection.SEARCHING_STATE;
            }
         }
      }
   }
}

