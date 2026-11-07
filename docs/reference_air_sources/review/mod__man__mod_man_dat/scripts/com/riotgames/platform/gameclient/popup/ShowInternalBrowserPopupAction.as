package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.components.controls.BrowserEvent;
   import com.riotgames.platform.common.components.controls.InternalBrowser;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.common.view.IInternalBrowserAction;
   import flash.display.DisplayObject;
   import mx.managers.PopUpManager;
   
   public class ShowInternalBrowserPopupAction extends BasicAction implements IInternalBrowserAction
   {
      
      private var width:int;
      
      private var showBrowserBarByDefault:Boolean;
      
      private var height:int;
      
      private var parent:DisplayObject;
      
      private var popup:InternalBrowser;
      
      private var relativePositioning:Boolean;
      
      private var showBrowserBarForDomains:Array;
      
      private var url:String;
      
      private var browserClosed:Signal = new Signal();
      
      public function ShowInternalBrowserPopupAction()
      {
         super(true);
      }
      
      public function addMaxAndCenter(param1:String, param2:Boolean, param3:Array) : void
      {
         this.add(param1,param2,param3,null,-1,-1);
      }
      
      public function remove() : void
      {
         complete();
      }
      
      private function onCloseInternalBrowser(param1:BrowserEvent) : void
      {
         complete();
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      public function add(param1:String, param2:Boolean, param3:Array, param4:DisplayObject, param5:int, param6:int) : void
      {
         var _loc7_:DisplayObject = ApplicationUtil.application as DisplayObject;
         this.url = param1;
         this.showBrowserBarByDefault = param2;
         this.showBrowserBarForDomains = param3;
         this.parent = param4 != null ? param4 : _loc7_;
         this.width = param5 < 0 ? _loc7_.stage.stageWidth : param5;
         this.height = param6 < 0 ? _loc7_.stage.stageHeight : param6;
         this.relativePositioning = param4 != null;
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
         this.popup = new InternalBrowser();
         this.popup.initialize();
         this.popup.closeBrowserOnLocationChange = ["close_external_browser"];
         this.popup.showBrowserBarByDefault = this.showBrowserBarByDefault;
         this.popup.showBrowserBarForDomains = this.showBrowserBarForDomains;
         this.popup.width = this.width;
         this.popup.height = this.height;
         this.popup.addEventListener(BrowserEvent.CLOSE_REQUESTED,this.onCloseInternalBrowser);
         this.popup.navigateTo(this.url);
         PopUpManager.addPopUp(this.popup,this.parent,true);
         if(!this.relativePositioning)
         {
            PopUpManager.centerPopUp(this.popup);
         }
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.browserClosed.dispatch(this.browserClosed);
            this.browserClosed.removeAll();
            this.popup.removeEventListener(BrowserEvent.CLOSE_REQUESTED,this.onCloseInternalBrowser);
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
         }
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      public function getBrowserClosed() : ISignal
      {
         return this.browserClosed;
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
   }
}

