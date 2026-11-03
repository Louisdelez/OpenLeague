package com.riotgames.notification
{
   import blix.action.IAction;
   import blix.action.QueueAction;
   
   public class DialogQueue implements IDialogQueueProvider
   {
      
      private var dialogQueue:QueueAction;
      
      private var currentDialogs:Vector.<IAction> = new Vector.<IAction>();
      
      public function DialogQueue()
      {
         super();
         this.dialogQueue = new QueueAction(false);
         this.dialogQueue.autoInvoke = true;
         this.dialogQueue.forgetActions = true;
      }
      
      public function getAllDialogs() : Vector.<IAction>
      {
         return this.dialogQueue.getActions();
      }
      
      public function removeActiveDialogs() : void
      {
         var _loc1_:IAction = null;
         for each(_loc1_ in this.currentDialogs)
         {
            this.removeDialog(_loc1_);
         }
      }
      
      private function dialogInvokedHandler(param1:IAction) : void
      {
         this.currentDialogs[this.currentDialogs.length] = param1;
      }
      
      private function configureDialog(param1:IAction) : void
      {
         param1.getInvoked().add(this.dialogInvokedHandler);
         param1.getCompleted().add(this.dialogFinishedHandler);
         param1.getErred().add(this.dialogFinishedHandler);
         param1.getAborted().add(this.dialogFinishedHandler);
      }
      
      public function getActiveDialogs() : Vector.<IAction>
      {
         return this.currentDialogs.slice();
      }
      
      private function unconfigureDialog(param1:IAction) : void
      {
         param1.getInvoked().remove(this.dialogInvokedHandler);
         param1.getCompleted().remove(this.dialogFinishedHandler);
         param1.getErred().remove(this.dialogFinishedHandler);
         param1.getAborted().remove(this.dialogFinishedHandler);
      }
      
      private function dialogFinishedHandler(param1:IAction) : void
      {
         this.removeDialog(param1);
      }
      
      public function addDialog(param1:IAction) : void
      {
         var _loc2_:IAction = null;
         for each(_loc2_ in this.currentDialogs)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         this.configureDialog(param1);
         this.dialogQueue.addAction(param1);
      }
      
      public function removeDialog(param1:IAction) : void
      {
         var _loc2_:int = 0;
         if(param1.getHasBeenInvoked())
         {
            _loc2_ = this.currentDialogs.indexOf(param1);
            if(_loc2_ != -1)
            {
               this.currentDialogs.splice(_loc2_,1);
            }
         }
         else
         {
            this.dialogQueue.removeAction(param1);
         }
         param1.abort();
         this.unconfigureDialog(param1);
      }
   }
}

