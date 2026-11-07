package com.riotgames.platform.common.state
{
   public class NonLinearState extends State
   {
      
      private var _stateMachine:IStateMachine;
      
      public function NonLinearState(param1:IStateMachine, param2:String = null)
      {
         super(param2);
         this._stateMachine = param1;
      }
      
      protected function get stateMachine() : IStateMachine
      {
         return this._stateMachine;
      }
   }
}

