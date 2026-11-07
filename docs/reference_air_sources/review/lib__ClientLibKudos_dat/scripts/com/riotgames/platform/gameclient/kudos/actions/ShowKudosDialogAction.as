package com.riotgames.platform.gameclient.kudos.actions
{
   import blix.IDestructible;
   import blix.action.BasicAction;
   import blix.context.IContext;
   import blix.view.ILayoutData;
   import blix.view.ILayoutElement;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import mx.managers.PopUpManager;
   
   public class ShowKudosDialogAction extends BasicAction
   {
      
      private var popUpView:ICancelableDialog;
      
      private var layoutElement:ILayoutElement;
      
      private var layoutData:ILayoutData;
      
      private var location:Point;
      
      public function ShowKudosDialogAction(param1:IContext)
      {
         super(true);
      }
      
      public function add(param1:ICancelableDialog, param2:ILayoutElement, param3:ILayoutData = null, param4:Point = null) : void
      {
         this.popUpView = param1;
         this.layoutElement = param2;
         this.layoutData = param3;
         this.location = param4;
         if(getIsFinished())
         {
            reset();
         }
         DialogQueueProviderProxy.instance.addDialog(this);
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      private function addPopUp() : void
      {
         var _loc1_:DisplayObject = null;
         if(AppConfig.instance.legacyPopupSupport)
         {
            _loc1_ = ApplicationUtil.application as DisplayObject;
            mx.managers.PopUpManager.addPopUp(this.popUpView,_loc1_,true);
            if(this.location == null)
            {
               mx.managers.PopUpManager.centerPopUp(this.popUpView);
            }
            else
            {
               this.popUpView.x = this.location.x;
               this.popUpView.y = this.location.y;
            }
         }
         else
         {
            com.riotgames.rust.popup.PopUpManager.addPopUp(this.layoutElement,this.layoutData,true);
         }
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      private function removePopUp() : void
      {
         if(AppConfig.instance.legacyPopupSupport)
         {
            mx.managers.PopUpManager.removePopUp(this.popUpView);
            this.popUpView = null;
            this.location = null;
         }
         else
         {
            com.riotgames.rust.popup.PopUpManager.removePopUp(this.layoutElement);
            if(this.layoutElement is IDestructible)
            {
               (this.layoutElement as IDestructible).destroy();
            }
            this.layoutElement = null;
            this.layoutData = null;
         }
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
   }
}

