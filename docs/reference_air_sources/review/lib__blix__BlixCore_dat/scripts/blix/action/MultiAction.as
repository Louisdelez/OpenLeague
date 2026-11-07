package blix.action
{
   public class MultiAction extends BasicAction
   {
      
      private var _actions:Vector.<IAction> = new Vector.<IAction>();
      
      public function MultiAction(param1:Boolean = false)
      {
         super(param1);
      }
      
      public function getActions() : Vector.<IAction>
      {
         return this._actions.slice();
      }
      
      public function setActions(param1:Vector.<IAction>) : void
      {
         var _loc2_:IAction = null;
         this.removeAllActions();
         for each(_loc2_ in param1)
         {
            this.addAction(_loc2_);
         }
      }
      
      public function removeAllActions() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this._actions)
         {
            this.unwatchAction(_loc1_);
         }
         this._actions.length = 0;
      }
      
      public function addAction(param1:IAction) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("action may not be null.");
         }
         this._actions[this._actions.length] = param1;
         this.watchAction(param1);
         if(_hasBeenInvoked)
         {
            param1.invoke();
         }
      }
      
      public function removeAction(param1:IAction) : Boolean
      {
         var _loc2_:int = this._actions.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.unwatchAction(param1);
            this._actions.splice(_loc2_,1);
         }
         return false;
      }
      
      protected function watchAction(param1:IAction) : void
      {
         param1.getAborted().add(this.checkForCompletion);
         param1.getErred().add(this.checkForCompletion);
         param1.getCompleted().add(this.checkForCompletion);
      }
      
      protected function unwatchAction(param1:IAction) : void
      {
         param1.getAborted().remove(this.checkForCompletion);
         param1.getErred().remove(this.checkForCompletion);
         param1.getCompleted().remove(this.checkForCompletion);
      }
      
      override public function invoke() : void
      {
         super.invoke();
         this.checkForCompletion();
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this._actions)
         {
            _loc1_.invoke();
         }
      }
      
      protected function checkForCompletion() : void
      {
         var _loc2_:IAction = null;
         if(!getHasBeenInvoked() || getIsFinished())
         {
            return;
         }
         var _loc1_:uint = 0;
         for each(_loc2_ in this._actions)
         {
            if(!_loc2_.getHasCompleted())
            {
               if(_loc2_.getHasAborted())
               {
                  if(!_loc2_.getIsOptional())
                  {
                     abort();
                     return;
                  }
               }
               else if(_loc2_.getHasErred())
               {
                  if(!_loc2_.getIsOptional())
                  {
                     err(_loc2_.getError());
                     return;
                  }
               }
               else
               {
                  _loc1_++;
               }
            }
         }
         if(_loc1_ == 0)
         {
            complete();
         }
      }
      
      override public function reset() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this._actions)
         {
            _loc1_.reset();
         }
         super.reset();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.removeAllActions();
      }
   }
}

