package blix.components.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class StateModel
   {
      
      protected var _currentStateChanged:Signal = new Signal();
      
      protected var _currentState:String;
      
      public function StateModel(param1:String)
      {
         super();
         this._currentState = param1;
      }
      
      public function getCurrentStateChanged() : ISignal
      {
         return this._currentStateChanged;
      }
      
      public function getCurrentState() : String
      {
         return this._currentState;
      }
      
      public function setCurrentState(param1:String) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         var _loc2_:String = this._currentState;
         this._currentState = param1;
         this._currentStateChanged.dispatch(this,_loc2_,param1);
      }
   }
}

