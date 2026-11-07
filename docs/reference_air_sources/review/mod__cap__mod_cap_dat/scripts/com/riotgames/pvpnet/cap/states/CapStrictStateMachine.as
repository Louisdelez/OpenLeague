package com.riotgames.pvpnet.cap.states
{
   import com.riotgames.platform.common.state.IState;
   import com.riotgames.platform.common.state.StateMachine;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class CapStrictStateMachine extends StateMachine
   {
      
      private var stateByClassDictionary:Dictionary = new Dictionary();
      
      public function CapStrictStateMachine()
      {
         super();
      }
      
      public function changeStateByClass(param1:Class) : void
      {
         var _loc2_:IState = this.stateByClassDictionary[param1] as IState;
         if(this.currentState !== _loc2_)
         {
            changeState(_loc2_.name);
         }
      }
      
      override protected function doAddState(param1:IState) : void
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Class = getDefinitionByName(_loc2_) as Class;
         this.stateByClassDictionary[_loc3_] = param1;
         super.doAddState(param1);
      }
   }
}

