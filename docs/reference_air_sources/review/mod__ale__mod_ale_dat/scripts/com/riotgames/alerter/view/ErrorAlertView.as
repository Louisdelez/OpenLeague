package com.riotgames.alerter.view
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.error.MailError;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertErrorAction;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ErrorAlertView extends StandardMessageAlertView
   {
      
      protected var sendingReport:Boolean;
      
      protected var errorText:TextFieldProxy;
      
      protected var pleaseTellUsMessage:TextFieldProxy;
      
      protected var createdReportMessage:TextFieldProxy;
      
      protected var showStackTraceButton:ButtonX;
      
      public function ErrorAlertView(param1:IContext)
      {
         super(param1);
         setLinkage("ErrorAlertView");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.errorText = new TextFieldProxy(this);
         this.errorText.setVisible(false);
         setTimelineChildByName("errorText",this.errorText);
         verticalLayoutContainer.addElement(this.errorText);
         this.pleaseTellUsMessage = new TextFieldProxy(this);
         this.pleaseTellUsMessage.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("pleaseTellUsMessage",this.pleaseTellUsMessage);
         verticalLayoutContainer.addElementAt(this.pleaseTellUsMessage,1);
         this.createdReportMessage = new TextFieldProxy(this);
         this.createdReportMessage.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("createdReportMessage",this.createdReportMessage);
         verticalLayoutContainer.addElementAt(this.createdReportMessage,2);
         this.showStackTraceButton = new ButtonX(this);
         setTimelineChildByName("showStackTraceButton",this.showStackTraceButton);
         this.showStackTraceButton.setVisible(false);
         this.showStackTraceButton.toggleOnClick = true;
         this.showStackTraceButton.addEventListener(MouseEvent.CLICK,this.showStackTraceClickHandler);
         buttonsContainer.addElement(this.showStackTraceButton);
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         _loc1_.addEventListener(Event.CHANGE,this.resourcesChangedHandler);
         this.resourcesChangedHandler();
      }
      
      override public function setAlertAction(param1:AlertAction) : void
      {
         super.setAlertAction(param1);
         if(param1 is AlertErrorAction)
         {
            this.errorText.setText((param1 as AlertErrorAction).stackTrace);
         }
      }
      
      private function showStackTraceClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:AlertErrorAction = _alertAction as AlertErrorAction;
         if(_loc2_)
         {
            this.errorText.setVisible(this.showStackTraceButton.getSelected());
         }
      }
      
      private function resourcesChangedHandler(param1:Event = null) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         this.pleaseTellUsMessage.setText(_loc2_.getString("resources","errorDialog_errorRequest1"));
         this.createdReportMessage.setText(_loc2_.getString("resources","errorDialog_errorRequest2"));
      }
      
      override protected function affirmativeClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:AlertErrorAction = _alertAction as AlertErrorAction;
         if(this.sendingReport || _loc2_ == null)
         {
            return;
         }
         this.sendingReport = true;
         _alertAction.affirmativeResponse = true;
         var _loc3_:LogManager = LogManager.instance;
         _loc3_.submitErrorReport(_loc2_.body,_loc2_.stackTrace,this.onLogSubmissionComplete,this.onLogSubmissionError);
      }
      
      private function onLogSubmissionError(param1:MailError) : void
      {
         this.sendingReport = false;
         logger.error("Failed to submit error report: " + param1.smtpResponseMessage);
      }
      
      private function onLogSubmissionComplete(param1:Boolean) : void
      {
         this.sendingReport = false;
         _alertAction.complete();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         _loc1_.removeEventListener(Event.CHANGE,this.resourcesChangedHandler);
      }
   }
}

