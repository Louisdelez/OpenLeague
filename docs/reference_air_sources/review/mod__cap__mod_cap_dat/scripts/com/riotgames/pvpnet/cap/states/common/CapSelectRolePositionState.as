package com.riotgames.pvpnet.cap.states.common
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapSelectRolePositionState extends CapFinishedSelfSpecState
   {
      
      private var localPlayerSelection:CapPlayerSelection;
      
      public function CapSelectRolePositionState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
         var _loc4_:CapModel = param2.getDependency(CapModel);
         this.localPlayerSelection = _loc4_.localPlayerSelection;
      }
      
      private function moveToNextState() : void
      {
         if(Boolean(model.localPlayerSelection.position) && Boolean(model.localPlayerSelection.role))
         {
            changeState(this.getNextStateClass());
         }
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         this.localPlayerSelection.currentState = CapPlayerSelection.CHAMP_SELECTED_STATE;
         this.localPlayerSelection.roleChanged.add(this.moveToNextState);
         this.localPlayerSelection.positionChanged.add(this.moveToNextState);
         this.moveToNextState();
      }
      
      override public function get phase() : String
      {
         return CapPhase.PREMADE;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         this.localPlayerSelection.roleChanged.remove(this.moveToNextState);
         this.localPlayerSelection.positionChanged.remove(this.moveToNextState);
      }
      
      protected function getNextStateClass() : Class
      {
         return null;
      }
   }
}

