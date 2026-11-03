package com.riotgames.pvpnet.CLS.views.leagueFAQView
{
   import blix.action.BasicAction;
   import blix.context.IContext;
   import blix.layout.data.CanvasLayoutData;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.rust.popup.PopUpManager;
   
   public class ShowLeagueFAQPopupAction extends BasicAction
   {
      
      private var parentContext:IContext;
      
      private var questionID:int;
      
      private var popup:LeagueFAQView;
      
      public function ShowLeagueFAQPopupAction()
      {
         super(true);
      }
      
      private function addPopUp() : void
      {
         this.popup = new LeagueFAQView(this.parentContext);
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.selectionQuestion(this.questionID);
         var _loc1_:CanvasLayoutData = new CanvasLayoutData();
         _loc1_.setLeft(5);
         _loc1_.setTop(5);
         _loc1_.setRight(5);
         _loc1_.setBottom(5);
         PopUpManager.addPopUp(this.popup,_loc1_,true);
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnClosed().remove(this.onClosed);
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      public function add(param1:IContext, param2:int = 0) : void
      {
         this.parentContext = param1;
         this.questionID = param2;
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

