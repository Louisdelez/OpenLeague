package com.riotgames.pvpnet.cap.states.common
{
   import blix.context.IContext;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapFinishedSelfSpecState extends CapViewState
   {
      
      public function CapFinishedSelfSpecState(param1:ICapView, param2:IContext, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override public function get phase() : String
      {
         return CapPhase.PREMADE;
      }
   }
}

