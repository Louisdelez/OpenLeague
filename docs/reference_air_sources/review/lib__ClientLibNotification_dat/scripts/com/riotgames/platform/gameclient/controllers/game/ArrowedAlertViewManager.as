package com.riotgames.platform.gameclient.controllers.game
{
   import mx.binding.utils.ChangeWatcher;
   import mx.core.Container;
   import mx.events.PropertyChangeEvent;
   import mx.managers.PopUpManager;
   
   public class ArrowedAlertViewManager
   {
      
      private var currentAlertView:ArrowedAlertView = null;
      
      private var parent:Container;
      
      public var arrowedAlertController:ArrowedAlertController;
      
      private var alertChangeWatcher:ChangeWatcher = null;
      
      public var modalParent:Boolean = false;
      
      public function ArrowedAlertViewManager(param1:Container, param2:ArrowedAlertController)
      {
         super();
         this.parent = param1;
         this.arrowedAlertController = param2;
      }
      
      private function updateAlerts() : void
      {
         if(this.currentAlertView == null)
         {
            if(this.arrowedAlertController.activeAlert == null)
            {
               return;
            }
         }
         else if(this.currentAlertView.alertParameters == this.arrowedAlertController.activeAlert)
         {
            return;
         }
         if(this.currentAlertView != null)
         {
            PopUpManager.removePopUp(this.currentAlertView);
            this.currentAlertView = null;
         }
         if(this.arrowedAlertController.activeAlert != null && this.modalParent == this.arrowedAlertController.activeAlert.modalParent)
         {
            this.currentAlertView = new ArrowedAlertView();
            this.currentAlertView.arrowedAlertController = this.arrowedAlertController;
            this.currentAlertView.alertParameters = this.arrowedAlertController.activeAlert;
            this.currentAlertView.x = this.arrowedAlertController.activeAlert.x;
            this.currentAlertView.y = this.arrowedAlertController.activeAlert.y;
            PopUpManager.addPopUp(this.currentAlertView,this.parent);
         }
      }
      
      public function activate() : void
      {
         if(this.alertChangeWatcher == null)
         {
            this.alertChangeWatcher = ChangeWatcher.watch(this.arrowedAlertController,"activeAlert",this.onActiveAlertChanged);
         }
         this.updateAlerts();
      }
      
      public function deactivate() : void
      {
         if(this.alertChangeWatcher != null)
         {
            this.alertChangeWatcher.unwatch();
            this.alertChangeWatcher = null;
         }
      }
      
      private function onActiveAlertChanged(param1:PropertyChangeEvent) : void
      {
         this.updateAlerts();
      }
   }
}

