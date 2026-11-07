package com.riotgames.platform.common.state
{
   import flash.utils.Dictionary;
   
   public class StateMachine extends BaseStateMachine implements IStateMachine
   {
      
      private var _states:Dictionary = new Dictionary();
      
      public function StateMachine()
      {
         super();
      }
      
      override protected function doRemoveState(param1:String) : IState
      {
         var _loc2_:IState = null;
         if(this._states[param1] != null)
         {
            _loc2_ = this._states[param1];
            delete this._states[param1];
         }
         return _loc2_;
      }
      
      protected function get states() : Dictionary
      {
         return this._states;
      }
      
      override protected function getState(param1:String) : IState
      {
         return this._states[param1];
      }
      
      override protected function doAddState(param1:IState) : void
      {
         if(!param1 || !param1.name)
         {
            return;
         }
         if(this._states[param1.name] == null)
         {
            this._states[param1.name] = param1;
            return;
         }
         throw new Error("State already exists for name: " + param1.name);
      }
      
      override protected function doDestroy() : void
      {
         var _loc1_:IState = null;
         for each(_loc1_ in this._states)
         {
            _loc1_.destroy();
         }
      }
   }
}

