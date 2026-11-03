package com.riotgames.pvpnet.game.controllers.actions
{
   import blix.action.BasicAction;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ShowQueueThrottledPopupAction extends BasicAction
   {
      
      private var popup:AlertAction;
      
      public function ShowQueueThrottledPopupAction()
      {
         super(true);
      }
      
      private function addPopUp() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         this.popup = new AlertAction(_loc1_.getString("resources","matchmaking_joinqueue_queue_throttled_warning_title"),_loc1_.getString("resources","matchmaking_joinqueue_queue_throttled_warning_description"));
         this.popup.getCompleted().add(this.onClosed);
         this.popup.add();
      }
      
      private function onClosed() : void
      {
         complete();
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.abort();
            this.popup = null;
            abort();
         }
      }
      
      final public function add() : void
      {
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
   }
}

