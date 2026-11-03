package com.riotgames.pvpnet.cap.states.common
{
   import blix.context.Context;
   import com.riotgames.platform.common.state.IStateMachine;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.observable.IObservable;
   import com.riotgames.pvpnet.cap.views.ICapView;
   
   public class CapSelectSpellsState extends CapFinishedSelfSpecState
   {
      
      protected var _readyObserver:IObservable;
      
      protected var _localPlayerSelection:CapPlayerSelection;
      
      public function CapSelectSpellsState(param1:ICapView, param2:Context, param3:IStateMachine)
      {
         super(param1,param2,param3);
         var _loc4_:CapModel = param2.getDependency(CapModel);
         this._localPlayerSelection = _loc4_.localPlayerSelection;
      }
      
      protected function getReadyObserver() : IObservable
      {
         throw new Error("Abstract");
      }
      
      protected function onReadyChanged() : void
      {
         throw new Error("Abstract");
      }
      
      override public function onEnter() : void
      {
         super.onEnter();
         this._localPlayerSelection.currentState = CapPlayerSelection.ROLE_POSITION_SELECTED_STATE;
         this._readyObserver = this.getReadyObserver();
         if(this._readyObserver)
         {
            this._readyObserver.occurred.add(this.onReadyChanged);
            this._readyObserver.refresh();
            this.onReadyChanged();
         }
      }
      
      override public function get phase() : String
      {
         return CapPhase.PREMADE;
      }
      
      override public function onExit() : void
      {
         super.onExit();
         if(this._readyObserver != null)
         {
            this._readyObserver.occurred.remove(this.onReadyChanged);
         }
      }
   }
}

