package blix.action
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class BasicAction implements IAction, IDestructible
   {
      
      public var singleInvocation:Boolean = true;
      
      protected var _isOptional:Boolean;
      
      protected var _erred:Signal = new Signal();
      
      protected var _error:Error;
      
      protected var _invoking:Signal = new Signal();
      
      protected var _invoked:Signal = new Signal();
      
      protected var _isInvoking:Boolean;
      
      protected var _hasBeenInvoked:Boolean = false;
      
      protected var _completed:Signal = new Signal();
      
      protected var _hasCompleted:Boolean = false;
      
      protected var _aborted:Signal = new Signal();
      
      protected var _hasAborted:Boolean;
      
      public function BasicAction(param1:Boolean)
      {
         super();
         this._isOptional = param1;
      }
      
      public function getIsOptional() : Boolean
      {
         return this._isOptional;
      }
      
      public function setIsOptional(param1:Boolean) : void
      {
         this._isOptional = param1;
      }
      
      public function getErred() : ISignal
      {
         return this._erred;
      }
      
      public function getHasErred() : Boolean
      {
         return this._error != null;
      }
      
      public function getError() : Error
      {
         return this._error;
      }
      
      public function getInvoking() : ISignal
      {
         return this._invoking;
      }
      
      public function getIsInvoking() : Boolean
      {
         return this._isInvoking;
      }
      
      public function getInvoked() : ISignal
      {
         return this._invoked;
      }
      
      public function getHasBeenInvoked() : Boolean
      {
         return this._hasBeenInvoked;
      }
      
      public function getCompleted() : ISignal
      {
         return this._completed;
      }
      
      public function getHasCompleted() : Boolean
      {
         return this._hasCompleted;
      }
      
      public function getAborted() : ISignal
      {
         return this._aborted;
      }
      
      public function getHasAborted() : Boolean
      {
         return this._hasAborted;
      }
      
      public function invoke() : void
      {
         if(this.singleInvocation && (this._hasAborted || this._error != null || this._isInvoking || this._hasBeenInvoked))
         {
            return;
         }
         this._error = null;
         this._hasAborted = false;
         this._hasCompleted = false;
         this._isInvoking = true;
         this._invoking.dispatch(this);
         this.doInvocation();
         this._isInvoking = false;
         this._hasBeenInvoked = true;
         this._invoked.dispatch(this);
      }
      
      [Abstract]
      protected function doInvocation() : void
      {
      }
      
      public function complete() : void
      {
         if(this.getIsFinished())
         {
            return;
         }
         this._hasCompleted = true;
         this.onCompleted();
         this._completed.dispatch(this);
      }
      
      [Abstract]
      protected function onCompleted() : void
      {
      }
      
      public function err(param1:Error) : void
      {
         if(this.getIsFinished())
         {
            return;
         }
         this._error = param1 || new Error();
         this.onErred(param1);
         this._erred.dispatch(this);
      }
      
      [Abstract]
      protected function onErred(param1:Error) : void
      {
      }
      
      public function abort() : void
      {
         if(this.getIsFinished())
         {
            return;
         }
         this._hasAborted = true;
         this.onAborted();
         this._aborted.dispatch(this);
      }
      
      [Abstract]
      protected function onAborted() : void
      {
      }
      
      public function reset() : void
      {
         this._error = null;
         this._hasAborted = false;
         this._hasCompleted = false;
         this._hasBeenInvoked = false;
         this._isInvoking = false;
      }
      
      public function getIsFinished() : Boolean
      {
         return this._hasCompleted || this._hasAborted || this._error != null;
      }
      
      public function destroy() : void
      {
         this._completed.removeAll();
         this._erred.removeAll();
         this._invoked.removeAll();
         this._invoking.removeAll();
         this._aborted.removeAll();
      }
   }
}

