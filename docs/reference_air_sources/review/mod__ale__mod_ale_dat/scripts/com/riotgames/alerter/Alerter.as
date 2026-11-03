package com.riotgames.alerter
{
   import blix.action.IAction;
   import blix.action.QueueAction;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   
   public class Alerter implements IAlerterProvider
   {
      
      private var alertsQueue:QueueAction;
      
      private var currentAlerts:Vector.<IAction> = new Vector.<IAction>();
      
      private var _alertViewFactory:IAlertViewFactory;
      
      public function Alerter(param1:IAlertViewFactory)
      {
         super();
         this._alertViewFactory = param1;
         this.alertsQueue = new QueueAction(false);
         this.alertsQueue.autoInvoke = true;
         this.alertsQueue.forgetActions = true;
      }
      
      public function addAlert(param1:IAction) : void
      {
         var _loc2_:IAction = null;
         for each(_loc2_ in this.currentAlerts)
         {
            if(_loc2_ == param1)
            {
               return;
            }
         }
         this.configureAlert(param1);
         this.alertsQueue.addAction(param1);
      }
      
      public function removeAlert(param1:IAction) : void
      {
         var _loc2_:int = 0;
         if(param1.getHasBeenInvoked())
         {
            this._alertViewFactory.hideAlert(param1);
            _loc2_ = this.currentAlerts.indexOf(param1);
            if(_loc2_ != -1)
            {
               this.currentAlerts.splice(_loc2_,1);
            }
         }
         else
         {
            this.alertsQueue.removeAction(param1);
         }
         this.unconfigureAlert(param1);
      }
      
      private function configureAlert(param1:IAction) : void
      {
         param1.getInvoked().add(this.alertInvokedHandler);
         param1.getCompleted().add(this.alertFinishedHandler);
         param1.getErred().add(this.alertFinishedHandler);
         param1.getAborted().add(this.alertFinishedHandler);
      }
      
      protected function unconfigureAlert(param1:IAction) : void
      {
         param1.getInvoked().remove(this.alertInvokedHandler);
         param1.getCompleted().remove(this.alertFinishedHandler);
         param1.getErred().remove(this.alertFinishedHandler);
         param1.getAborted().remove(this.alertFinishedHandler);
      }
      
      protected function alertInvokedHandler(param1:IAction) : void
      {
         this._alertViewFactory.showAlert(param1);
         this.currentAlerts[this.currentAlerts.length] = param1;
      }
      
      protected function alertFinishedHandler(param1:IAction) : void
      {
         this.removeAlert(param1);
      }
      
      public function getActiveAlerts() : Vector.<IAction>
      {
         return this.currentAlerts.slice();
      }
      
      public function getAllAlerts() : Vector.<IAction>
      {
         return this.alertsQueue.getActions();
      }
   }
}

