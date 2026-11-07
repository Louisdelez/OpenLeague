package com.riotgames.platform.gameclient.module.login.controller
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.event.LoginQueueEvent;
   import com.riotgames.platform.common.exception.LoginFailedException;
   import com.riotgames.platform.common.services.DomainType;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.services.login.queue.AuthResult;
   import com.riotgames.platform.common.services.login.queue.InGameCredentials;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.application.Version;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.module.login.event.LoginViewEvent;
   import com.riotgames.platform.gameclient.module.login.view.ILoginView;
   import com.riotgames.platform.gameclient.module.login.view.InitiateLoginEvent;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.data.EncryptedLocalStore;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   public class LoginMediator
   {
      
      private var loginMessageResource:LoginMessageResource = new LoginMessageResource();
      
      private var loginTracker:ILoginProcessTracker;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session = Session.instance;
      
      public var password:String = "password";
      
      private var inlineCredentials:String = "";
      
      private var macAddress:String = "";
      
      private var serverSessionAvailableCallback:Function;
      
      private var loginView:ILoginView;
      
      public var authToken:String;
      
      private var _userHasReconnectedToGame:Boolean = false;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var loginQueueMediator:LoginQueueMediator;
      
      private var proxiedOnError:Function;
      
      private var authRetryTimer:Timer;
      
      private var authRetryAttempts:uint = 0;
      
      private var isAllowedToFailover:Boolean = true;
      
      private var _inGameCredentials:InGameCredentials;
      
      public var username:String = "username";
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var loginQueueController:LoginQueueController;
      
      private var _sessionMetrics:ISessionMetricsProvider;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      private var proxiedOnFail:Function;
      
      public function LoginMediator(param1:ILoginView, param2:LoginQueueController, param3:Function, param4:ILoginProcessTracker = null)
      {
         super();
         this.loginView = param1;
         this.loginQueueController = param2;
         this.serverSessionAvailableCallback = param3;
         this.loginTracker = param4;
         if(param4 != null)
         {
            param4.reachedLoginScreen();
         }
         param1.dispatcher.addEventListener(InitiateLoginEvent.INITIATE_LOGIN,this.initiateLoginSequence,false,0,true);
         param1.dispatcher.addEventListener(LoginViewEvent.UPDATE_LOGINNAME,this.updateLoginName,false,0,true);
         param1.dispatcher.addEventListener(LoginViewEvent.UPDATE_REMEMBER_LOGINNAME,this.updateRememberLoginName,false,0,true);
         param1.dispatcher.addEventListener(LoginViewEvent.UPDATE_MUTE_LOGIN_MUSIC,this.updateMuteLoginMusic,false,0,true);
         param1.dispatcher.addEventListener(LoginViewEvent.UPDATE_ENABLE_ANIMATIONS,this.updateEnableAnimations,false,0,true);
         param1.dispatcher.addEventListener(LoginViewEvent.RECONNECT_TO_GAME,this.reconnectToGameInProgress,false,0,true);
      }
      
      private function handleLoginQueueRequestPoll(param1:Event) : void
      {
         if(this.loginQueueController.inQueue)
         {
            this.loginQueueController.forcePollUpdate();
         }
      }
      
      private function userDisconnectedFromGame() : void
      {
         this._userHasReconnectedToGame = false;
         this.updateInGameState();
      }
      
      private function performLogin() : void
      {
         if(!this.isPartnerLogin)
         {
            this.loginWithInputFieldCredentials(this.onLoginFailed,this.onLoginError);
         }
         else
         {
            this.loginWithPartnerCredentials(this.onLoginFailed,this.onLoginError);
         }
         ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvided);
      }
      
      private function startRetryWaitTimer(param1:int) : void
      {
         this.loginView.retryWaitStart(param1);
         var _loc2_:Timer = new Timer(1000,param1);
         _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleRetryWaitOver,false,0,true);
         _loc2_.addEventListener(TimerEvent.TIMER,this.handleRetryWaitTick,false,0,true);
         _loc2_.start();
      }
      
      private function clearPassword() : void
      {
         this.password = this.password.replace(/\w/g,"*");
      }
      
      private function handleLoginQueueCancel(param1:Event) : void
      {
         if(this.loginQueueController.inQueue)
         {
            this.loginQueueController.cancelQueue(this.onQueueCancelled);
            if(this.loginTracker != null)
            {
               this.loginTracker.cancelledQueue();
            }
         }
      }
      
      private function inGameHandler(param1:InGameCredentials) : void
      {
         if(param1 != null && param1.inGame == true)
         {
            this._inGameCredentials = param1;
            this._userHasReconnectedToGame = false;
            this.updateInGameState();
         }
      }
      
      public function displayLoginQueueStatus(param1:LoginQueueEvent) : void
      {
         this.loginView.displayLoginStatusText(ResourceManager.getInstance().getString("Login2","login_status_title"),ResourceManager.getInstance().getString("Login2","login_status_auth_successful_prequeue"));
         this.loginQueueMediator.addEventListener(LoginQueueMediator.EVENT_QUEUE_CANCEL,this.handleLoginQueueCancel,false,0,true);
         this.loginQueueMediator.addEventListener(LoginQueueMediator.EVENT_QUEUE_SHOW_COUNTDOWN,this.handleLoginQueueShowCountdown,false,0,true);
         this.loginQueueMediator.addEventListener(LoginQueueMediator.EVENT_QUEUE_REQUEST_POLL,this.handleLoginQueueRequestPoll,false,0,true);
         this.loginQueueMediator.updateStatus(param1);
      }
      
      private function handleLoginQueueShowCountdown(param1:Event) : void
      {
         if(this.loginQueueController.inQueue)
         {
            this.loginView.busyLoggingIn = false;
            this.loginView.onLoginQueueEntered();
         }
      }
      
      public function getInGameCredentials() : InGameCredentials
      {
         return this._inGameCredentials;
      }
      
      private function updateInGameState() : void
      {
         if(this._inGameCredentials != null && this._inGameCredentials.inGame == true && !this._userHasReconnectedToGame)
         {
            this.loginView.setInGame(true);
         }
         else
         {
            this.loginView.setInGame(false);
         }
      }
      
      public function cleanup() : void
      {
         MaestroProviderProxy.instance.getGameClientConnectedToServer().remove(this.userReconnectedToGame);
         MaestroProviderProxy.instance.getGameAbandoned().remove(this.userDisconnectedFromGame);
         MaestroProviderProxy.instance.getGameCompleted().remove(this.userFinishedGame);
         MaestroProviderProxy.instance.getGameCrashed().remove(this.userDisconnectedFromGame);
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
      }
      
      private function handleRetryWaitTick(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.target as Timer;
         this.loginView.retryWaitTick(_loc2_.repeatCount - _loc2_.currentCount);
      }
      
      private function callLoginService() : void
      {
         if(this.authToken != null && this.authToken.indexOf("{") >= 0)
         {
         }
         this.loginView.displayLoginStatusText(ResourceManager.getInstance().getString("Login2","login_status_title"),ResourceManager.getInstance().getString("Login2","login_status_calling_login"));
         var _loc1_:String = Capabilities.os;
         if(!this.isPartnerLogin)
         {
            if(!this.authToken)
            {
               this.logger.warn("9010 Login: No token!");
            }
            this.serviceProxy.loginService.login(this.username,this.password,this.authToken,DomainType.LOL_CLIENT,this.macAddress,this.clientConfig.locale,Version.CURRENT_VERSION,_loc1_,this.onLoginSuccess,this.onLoginComplete,this.onServiceRequestError);
         }
         else
         {
            this.serviceProxy.loginService.loginWithSuppliedCredentials(this.username,this.clientConfig.partnerCredentials,this.authToken,DomainType.LOL_CLIENT,this.macAddress,this.clientConfig.locale,Version.CURRENT_VERSION,_loc1_,this.onLoginSuccess,this.onLoginComplete,this.onServiceRequestError);
         }
         this.clearPassword();
      }
      
      private function initiateLoginSequence(param1:InitiateLoginEvent) : void
      {
         LogManager.instance.assertLogFiltering();
         if(this.isPartnerLogin)
         {
            this.inlineCredentials = this.clientConfig.partnerCredentials;
         }
         else
         {
            this.username = param1.username != null ? param1.username : "";
            this.password = param1.password != null ? param1.password : "";
            this.inlineCredentials = "user=" + this.username + ",password=" + this.password;
         }
         if(this.loginTracker != null)
         {
            this.loginTracker.loginInitiated();
         }
         this.authRetryAttempts = 0;
         this.loginView.busyLoggingIn = true;
         this.loginView.onLoginPreQueue();
         this.loginQueueController.authenticate(this.inlineCredentials,this.onAuthSuccess,this.onAuthFailed,this.displayLoginQueueStatus,this.inGameHandler);
      }
      
      public function onSessionMetricsProvided(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
      }
      
      public function updateRememberLoginName(param1:LoginViewEvent) : void
      {
         UserPreferencesManager.globalPrefs.rememberLogin = param1.data == "true";
      }
      
      public function onLoginFailed() : void
      {
         this.logger.error("9001 onLoginFailed()");
         this.loginView.displayLoginFailed(null,null);
         this.clearInlineCredentials();
      }
      
      private function retryAuthentication() : Boolean
      {
         var _loc1_:Number = NaN;
         if(this.authRetryTimer != null)
         {
            return true;
         }
         if(this.authRetryAttempts < Math.min(RiotServiceConfig.instance.maximumAuthenticationRetries,20) && this.inlineCredentials != "")
         {
            this.logger.warn("9005 Attempting authentication again. Attempt #" + (this.authRetryAttempts + 1));
            _loc1_ = Math.max(1000,int(Math.pow(RiotServiceConfig.instance.authenticationRetryBackoffFactor,this.authRetryAttempts) * 1000));
            this.authRetryTimer = new Timer(_loc1_,1);
            this.authRetryTimer.addEventListener(TimerEvent.TIMER,this.onRetryAuthenticationTimer,false,0,true);
            this.authRetryTimer.start();
            ++this.authRetryAttempts;
            this.loginView.busyLoggingIn = true;
            if(this.loginTracker != null)
            {
               this.loginTracker.setLoginRetryAttempts(this.authRetryAttempts);
            }
            return true;
         }
         if(this.loginTracker != null)
         {
            this.loginTracker.maxRetryAttemptsReached();
         }
         this.logger.warn("9006 Maximum amount of authentication retries reached!");
         return false;
      }
      
      public function updateEnableAnimations(param1:LoginViewEvent) : void
      {
         UserPreferencesManager.globalPrefs.enableAnimations = param1.data == "true";
      }
      
      public function loginWithPartnerCredentials(param1:Function, param2:Function) : void
      {
         this.loginView.busyLoggingIn = true;
         this.proxiedOnFail = param1;
         this.proxiedOnError = param2;
         if(!this.macAddress)
         {
            this.getMacAddress();
         }
         this.callLoginService();
         this.loginView.loginAllowed = false;
         this.loginView.onLoginPostQueue();
      }
      
      private function writeRegionFile(param1:String) : void
      {
         if(param1 == null)
         {
            this.logger.error("Received invalid destinationPlatformId");
            return;
         }
         var _loc2_:File = new File(File.applicationDirectory.resolvePath("region.tmp").nativePath);
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc2_,FileMode.WRITE);
         _loc3_.writeUTFBytes(param1);
         _loc3_.close();
      }
      
      private function onLoginComplete(param1:Boolean) : void
      {
         this.loginView.busyLoggingIn = false;
         if(!this.session.isLoggedIn)
         {
            this.loginView.loginAllowed = true;
         }
         this._sessionMetrics.sessionHasBeenCreated();
      }
      
      public function getUserHasReconnectedToGame() : Boolean
      {
         return this._userHasReconnectedToGame;
      }
      
      public function updateLoginName(param1:LoginViewEvent) : void
      {
         UserPreferencesManager.globalPrefs.loginName = UserPreferencesManager.globalPrefs.rememberLogin ? param1.data : "";
      }
      
      public function onAuthFailed(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:FaultEvent = null;
         var _loc4_:AuthenticationFailureMessage = null;
         var _loc5_:AuthResult = null;
         this.discardLoginQueueStatus();
         if(param1 is FaultEvent)
         {
            _loc3_ = param1 as FaultEvent;
            this.logger.error(ErrorUtil.makeErrorMessage(_loc3_.fault,"Auth failed with fault event:: status Code:" + _loc3_.statusCode));
            _loc4_ = this.retrieveAuthFailure(_loc3_);
            if(this.loginTracker != null)
            {
               this.loginTracker.loginFailedOnFaultEvent(_loc3_.statusCode);
            }
            switch(_loc3_.statusCode)
            {
               case 403:
                  this.loginView.busyLoggingIn = false;
                  if(_loc4_.isRetryWait)
                  {
                     this.startRetryWaitTimer(_loc4_.retryWait);
                  }
                  if(this.loginMessageResource.isAccountTransferred(_loc4_.reason))
                  {
                     this.writeRegionFile(_loc4_.destination);
                  }
                  this.loginView.displayAuthFailure(_loc4_);
                  break;
               default:
                  _loc2_ = this.retryAuthentication();
                  if(!_loc2_)
                  {
                     this.onLoginQueueUnavailable();
                  }
                  else
                  {
                     this.loginView.displayLoginStatusText(ResourceManager.getInstance().getString("Login2","login_status_title"),ResourceManager.getInstance().getString("Login2","login_status_auth_fail_retry",[this.authRetryAttempts]));
                     if(Boolean(this.loginTracker))
                     {
                        this.loginTracker.setLastUserFacingError("login_status_auth_fail_retry");
                     }
                  }
            }
         }
         else if(param1 is ServerError)
         {
            this.logger.error("9002 Auth failed with serverError: " + (param1 as ServerError).errorCode);
            this.onLoginError(param1 as ServerError);
         }
         else if(param1 is AuthResult)
         {
            this.logger.error("9003 Auth failed with authResult: " + (param1 as AuthResult).status);
            this.loginView.busyLoggingIn = false;
            _loc5_ = param1 as AuthResult;
            if(_loc5_.status == AuthResult.ARL_STATUS)
            {
               if(this.retryAuthentication())
               {
                  this.loginView.displayLoginStatusText(ResourceManager.getInstance().getString("Login2","login_status_title"),ResourceManager.getInstance().getString("Login2","login_status_auth_retry",[this.authRetryAttempts]));
                  if(Boolean(this.loginTracker))
                  {
                     this.loginTracker.setLastUserFacingError("login_status_auth_retry");
                  }
               }
               else
               {
                  this.loginView.displayServerBusy();
               }
            }
            else if(_loc5_.status == AuthResult.BUSY_STATUS)
            {
               this.loginView.displayServerBusy();
            }
            if(this.loginTracker != null)
            {
               this.loginTracker.loginFailedWithAuthResult(_loc5_.status);
            }
         }
         else
         {
            this.logger.error("9004 Auth failed in an unknown manner: " + param1);
            _loc2_ = this.retryAuthentication();
            if(!_loc2_)
            {
               this.onLoginQueueUnavailable();
            }
            else
            {
               this.loginView.displayLoginStatusText(ResourceManager.getInstance().getString("Login2","login_status_title"),ResourceManager.getInstance().getString("Login2","login_status_auth_fail_retry",[this.authRetryAttempts]));
               if(Boolean(this.loginTracker))
               {
                  this.loginTracker.setLastUserFacingError("login_status_auth_fail_retry");
               }
            }
            if(this.loginTracker != null)
            {
               this.loginTracker.loginFailedWithUnknown(param1);
            }
         }
      }
      
      private function getMacAddress() : void
      {
         var _loc1_:Vector.<NetworkInterface> = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:RegExp = null;
         if(Boolean(NetworkInfo.isSupported) && this.shouldCollectMacAddress())
         {
            _loc1_ = NetworkInfo.networkInfo.findInterfaces();
            _loc2_ = new Array();
            _loc3_ = "Network Interface Information: \n";
            _loc4_ = 0;
            while(_loc4_ < _loc1_.length)
            {
               if(_loc1_[_loc4_].hardwareAddress != null && _loc1_[_loc4_].hardwareAddress.length > 0)
               {
                  _loc2_.push(_loc1_[_loc4_].hardwareAddress);
               }
               _loc3_ += "Name: " + _loc1_[_loc4_].name + "\n" + "DisplayName: " + _loc1_[_loc4_].displayName + "\n" + "MTU: " + _loc1_[_loc4_].mtu + "\n" + "Hardware Address: " + _loc1_[_loc4_].hardwareAddress + "\n" + "Active: " + _loc1_[_loc4_].active + "\n";
               _loc4_++;
            }
            this.macAddress = _loc2_.join();
            _loc5_ = /[\s\r\n\]+/gim;
            this.macAddress = this.macAddress.replace(_loc5_,"");
            this.logger.debug("Discovered " + _loc2_.length + " MAC addresses: " + this.macAddress);
            this.logger.debug(_loc3_);
         }
      }
      
      private function onLoginSuccess(param1:ResultEvent) : void
      {
         var serverSession:ServerSessionObject = null;
         var bytes:ByteArray = null;
         var event:ResultEvent = param1;
         this.clearInlineCredentials();
         if(Boolean(event.result))
         {
            serverSession = ServerSessionObject(event.result);
            if(this.clientConfig.savePassword)
            {
               bytes = new ByteArray();
               bytes.writeUTFBytes(serverSession.password);
               EncryptedLocalStore.setItem("password",bytes);
            }
            if(serverSession.accountSummary != null && Boolean(serverSession.accountSummary.needsPasswordReset))
            {
               this.session.token = null;
               this.session.passwordResetLockout = true;
               this._sessionMetrics.passwordResetSessionHasBeenCreated();
            }
            else
            {
               this.session.loadServerSession(serverSession);
               this.serviceProxy.messageRouterService.initialize(serverSession);
               this.serviceProxy.remoteObjectGeneratorService.authenticateChannel(serverSession.accountSummary.username,serverSession.token);
            }
            this.loginView.outroComplete().addOnce(function():void
            {
               serverSessionAvailableCallback(serverSession);
            });
            this.loginView.onLoginSuccess();
         }
         else
         {
            this.proxiedOnFail.apply();
            this.proxiedOnFail = null;
            this.loginView.loginAllowed = true;
         }
      }
      
      private function clearInlineCredentials() : void
      {
         this.inlineCredentials = this.inlineCredentials.replace(/\w/g,"*");
      }
      
      public function updateMuteLoginMusic(param1:LoginViewEvent) : void
      {
         UserPreferencesManager.globalPrefs.loginMusicMute = param1.data == "true";
      }
      
      private function get isPartnerLogin() : Boolean
      {
         return this.clientConfig.partnerCredentials != null;
      }
      
      public function onLoginError(param1:ServerError) : void
      {
         var _loc2_:LoginFailedException = null;
         var _loc3_:Date = null;
         var _loc4_:String = null;
         this.loginView.busyLoggingIn = false;
         this.clearInlineCredentials();
         this.logger.error(ErrorUtil.grabCodeFromString(param1.errorCode) + "onLoginError()" + param1.errorCode + " " + param1.faultEvent.statusCode);
         if(this.loginMessageResource.isBannedError(param1.errorCode))
         {
            _loc2_ = param1.exception as LoginFailedException;
            _loc3_ = new Date(_loc2_.bannedUntilDate);
            _loc4_ = this.loginMessageResource.getBanOrPermaBanCodeBasedOnExpirationDate(param1.errorCode,_loc2_.bannedUntilDate);
            this.loginView.displayAccountBanned(_loc4_,_loc3_);
         }
         else if(param1.errorCode == "LOGIN-0018")
         {
            this.loginView.displayPasswordResetAlert();
         }
         else if(param1.errorCode == "LOGIN-0019")
         {
            this.loginView.displayBlockedFromPlatformAlert();
         }
         else
         {
            if(param1.errorCode == "LOGIN-0007")
            {
               this.isAllowedToFailover = false;
            }
            this.loginView.displayLoginFailed(param1.errorCode,param1.messageArguments);
         }
         if(this.loginTracker != null)
         {
            this.loginTracker.loginFailedOnError(param1.errorCode);
         }
      }
      
      private function userReconnectedToGame() : void
      {
         this._userHasReconnectedToGame = true;
         this.updateInGameState();
      }
      
      private function onLoginQueueUnavailable() : void
      {
         if(this.loginQueueController.inQueue)
         {
            this.logger.error("9006 Login queue appears unavailable while in-queue!");
            this.discardLoginQueueStatus();
            this.loginView.displayServerBusy();
         }
         else if(this.isAllowedToFailover && Boolean(RiotServiceConfig.instance.fallBackToOldLoginBehavior))
         {
            this.logger.error("9007 Login queue appears unavailable. Failing over to normal login.");
            this.performLogin();
         }
         else
         {
            this.logger.error("9008 Login queue appears unavailable. Cannot fail over.");
            this.loginView.displayAuthFailure(this.retrieveAuthFailure());
         }
      }
      
      private function onAuthSuccess(param1:String, param2:String) : void
      {
         if(this.loginTracker != null)
         {
            this.loginTracker.authenticationSucceeded();
         }
         this.loginQueueMediator.showAuthSuccess();
         this.discardLoginQueueStatus();
         this.authToken = param1;
         this.username = param2;
         this.performLogin();
      }
      
      private function reconnectToGameInProgress(param1:Event) : void
      {
         if(this._inGameCredentials != null && this._inGameCredentials.inGame == true)
         {
            MaestroProviderProxy.instance.getGameClientConnectedToServer().add(this.userReconnectedToGame);
            MaestroProviderProxy.instance.getGameAbandoned().add(this.userDisconnectedFromGame);
            MaestroProviderProxy.instance.getGameCompleted().add(this.userFinishedGame);
            MaestroProviderProxy.instance.getGameCrashed().add(this.userDisconnectedFromGame);
            MaestroProviderProxy.instance.createGame(this._inGameCredentials.serverIp,this._inGameCredentials.serverPort.toString(),this._inGameCredentials.encryptionKey,this._inGameCredentials.playerId.toString());
         }
      }
      
      private function userFinishedGame() : void
      {
         if(this._inGameCredentials != null)
         {
            this._inGameCredentials.inGame = false;
         }
         this.updateInGameState();
      }
      
      private function handleRetryWaitOver(param1:TimerEvent) : void
      {
         this.loginView.retryWaitOver();
      }
      
      private function onRetryAuthenticationTimer(param1:Event = null) : void
      {
         this.authRetryTimer.removeEventListener(TimerEvent.TIMER,this.onRetryAuthenticationTimer);
         this.authRetryTimer.stop();
         this.authRetryTimer = null;
         this.loginQueueController.authenticate(this.inlineCredentials,this.onAuthSuccess,this.onAuthFailed,this.displayLoginQueueStatus,this.inGameHandler);
      }
      
      private function retrieveAuthFailure(param1:FaultEvent = null) : AuthenticationFailureMessage
      {
         var _loc2_:String = null;
         if(param1 != null)
         {
            _loc2_ = param1.fault.content as String;
         }
         return this.loginMessageResource.getAuthFailedMessage(_loc2_);
      }
      
      private function discardLoginQueueStatus() : void
      {
         this.loginQueueMediator.removeEventListener(LoginQueueMediator.EVENT_QUEUE_CANCEL,this.handleLoginQueueCancel);
         this.loginQueueMediator.removeEventListener(LoginQueueMediator.EVENT_QUEUE_SHOW_COUNTDOWN,this.handleLoginQueueShowCountdown);
         this.loginQueueMediator.removeEventListener(LoginQueueMediator.EVENT_QUEUE_REQUEST_POLL,this.handleLoginQueueRequestPoll);
         this.loginQueueMediator.hide();
      }
      
      public function shouldCollectMacAddress() : Boolean
      {
         return RiotServiceConfig.instance.log_mac;
      }
      
      public function loginWithInputFieldCredentials(param1:Function, param2:Function) : void
      {
         this.loginView.busyLoggingIn = true;
         this.proxiedOnFail = param1;
         this.proxiedOnError = param2;
         if(!this.macAddress)
         {
            this.getMacAddress();
         }
         this.callLoginService();
         this.clientConfig.loginUsername = this.username;
         this.loginView.loginAllowed = false;
         this.loginView.onLoginPostQueue();
      }
      
      private function onQueueCancelled() : void
      {
         this.loginView.busyLoggingIn = false;
         this.loginView.onLoginQueueCancelled();
      }
   }
}

