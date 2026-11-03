package com.riotgames.platform.common.state
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.error.AbstractError;
   
   public class BaseStateMachine implements IStateMachine
   {
      
      private var _stateChanged:Signal = new Signal();
      
      private var _currentState:IState = null;
      
      public function BaseStateMachine()
      {
         super();
      }
      
      public function changeState(param1:String) : void
      {
         var _loc2_:IState = this.getState(param1);
         if(_loc2_ == null)
         {
            return;
         }
         this.currentState = _loc2_;
      }
      
      public function destroy() : void
      {
         this.doDestroy();
      }
      
      public function onUpdate() : void
      {
         if(this._currentState != null)
         {
            this._currentState.onUpdate();
         }
      }
      
      public function hasState(param1:IState) : Boolean
      {
         return param1 != null ? this.getState(param1.name) != null : false;
      }
      
      public function get currentState() : IState
      {
         return this._currentState;
      }
      
      public function getStateChanged() : ISignal
      {
         return this._stateChanged;
      }
      
      [Abstract]
      protected function doAddState(param1:IState) : void
      {
         throw new AbstractError();
      }
      
      [Abstract]
      protected function getState(param1:String) : IState
      {
         throw new AbstractError();
      }
      
      [Abstract]
      protected function doRemoveState(param1:String) : IState
      {
         throw new AbstractError();
      }
      
      public function removeState(param1:String) : IState
      {
         return this.doRemoveState(param1);
      }
      
      [Abstract]
      protected function doDestroy() : void
      {
         throw new AbstractError();
      }
      
      public function set currentState(param1:IState) : void
      {
         if(!this.hasState(param1))
         {
            throw new Error("Cannot set state. The supplied state is undefined.");
         }
         this.transitionState(this.currentState,param1);
      }
      
      protected function transitionState(param1:IState, param2:IState) : void
      {
         if(param1 != null)
         {
            param1.onExit();
         }
         this._currentState = param2;
         if(this._currentState != null)
         {
            this._currentState.onEnter();
         }
         this._stateChanged.dispatch(param1,param2);
      }
      
      public function addState(param1:IState) : void
      {
         this.doAddState(param1);
      }
   }
}

