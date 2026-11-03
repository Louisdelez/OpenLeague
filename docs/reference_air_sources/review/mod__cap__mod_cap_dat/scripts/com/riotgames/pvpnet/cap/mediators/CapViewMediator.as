package com.riotgames.pvpnet.cap.mediators
{
   import blix.IDestructible;
   import blix.context.Context;
   import com.riotgames.platform.common.state.IState;
   import com.riotgames.pvpnet.cap.context.CapContext;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.states.CapStrictStateMachine;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainFullGroupState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainInMatchmakingState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainInitialState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainSearchingForSolosState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainSelectRolePositionState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainSelectSpellsState;
   import com.riotgames.pvpnet.cap.states.captain.CapCaptainSpecSolosState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeFullGroupState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeInMatchmakingState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeInitialState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSearchingForSolosState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSelectRolePositionState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSelectSpellsState;
   import com.riotgames.pvpnet.cap.states.invitee.CapInviteeSpecSolosState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloFinishedSelfSpecState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloFullGroupState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloGroupFoundState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloInMatchmakingState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloInitialState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloReadyToFindGroupState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloSearchingForGroupState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloSelectRolePositionState;
   import com.riotgames.pvpnet.cap.states.solo.CapSoloSelectSpellsState;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.views.CapView;
   
   public class CapViewMediator implements IDestructible
   {
      
      private var _view:CapView;
      
      private var _context:Context;
      
      private var _stateMachine:CapStrictStateMachine;
      
      private var _model:CapModel;
      
      public function CapViewMediator(param1:CapContext)
      {
         super();
         this._context = param1;
      }
      
      public function changeStateByClass(param1:Class) : void
      {
         this._stateMachine.changeStateByClass(param1);
      }
      
      private function setupInviteeFlow() : void
      {
         var _loc1_:IState = new CapInviteeInitialState(this._view,this._context,this._stateMachine);
         this._stateMachine.addState(_loc1_);
         this._stateMachine.addState(new CapInviteeSelectRolePositionState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeSelectSpellsState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeSpecSolosState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeSearchingForSolosState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeFinishedSelfSpecState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeFullGroupState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapInviteeInMatchmakingState(this._view,this._context,this._stateMachine));
         this._stateMachine.currentState = _loc1_;
      }
      
      private function setupSoloFlow() : void
      {
         var _loc1_:IState = new CapSoloInitialState(this._view,this._context,this._stateMachine);
         this._stateMachine.addState(_loc1_);
         this._stateMachine.addState(new CapSoloSelectRolePositionState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloSelectSpellsState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloReadyToFindGroupState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloSearchingForGroupState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloGroupFoundState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloFinishedSelfSpecState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloFullGroupState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapSoloInMatchmakingState(this._view,this._context,this._stateMachine));
         this._stateMachine.currentState = _loc1_;
      }
      
      public function initialize(param1:CapView) : void
      {
         this._view = param1;
         this._model = this._context.getDependency(CapModel);
         this._stateMachine = new CapStrictStateMachine();
         if(CapFlowUtil.isCaptain(this._model))
         {
            this.setupCaptainFlow();
         }
         else if(CapFlowUtil.isInvitee(this._model))
         {
            this.setupInviteeFlow();
         }
         else
         {
            if(!CapFlowUtil.isSolo(this._model))
            {
               throw new Error("Unexpected flow - unable to proceed");
            }
            this.setupSoloFlow();
         }
      }
      
      public function get currentState() : CapViewState
      {
         return this._stateMachine.currentState as CapViewState;
      }
      
      public function destroy() : void
      {
         if(this._stateMachine != null)
         {
            this._stateMachine.destroy();
         }
         this._stateMachine = null;
         this._view = null;
         this._context = null;
      }
      
      private function setupCaptainFlow() : void
      {
         var _loc1_:IState = new CapCaptainInitialState(this._view,this._context,this._stateMachine);
         this._stateMachine.addState(_loc1_);
         this._stateMachine.addState(new CapCaptainSelectRolePositionState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainSelectSpellsState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainFinishedSelfSpecState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainSpecSolosState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainFullGroupState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainInMatchmakingState(this._view,this._context,this._stateMachine));
         this._stateMachine.addState(new CapCaptainSearchingForSolosState(this._view,this._context,this._stateMachine));
         this._stateMachine.currentState = _loc1_;
      }
   }
}

