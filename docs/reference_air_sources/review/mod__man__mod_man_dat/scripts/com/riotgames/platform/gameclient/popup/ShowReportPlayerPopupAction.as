package com.riotgames.platform.gameclient.popup
{
   import blix.action.BasicAction;
   import blix.signals.ISignal;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.IReportTracker;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.domain.PlayerComplaint;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.views.Support.ReportPlayerView;
   import com.riotgames.pvpnet.game.alerts.IReportPlayerAlertAction;
   import com.riotgames.pvpnet.suggestedplayers.SuggestedPlayersProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.display.DisplayObject;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.PopUpManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class ShowReportPlayerPopupAction extends BasicAction implements IReportPlayerAlertAction
   {
      
      private var player:PlayerParticipantStatsSummary;
      
      private var reportTracker:IReportTracker;
      
      private var popup:ReportPlayerView;
      
      private var gameID:Number;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function ShowReportPlayerPopupAction()
      {
         super(true);
      }
      
      override protected function onErred(param1:Error) : void
      {
         this.removePopUp();
      }
      
      override protected function doInvocation() : void
      {
         this.addPopUp();
      }
      
      private function addPopUp() : void
      {
         this.popup = new ReportPlayerView();
         this.popup.getOnClosed().add(this.onClosed);
         this.popup.getOnSendReport().add(this.onSendReport);
         this.popup.player = this.player;
         this.popup.gameID = this.gameID;
         var _loc1_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.popup,_loc1_,true);
         PopUpManager.centerPopUp(this.popup);
      }
      
      override protected function onCompleted() : void
      {
         this.removePopUp();
      }
      
      private function removePopUp() : void
      {
         if(this.popup != null)
         {
            this.popup.getOnSendReport().removeAll();
            this.popup.getOnClosed().removeAll();
            PopUpManager.removePopUp(this.popup);
            this.popup = null;
            this.player = null;
            this.gameID = NaN;
         }
      }
      
      private function onClosed(param1:ISignal) : void
      {
         param1.remove(this.onClosed);
         complete();
      }
      
      override protected function onAborted() : void
      {
         this.removePopUp();
      }
      
      final public function add(param1:PlayerParticipantStatsSummary, param2:Number, param3:IReportTracker) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:AlertAction = null;
         this.player = param1;
         this.gameID = param2;
         this.reportTracker = param3;
         if(getIsFinished())
         {
            reset();
         }
         if(ClientConfig.instance.tribunalEnabled)
         {
            DialogQueueProviderProxy.instance.addDialog(this);
         }
         else
         {
            _loc4_ = ResourceManager.getInstance().getString("resources","reportPlayerDialogHeader");
            _loc5_ = ResourceManager.getInstance().getString("resources","reportPlayer_unavailableMessage");
            _loc6_ = new AlertAction(_loc4_,_loc5_);
            _loc6_.add();
         }
      }
      
      private function onSendReport(param1:ISignal, param2:PlayerComplaint, param3:String) : void
      {
         param1.remove(this.onSendReport);
         ServiceProxy.instance.clientFacadeService.reportPlayer(param2,null);
         this.reportTracker.addReport(param3);
         SuggestedPlayersProviderProxy.instance.handlePlayerReported(param3);
         complete();
         var _loc4_:IResourceManager = ResourceManager.getInstance();
         var _loc5_:AlertAction = new AlertAction(_loc4_.getString("resources","reportPlayer_confirmationLabel"),_loc4_.getString("resources","reportPlayer_confirmationMessage",[param3]));
         _loc5_.add();
      }
   }
}

