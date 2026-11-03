package com.riotgames.pvpnet.cap.states.common
{
   import blix.context.IContext;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.states.CapViewState;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapInMatchmakingState extends CapViewState
   {
      
      public function CapInMatchmakingState(param1:ICapView, param2:IContext, param3:IStateMachine)
      {
         super(param1,param2,param3);
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         lobbyController.lobbyStateChanged.add(this.onLobbyStateChanged);
         model.kickEnabled = false;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         lobbyController.lobbyStateChanged.remove(this.onLobbyStateChanged);
         model.pvpNetHomeButtonVisible = false;
      }
      
      private function onLobbyStateChanged(param1:String, param2:String) : void
      {
         if(param1 == LobbyViewState.CAP_STATE && param2 != LobbyViewState.CAP_STATE)
         {
            model.pvpNetHomeButtonVisible = true;
         }
         else if(param2 == LobbyViewState.CAP_STATE)
         {
            model.pvpNetHomeButtonVisible = false;
         }
      }
      
      override public function get phase() : String
      {
         return CapPhase.MATCHMAKING;
      }
   }
}

