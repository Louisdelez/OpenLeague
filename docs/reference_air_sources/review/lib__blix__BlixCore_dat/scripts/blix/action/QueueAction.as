package blix.action
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class QueueAction extends BasicAction
   {
      
      public var forgetActions:Boolean = false;
      
      public var autoInvoke:Boolean = false;
      
      public var simultaneous:uint = 1;
      
      private var _next:Signal = new Signal();
      
      private var _actions:Vector.<IAction>;
      
      private var _currentActionIndex:int = 0;
      
      private var _currentActionCount:int = 0;
      
      public function QueueAction(param1:Boolean = false)
      {
         super(param1);
         this._actions = new Vector.<IAction>();
      }
      
      public function getNext() : ISignal
      {
         return this._next;
      }
      
      public function addAction(param1:IAction) : void
      {
         this.addActionAt(param1,this._actions.length);
      }
      
      public function addActionAt(param1:IAction, param2:int) : void
      {
         if(this.forgetActions && param1.getIsFinished())
         {
            return;
         }
         this.removeAction(param1);
         this.watchAction(param1);
         this._actions.splice(param2,0,param1);
         if(param1.getHasBeenInvoked() && !param1.getIsFinished())
         {
            ++this._currentActionCount;
         }
         if(this.autoInvoke)
         {
            if(getHasBeenInvoked())
            {
               this.fillActionBuffer();
            }
            else
            {
               invoke();
            }
         }
         else if(getHasBeenInvoked() && !getHasCompleted())
         {
            this.fillActionBuffer();
         }
      }
      
      public function removeAction(param1:IAction) : Boolean
      {
         return this.removeActionAt(this._actions.indexOf(param1));
      }
      
      public function removeActionAt(param1:int) : Boolean
      {
         if(param1 > this._actions.length - 1 || param1 < 0)
         {
            return false;
         }
         var _loc2_:IAction = this._actions[param1];
         if(_loc2_.getHasBeenInvoked() && !_loc2_.getIsFinished())
         {
            --this._currentActionCount;
         }
         if(param1 < this._currentActionIndex)
         {
            --this._currentActionIndex;
         }
         this._actions.splice(param1,1);
         this.unwatchAction(_loc2_);
         return true;
      }
      
      public function removeAllActions() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this._actions)
         {
            this.unwatchAction(_loc1_);
         }
         this._actions.length = 0;
         this._currentActionIndex = 0;
      }
      
      protected function watchAction(param1:IAction) : void
      {
         param1.getInvoked().add(this.actionInvokedHandler);
         param1.getAborted().add(this.actionAbortedHandler);
         param1.getErred().add(this.actionErredHandler);
         param1.getCompleted().add(this.actionCompletedHandler);
      }
      
      protected function unwatchAction(param1:IAction) : void
      {
         param1.getInvoked().remove(this.actionInvokedHandler);
         param1.getAborted().remove(this.actionAbortedHandler);
         param1.getErred().remove(this.actionErredHandler);
         param1.getCompleted().remove(this.actionCompletedHandler);
      }
      
      protected function actionInvokedHandler(param1:IAction) : void
      {
         ++this._currentActionCount;
      }
      
      protected function actionAbortedHandler(param1:IAction) : void
      {
         if(!param1.getIsOptional())
         {
            abort();
         }
         this.actionFinishedHandler(param1);
      }
      
      protected function actionErredHandler(param1:IAction) : void
      {
         if(!param1.getIsOptional())
         {
            err(param1.getError());
         }
         this.actionFinishedHandler(param1);
      }
      
      protected function actionCompletedHandler(param1:IAction) : void
      {
         this.actionFinishedHandler(param1);
      }
      
      private function actionFinishedHandler(param1:IAction) : void
      {
         if(param1.getHasBeenInvoked())
         {
            --this._currentActionCount;
         }
         if(this.forgetActions)
         {
            this.removeAction(param1);
         }
         if(getHasBeenInvoked() || getIsInvoking())
         {
            this.fillActionBuffer();
         }
      }
      
      protected function fillActionBuffer() : void
      {
         var _loc1_:IAction = null;
         if(getHasAborted() || getHasErred())
         {
            return;
         }
         if(!this._currentActionCount && this._currentActionIndex >= this._actions.length)
         {
            complete();
            return;
         }
         while(this._currentActionCount < this.simultaneous && this._currentActionIndex < this._actions.length)
         {
            _loc1_ = this._actions[this._currentActionIndex];
            ++this._currentActionIndex;
            _hasCompleted = false;
            this._next.dispatch(this,_loc1_);
            _loc1_.invoke();
         }
      }
      
      public function getCurrentActionCount() : int
      {
         return this._currentActionCount;
      }
      
      public function getCurrentActionIndex() : int
      {
         return this._currentActionIndex;
      }
      
      public function getLength() : uint
      {
         return this._actions.length;
      }
      
      public function getActions() : Vector.<IAction>
      {
         return this._actions.slice();
      }
      
      public function getActionAt(param1:int) : IAction
      {
         if(param1 < 0 || param1 >= this._actions.length)
         {
            return null;
         }
         return this._actions[param1];
      }
      
      override public function reset() : void
      {
         var _loc1_:IAction = null;
         super.reset();
         for each(_loc1_ in this._actions)
         {
            _loc1_.reset();
         }
         this._currentActionCount = 0;
         this._currentActionIndex = 0;
      }
      
      override protected function doInvocation() : void
      {
         this._currentActionIndex = 0;
         this.fillActionBuffer();
      }
      
      override protected function onAborted() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this._actions)
         {
            if(_loc1_.getHasBeenInvoked() && !_loc1_.getIsFinished())
            {
               _loc1_.abort();
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeAllActions();
      }
   }
}

