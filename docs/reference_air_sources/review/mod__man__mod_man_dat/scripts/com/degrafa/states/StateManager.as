package com.degrafa.states
{
   import com.degrafa.core.IDegrafaObject;
   import com.degrafa.core.IGraphicSkin;
   import com.degrafa.core.collections.GeometryCollection;
   import mx.events.FlexEvent;
   import mx.events.StateChangeEvent;
   
   public class StateManager
   {
      
      private var isSuppressing:Boolean;
      
      private var suppressions:Array = [];
      
      private var requestedCurrentState:String;
      
      private var _currentState:String;
      
      private var stateClient:IDegrafaStateClient;
      
      private var _currentStateChanged:Boolean;
      
      public function StateManager(param1:IDegrafaStateClient)
      {
         super();
         this.stateClient = param1;
      }
      
      private function removeSuppressions() : void
      {
         var _loc1_:* = int(suppressions.length);
         while(_loc1_)
         {
            _loc1_--;
            Object(suppressions[_loc1_]).suppressEventProcessing = false;
         }
      }
      
      public function applyState(param1:String, param2:String) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc3_:State = getState(param1);
         if(param1 == param2)
         {
            return;
         }
         if(_loc3_)
         {
            if(!isSuppressing)
            {
               isSuppressing = _loc4_ = true;
            }
            if(_loc3_.basedOn != param2)
            {
               applyState(_loc3_.basedOn,param2);
            }
            _loc5_ = _loc3_.overrides;
            getSuppressions(_loc5_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               _loc5_[_loc6_].apply(stateClient);
               _loc6_++;
            }
            if(_loc4_)
            {
               removeSuppressions();
               suppressions.length = 0;
               isSuppressing = false;
            }
            _loc3_.dispatchEnterState();
         }
      }
      
      private function getSuppressions(param1:Array) : Array
      {
         var _loc3_:GeometryCollection = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:IDegrafaObject = null;
         if(stateClient is IGraphicSkin && suppressions.indexOf(stateClient) == -1)
         {
            suppressions.push(stateClient);
            Object(stateClient).suppressEventProcessing = true;
            _loc3_ = GeometryCollection(Object(stateClient).geometryCollection);
            suppressions.push(_loc3_);
            _loc3_.suppressEventProcessing = true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = IOverride(param1[_loc2_]).targetRef(stateClient);
            if(_loc4_ is Array)
            {
               for each(_loc5_ in _loc4_)
               {
                  if(_loc5_ is IDegrafaObject)
                  {
                     _loc6_ = getParentObject(IDegrafaObject(_loc5_));
                     if(suppressions.indexOf(_loc6_) == -1)
                     {
                        suppressions.push(_loc6_);
                        IDegrafaObject(_loc6_).suppressEventProcessing = true;
                     }
                  }
               }
            }
            else if(_loc4_ is IDegrafaObject && suppressions.indexOf(_loc4_) == -1)
            {
               suppressions.push(_loc4_);
               IDegrafaObject(_loc4_).suppressEventProcessing = true;
            }
            _loc2_++;
         }
         return suppressions;
      }
      
      public function get currentState() : String
      {
         return _currentStateChanged ? requestedCurrentState : _currentState;
      }
      
      public function setCurrentState(param1:String) : void
      {
         if(param1 != currentState && !(isBaseState(param1) && isBaseState(currentState)))
         {
            requestedCurrentState = param1;
            if(stateClient.isInitialized)
            {
               commitCurrentState();
            }
            else
            {
               _currentStateChanged = true;
            }
         }
      }
      
      public function getState(param1:String) : State
      {
         if(!stateClient.states || isBaseState(param1))
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < stateClient.states.length)
         {
            if(stateClient.states[_loc2_].name == param1)
            {
               return stateClient.states[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function findCommonBaseState(param1:String, param2:String) : String
      {
         var _loc3_:State = getState(param1);
         var _loc4_:State = getState(param2);
         if(!_loc3_ || !_loc4_)
         {
            return "";
         }
         if(isBaseState(_loc3_.basedOn) && isBaseState(_loc4_.basedOn))
         {
            return "";
         }
         var _loc5_:Array = getBaseStates(_loc3_);
         var _loc6_:Array = getBaseStates(_loc4_);
         var _loc7_:String = "";
         while(_loc5_[_loc5_.length - 1] == _loc6_[_loc6_.length - 1])
         {
            _loc7_ = _loc5_.pop();
            _loc6_.pop();
            if(!_loc5_.length || !_loc6_.length)
            {
               break;
            }
         }
         if(Boolean(_loc5_.length) && _loc5_[_loc5_.length - 1] == _loc4_.name)
         {
            _loc7_ = _loc4_.name;
         }
         else if(Boolean(_loc6_.length) && _loc6_[_loc6_.length - 1] == _loc3_.name)
         {
            _loc7_ = _loc3_.name;
         }
         return _loc7_;
      }
      
      public function initializeState(param1:String) : void
      {
         var _loc2_:State = getState(param1);
         while(_loc2_)
         {
            _loc2_ = getState(_loc2_.basedOn);
         }
      }
      
      public function getBaseStates(param1:State) : Array
      {
         var _loc2_:Array = [];
         while(Boolean(param1) && Boolean(param1.basedOn))
         {
            _loc2_.push(param1.basedOn);
            param1 = getState(param1.basedOn);
         }
         return _loc2_;
      }
      
      public function removeState(param1:String, param2:String) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc3_:State = getState(param1);
         if(param1 == param2)
         {
            return;
         }
         if(_loc3_)
         {
            if(!isSuppressing)
            {
               isSuppressing = _loc4_ = true;
            }
            _loc3_.dispatchExitState();
            _loc5_ = _loc3_.overrides;
            getSuppressions(_loc5_);
            _loc6_ = int(_loc5_.length);
            while(_loc6_)
            {
               _loc5_[_loc6_ - 1].remove(stateClient);
               _loc6_--;
            }
            if(_loc3_.basedOn != param2)
            {
               removeState(_loc3_.basedOn,param2);
            }
            if(_loc4_)
            {
               removeSuppressions();
               suppressions.length = 0;
               isSuppressing = false;
            }
         }
      }
      
      public function commitCurrentState() : void
      {
         var _loc2_:StateChangeEvent = null;
         var _loc1_:String = findCommonBaseState(_currentState,requestedCurrentState);
         var _loc3_:String = _currentState ? _currentState : "";
         var _loc4_:State = getState(requestedCurrentState);
         initializeState(requestedCurrentState);
         _loc2_ = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGING);
         _loc2_.oldState = _loc3_;
         _loc2_.newState = requestedCurrentState ? requestedCurrentState : "";
         stateClient.dispatchEvent(_loc2_);
         if(isBaseState(_currentState))
         {
            stateClient.dispatchEvent(new FlexEvent(FlexEvent.EXIT_STATE));
         }
         removeState(_currentState,_loc1_);
         _currentState = requestedCurrentState;
         if(isBaseState(currentState))
         {
            stateClient.dispatchEvent(new FlexEvent(FlexEvent.ENTER_STATE));
         }
         else
         {
            applyState(_currentState,_loc1_);
         }
         _loc2_ = new StateChangeEvent(StateChangeEvent.CURRENT_STATE_CHANGE);
         _loc2_.oldState = _loc3_;
         _loc2_.newState = _currentState ? _currentState : "";
         stateClient.dispatchEvent(_loc2_);
      }
      
      public function set currentState(param1:String) : void
      {
         setCurrentState(param1);
      }
      
      public function isBaseState(param1:String) : Boolean
      {
         return !param1 || param1 == "";
      }
      
      private function getParentObject(param1:IDegrafaObject) : IDegrafaObject
      {
         var _loc2_:IDegrafaObject = param1;
         while(_loc2_.parent)
         {
            _loc2_ = _loc2_.parent;
         }
         return _loc2_;
      }
   }
}

