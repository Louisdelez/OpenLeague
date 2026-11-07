package com.riotgames.platform.common.state
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   
   public interface IStateMachine extends IDestructible
   {
      
      function set currentState(param1:IState) : void;
      
      function changeState(param1:String) : void;
      
      function addState(param1:IState) : void;
      
      function get currentState() : IState;
      
      function getStateChanged() : ISignal;
      
      function removeState(param1:String) : IState;
      
      function hasState(param1:IState) : Boolean;
      
      function onUpdate() : void;
   }
}

