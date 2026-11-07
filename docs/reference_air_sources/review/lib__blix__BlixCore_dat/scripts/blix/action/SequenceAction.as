package blix.action
{
   import blix.signals.ISignal;
   import flash.utils.Dictionary;
   
   public class SequenceAction extends BasicAction
   {
      
      private var actionMap:Dictionary;
      
      private var currentMultiAction:MultiAction;
      
      private var queue:QueueAction;
      
      public function SequenceAction(param1:Boolean = false)
      {
         var isOptional:Boolean = param1;
         this.actionMap = new Dictionary();
         this.queue = new QueueAction();
         super(isOptional);
         this.queue.getAborted().add(this.abort);
         this.queue.getErred().add(function():void
         {
            err(queue.getError());
         });
         this.queue.getCompleted().add(complete);
      }
      
      public function getNext() : ISignal
      {
         return this.queue.getNext();
      }
      
      public function getActions() : Vector.<IAction>
      {
         return this.queue.getActions();
      }
      
      protected function createAction(param1:Function, param2:Array, param3:Boolean, param4:Boolean) : CallAction
      {
         if(param1 in this.actionMap)
         {
            throw new Error("There is already an action with the given function. This is currently not supported.");
         }
         var _loc5_:CallAction = new CallAction(param1,param2,param3,param4);
         this.actionMap[param1] = _loc5_;
         return _loc5_;
      }
      
      public function thenCall(param1:Function, param2:Array = null, param3:Boolean = false, param4:Boolean = false) : CallAction
      {
         var _loc5_:CallAction = this.createAction(param1,param2,param3,param4);
         this.then(_loc5_);
         return _loc5_;
      }
      
      public function andCall(param1:Function, param2:Array = null, param3:Boolean = false, param4:Boolean = false) : CallAction
      {
         var _loc5_:CallAction = this.createAction(param1,param2,param3,param4);
         this.and(_loc5_);
         return _loc5_;
      }
      
      public function then(param1:IAction) : void
      {
         this.currentMultiAction = new MultiAction();
         this.currentMultiAction.addAction(param1);
         this.queue.addAction(this.currentMultiAction);
      }
      
      public function and(param1:IAction) : void
      {
         if(this.currentMultiAction == null)
         {
            this.then(param1);
         }
         else
         {
            this.currentMultiAction.addAction(param1);
         }
      }
      
      public function completeFunction(param1:Function) : Boolean
      {
         var _loc2_:CallAction = null;
         if(param1 in this.actionMap)
         {
            _loc2_ = this.actionMap[param1];
            _loc2_.complete();
            delete this.actionMap[param1];
            return true;
         }
         return false;
      }
      
      public function errFunction(param1:Function, param2:Error) : Boolean
      {
         var _loc3_:CallAction = null;
         if(param1 in this.actionMap)
         {
            _loc3_ = this.actionMap[param1];
            _loc3_.err(param2);
            delete this.actionMap[param1];
            return true;
         }
         return false;
      }
      
      override protected function doInvocation() : void
      {
         this.queue.invoke();
      }
      
      override public function abort() : void
      {
         this.queue.abort();
         super.abort();
      }
      
      override public function reset() : void
      {
         super.reset();
         this.queue.reset();
         this.currentMultiAction = null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.actionMap = null;
         if(this.currentMultiAction != null)
         {
            this.currentMultiAction.destroy();
            this.currentMultiAction = null;
         }
         this.queue.destroy();
      }
   }
}

