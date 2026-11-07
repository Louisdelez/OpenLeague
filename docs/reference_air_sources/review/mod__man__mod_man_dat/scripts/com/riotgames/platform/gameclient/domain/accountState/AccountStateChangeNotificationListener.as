package com.riotgames.platform.gameclient.domain.accountState
{
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.util.json.jsonDecode;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class AccountStateChangeNotificationListener
   {
      
      private var getStateTimeoutId:uint = 0;
      
      public var lastKnownState:String = null;
      
      public var applicationController:IAppController;
      
      public var accountTransferCompletedPopupAction:IShowAccountTransferPopupAction;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var accountTransferStartedPopupAction:IShowAccountTransferPopupAction;
      
      public var accountTransferFailedPopupAction:IShowAccountTransferPopupAction;
      
      public var accountTransferUnknownPopupAction:IShowAccountTransferPopupAction;
      
      private const CHECK_STATE_DELAY:Number = 30000;
      
      public function AccountStateChangeNotificationListener()
      {
         super();
      }
      
      private function handleTransitionToTransferredOut(param1:AccountStateChangeNotification) : void
      {
         if(param1.oldState != AccountState.TRANSFERRING_OUT)
         {
            this.logger.error("Received an invalid transition to Transferred out.. old State: " + param1.oldState + " eventDate: " + param1.eventDate);
         }
         var _loc2_:AccountStateChangeContext = this.decodeContext(param1.context);
         if(this.accountTransferCompletedPopupAction != null)
         {
            this.clearAccountTransferDialogs();
            this.accountTransferCompletedPopupAction.getCompleted().add(this.logoutFromAccountTransferDialog);
            this.accountTransferCompletedPopupAction.add(_loc2_);
         }
         this.applicationController.logout(false);
         this.writeRegionFile(_loc2_.destinationPlatformId);
      }
      
      public function handleAccountStateChangeEvent(param1:AccountStateChangeNotification) : void
      {
         this.cancelCurrentTimeout();
         if(this.lastKnownState == null)
         {
            this.lastKnownState = param1.oldState;
         }
         if(param1.newState == AccountState.ENABLED)
         {
            this.handleTransitionToEnabled(param1);
         }
         else if(param1.newState == AccountState.TRANSFERRING_OUT)
         {
            this.handleTransitionToTransferringOut(param1);
         }
         else if(param1.newState == AccountState.TRANSFERRED_OUT)
         {
            this.handleTransitionToTransferredOut(param1);
         }
         else
         {
            this.logger.error("Received a new account state an account shouldn\'t be able to transition to while logged in... last known state:" + this.lastKnownState + " oldState: " + param1.oldState + " new state: " + param1.newState + " eventDate:" + param1.eventDate);
         }
         this.lastKnownState = param1.newState;
      }
      
      private function clearAccountTransferDialogs() : void
      {
         if(this.accountTransferCompletedPopupAction != null)
         {
            DialogQueueProviderProxy.instance.removeDialog(this.accountTransferCompletedPopupAction);
         }
         if(this.accountTransferFailedPopupAction != null)
         {
            DialogQueueProviderProxy.instance.removeDialog(this.accountTransferFailedPopupAction);
         }
         if(this.accountTransferStartedPopupAction != null)
         {
            DialogQueueProviderProxy.instance.removeDialog(this.accountTransferStartedPopupAction);
         }
         if(this.accountTransferUnknownPopupAction != null)
         {
            DialogQueueProviderProxy.instance.removeDialog(this.accountTransferUnknownPopupAction);
         }
      }
      
      private function cancelCurrentTimeout() : void
      {
         if(this.getStateTimeoutId != 0)
         {
            clearTimeout(this.getStateTimeoutId);
            this.getStateTimeoutId = 0;
         }
      }
      
      private function getCurrentState() : void
      {
         if(this.getStateTimeoutId != 0)
         {
            this.getStateTimeoutId = 0;
         }
         this.serviceProxy.accountService.getAccountState(this.handleGetAccountStateResult,this.handleGetAccountStateFailure,null);
      }
      
      private function writeRegionFile(param1:String) : void
      {
         var _loc2_:File = new File(File.applicationDirectory.resolvePath("region.tmp").nativePath);
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc2_,FileMode.WRITE);
         _loc3_.writeUTFBytes(param1);
         _loc3_.close();
      }
      
      private function handleTransitionToTransferringOut(param1:AccountStateChangeNotification) : void
      {
         if(param1.oldState != AccountState.ENABLED)
         {
            this.logger.error("Received an invalid transition to Transferring out.. old State: " + param1.oldState + " eventDate: " + param1.eventDate);
         }
         if(this.accountTransferStartedPopupAction != null)
         {
            this.clearAccountTransferDialogs();
            this.accountTransferStartedPopupAction.add();
         }
         this.getStateTimeoutId = setTimeout(this.getCurrentState,this.CHECK_STATE_DELAY);
      }
      
      private function handleGetAccountStateFailure(param1:Boolean) : void
      {
         var _loc2_:AccountStateChangeNotification = null;
         this.logger.error("Failed to retrieve account state... Assuming state hasn\'t changed. LastKnownState: " + this.lastKnownState);
         if(this.lastKnownState == AccountState.TRANSFERRING_OUT)
         {
            _loc2_ = new AccountStateChangeNotification();
            _loc2_.oldState = this.lastKnownState;
            _loc2_.newState = this.lastKnownState;
            _loc2_.eventDate = new Date();
            this.handleTransferUnknownStatus(_loc2_);
         }
      }
      
      private function decodeContext(param1:String) : AccountStateChangeContext
      {
         var _loc2_:Object = null;
         if(param1 != null)
         {
            _loc2_ = jsonDecode(param1);
         }
         return new AccountStateChangeContext(_loc2_);
      }
      
      private function handleTransferUnknownStatus(param1:AccountStateChangeNotification) : void
      {
         this.applicationController.logout(false);
         if(this.accountTransferUnknownPopupAction != null)
         {
            this.clearAccountTransferDialogs();
            this.accountTransferUnknownPopupAction.getCompleted().add(this.logoutFromAccountTransferDialog);
            this.accountTransferUnknownPopupAction.add();
         }
      }
      
      public function logoutFromAccountTransferDialog() : void
      {
         this.applicationController.logout(true);
      }
      
      private function handleGetAccountStateResult(param1:ResultEvent) : void
      {
         var _loc2_:String = param1.result as String;
         this.logger.warn("Did not receive a new state via client notification tickled instead. New State: " + _loc2_ + " Last known state: " + this.lastKnownState);
         var _loc3_:AccountStateChangeNotification = new AccountStateChangeNotification();
         _loc3_.newState = _loc2_;
         _loc3_.oldState = this.lastKnownState;
         _loc3_.eventDate = new Date();
         if(_loc3_.oldState == _loc3_.newState && _loc3_.newState == AccountState.TRANSFERRING_OUT)
         {
            this.handleTransferUnknownStatus(_loc3_);
         }
         else
         {
            this.handleAccountStateChangeEvent(_loc3_);
         }
      }
      
      private function handleTransitionToEnabled(param1:AccountStateChangeNotification) : void
      {
         var _loc2_:AccountStateChangeContext = null;
         if(param1.oldState == AccountState.TRANSFERRING_OUT || this.lastKnownState == AccountState.TRANSFERRING_OUT || param1.oldState == AccountState.ENABLED)
         {
            _loc2_ = this.decodeContext(param1.context);
            if(this.accountTransferFailedPopupAction != null)
            {
               this.clearAccountTransferDialogs();
               this.accountTransferFailedPopupAction.add(_loc2_);
            }
         }
         else
         {
            this.logger.error("Received an invalid transition to Enabled.. old State: " + param1.oldState + " eventDate: " + param1.eventDate);
         }
      }
   }
}

