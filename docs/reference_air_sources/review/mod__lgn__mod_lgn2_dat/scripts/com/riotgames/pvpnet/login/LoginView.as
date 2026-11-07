package com.riotgames.pvpnet.login
{
   import blix.action.LoaderAction;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.CheckBoxX;
   import blix.components.button.LabelButtonX;
   import blix.components.loader.ImageX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.module.login.controller.AuthenticationFailureMessage;
   import com.riotgames.platform.gameclient.module.login.event.LoginViewEvent;
   import com.riotgames.platform.gameclient.module.login.view.ILoginQueueView;
   import com.riotgames.platform.gameclient.module.login.view.ILoginView;
   import com.riotgames.platform.gameclient.module.login.view.InitiateLoginEvent;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.tracking.trackers.login.ILoginProcessTracker;
   import com.riotgames.pvpnet.window.IWindowProvider;
   import com.riotgames.rust.focus.RiotFocusManager;
   import com.riotgames.util.logging.getLogger;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Keyboard;
   import mx.logging.ILogger;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LoginView extends StatefulView implements ILoginView
   {
      
      private var backgroundImageRequest:URLRequest;
      
      private var _capsLock:Boolean = false;
      
      private var _stageReference:Stage = null;
      
      private var accountLoginLabel:TextFieldProxy;
      
      private var passwordLabel:TextFieldProxy;
      
      private var _forgotPasswordBtn:LabelButtonX;
      
      private var _passwordInputText:TextFieldProxy;
      
      private var _usernameInputText:TextFieldProxy;
      
      private var _outroComplete:Signal = new Signal();
      
      private var backgroundSWFRequest:URLRequest;
      
      private var _signUpBtn:LabelButtonX;
      
      private var backgroundPartnerImageRequest:URLRequest;
      
      private var loginTracker:ILoginProcessTracker;
      
      protected var logger:ILogger = getLogger(this);
      
      private var rememberUsernameButton:CheckBoxX;
      
      private var isIronChickens:Boolean = false;
      
      private var _loginAnimationHasEmbeddedMusic:Boolean = false;
      
      public var session:Session = Session.instance;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      private var rawAsset:Object;
      
      private var disableMusicButton:CheckBoxX;
      
      private var _termsOfUseBtn:LabelButtonX;
      
      private var _playForFreeBtn:LabelButtonX;
      
      private var usernameLabel:TextFieldProxy;
      
      private var resourceManager:IResourceManager;
      
      private var loginStatusPane:LoginQueueStatusPane;
      
      public var themeWatchPath:String;
      
      private var backgroundImage:ImageX;
      
      private var disableAnimationButton:CheckBoxX;
      
      private var _loginAllowed:Boolean = true;
      
      private var waitingToRetry:Boolean = false;
      
      private var _forgotUserNameBtn:LabelButtonX;
      
      private var _busyLoggingIn:Boolean = false;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      private var loginButton:LabelButtonX;
      
      private var _waitingInQueue:Boolean = false;
      
      public function LoginView(param1:IContext, param2:ILoginProcessTracker)
      {
         super(param1);
         setLinkage("LoginView");
         setCurrentState("showLoginControls");
         this.loginTracker = param2;
      }
      
      public function set loginAllowed(param1:Boolean) : void
      {
         this._loginAllowed = param1;
      }
      
      public function displayAccountBanned(param1:String, param2:Date) : void
      {
         var _loc3_:String = this.resourceManager.getString("Login2","login_loginFailedErrorTitle");
         var _loc4_:String = this.resourceManager.getString("resources",param1,new Array(DateUtil.getDateAndTimeString(param2)));
         if(this.loginTracker)
         {
            this.loginTracker.setLastUserFacingError(param1);
         }
         this.busyLoggingIn = false;
         this.loginStatusPane.getDismissButtonClicked().addOnce(this.onAlertDismissed);
         this.setLoginStatusPaneText(_loc3_,_loc4_);
         this.loginStatusPane.setCurrentState("loginStatus");
      }
      
      private function initLoginControls() : void
      {
         if(UserPreferencesManager.globalPrefs.rememberLogin)
         {
            this._usernameInputText.setText(UserPreferencesManager.globalPrefs.loginName);
            RiotFocusManager.setFocus(this._passwordInputText);
         }
         else
         {
            RiotFocusManager.setFocus(this._usernameInputText);
         }
         this.validateInputState();
      }
      
      public function setBackgroundArt(param1:URLRequest, param2:URLRequest, param3:URLRequest) : void
      {
         this.backgroundImageRequest = param1;
         this.backgroundPartnerImageRequest = param2;
         this.backgroundSWFRequest = param3;
         this.updateBackgroundImage();
      }
      
      public function onLoginQueueEntered() : void
      {
         this.waitingInQueue = true;
      }
      
      private function onBlockedAlertDismissed(param1:AlertAction) : void
      {
         var _loc2_:IWindowProvider = ProviderLookup.getProviderProxy(IWindowProvider);
         _loc2_.exit();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.backgroundImage = new ImageX(this);
         setTimelineChildByName("backgroundHolder",this.backgroundImage);
         this.accountLoginLabel = new TextFieldProxy(this);
         setTimelineChildByName("accountLoginLabel",this.accountLoginLabel);
         this.usernameLabel = new TextFieldProxy(this);
         setTimelineChildByName("usernameLabel",this.usernameLabel);
         this._usernameInputText = new TextFieldProxy(this);
         setTimelineChildByName("usernameInputText",this._usernameInputText);
         this.passwordLabel = new TextFieldProxy(this);
         setTimelineChildByName("passwordLabel",this.passwordLabel);
         this._passwordInputText = new TextFieldProxy(this);
         setTimelineChildByName("passwordInputText",this._passwordInputText);
         this.rememberUsernameButton = new CheckBoxX(this);
         setTimelineChildByName("rememberUsername",this.rememberUsernameButton);
         this.rememberUsernameButton.addEventListener(KeyboardEvent.KEY_DOWN,this.onCheckboxKeyPressed,false,0,true);
         this.loginButton = new LabelButtonX(this);
         setTimelineChildByName("loginButton",this.loginButton);
         this._signUpBtn = new LabelButtonX(this);
         setTimelineChildByName("signUpButton",this._signUpBtn);
         this._forgotUserNameBtn = new LabelButtonX(this);
         setTimelineChildByName("forgotUsernameButton",this._forgotUserNameBtn);
         this._forgotPasswordBtn = new LabelButtonX(this);
         setTimelineChildByName("forgotPasswordButton",this._forgotPasswordBtn);
         this._playForFreeBtn = new LabelButtonX(this);
         setTimelineChildByName("playForFreeButton",this._playForFreeBtn);
         this._termsOfUseBtn = new LabelButtonX(this);
         setTimelineChildByName("termsOfUseButton",this._termsOfUseBtn);
         this.disableMusicButton = new CheckBoxX(this);
         setTimelineChildByName("disableMusic",this.disableMusicButton);
         this.disableAnimationButton = new CheckBoxX(this);
         this.disableAnimationButton.setText("Disable Animation");
         setTimelineChildByName("disableAnimation",this.disableAnimationButton);
         this.loginStatusPane = new LoginQueueStatusPane(this);
         setTimelineChildByName("loginStatusPane",this.loginStatusPane);
         this.resourcesChangedHandler();
         this.initializeListenersAndState();
      }
      
      public function retryWaitStart(param1:int) : void
      {
         this.loginButton.setText(String(param1));
         this.waitingToRetry = true;
         this.validateButtonState();
      }
      
      private function isOnStageChangedHandler() : void
      {
         if(this._isOnStage)
         {
            this._stageReference = this.getStage();
            this._stageReference.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onShellMinimizeChange,false,0,true);
            this._stageReference.addEventListener(KeyboardEvent.KEY_DOWN,this.onInputEnterPressed,true,0,true);
         }
         else if(this._stageReference != null)
         {
            this._stageReference.nativeWindow.removeEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.onShellMinimizeChange,false);
            this._stageReference.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInputEnterPressed,true);
            this._stageReference = null;
         }
      }
      
      private function initiateLoginSequence(param1:Event = null) : void
      {
         if(!this.loginButton.getEnabled() && this.clientConfig.partnerCredentials == null)
         {
            return;
         }
         dispatchEvent(new InitiateLoginEvent(this._usernameInputText.getText(),this._passwordInputText.getText()));
      }
      
      private function outroCompleteListener(param1:Event) : void
      {
         this._outroComplete.dispatch();
      }
      
      public function onLoginPreQueue() : void
      {
         if(this.clientConfig.partnerCredentials == null)
         {
            this._passwordInputText.setText("");
            this.loginStatusPane.setCurrentState("loginBusy");
            this.setLoginStatusPaneText(this.resourceManager.getString("Login2","login_status_title"),this.resourceManager.getString("Login2","login_status_login_begin"));
         }
      }
      
      public function prepareForLogin() : void
      {
         if(this.clientConfig.partnerCredentials == null)
         {
            this.toggleLoginElements(true);
            this.initLoginControls();
         }
         else
         {
            this.toggleLoginElements(false);
            this.initiateLoginSequence();
         }
      }
      
      public function displayServerBusy() : void
      {
         this.logger.error("0002 displayServerBusy()");
         var _loc1_:String = this.resourceManager.getString("Login2","login_loginFailedErrorTitle");
         var _loc2_:String = this.resourceManager.getString("Login2","login_serverBusy");
         if(this.loginTracker)
         {
            this.loginTracker.setLastUserFacingError("login_serverBusy");
         }
         this.busyLoggingIn = false;
         this.loginStatusPane.getDismissButtonClicked().addOnce(this.onAlertDismissed);
         this.setLoginStatusPaneText(_loc1_,_loc2_);
         this.loginStatusPane.setCurrentState("loginStatus");
      }
      
      private function onCheckboxKeyPressed(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE && this.rememberUsernameButton.getAsset() != null)
         {
            this.rememberUsernameButton.getAsset().dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         else if(param1.keyCode == Keyboard.ENTER)
         {
            this.validateInputState();
            this.initiateLoginSequence();
         }
      }
      
      private function onBackgroundImageLoadComplete(param1:LoaderAction) : void
      {
         trace("Login.onBackgroundImageLoadComplete");
         if(this.clientConfig.partnerCredentials == null)
         {
            this.playLoginMusic();
         }
         this.setSwfAudioMute();
      }
      
      private function getGlobalPreference(param1:String) : Object
      {
         var _loc2_:Object = null;
         if(UserPreferencesManager.globalPrefs.hasOwnProperty(param1))
         {
            _loc2_ = UserPreferencesManager.globalPrefs[param1];
         }
         return _loc2_;
      }
      
      private function setSwfAudioMute() : void
      {
         if(this.backgroundImage.getAsset() != null && this.backgroundImage.getAsset() is MovieClip)
         {
            this.soundManager.applyVolumeToMovieClip(this.backgroundImage.getAsset() as MovieClip);
         }
         if(this.rawAsset != null && this.rawAsset.hasOwnProperty("defaultVolumeSetter"))
         {
            this.rawAsset.defaultVolumeSetter(this.soundManager.getMusicMute(),UserPreferencesManager.globalPrefs.musicVolume);
         }
      }
      
      private function setGlobalPreference(param1:String, param2:Object = null) : void
      {
         if(UserPreferencesManager.globalPrefs.hasOwnProperty(param1))
         {
            UserPreferencesManager.globalPrefs[param1] = param2;
            UserPreferencesManager.instance.saveGlobalPreferences();
         }
      }
      
      public function outroComplete() : ISignal
      {
         return this._outroComplete;
      }
      
      public function displayLoginStatusText(param1:String, param2:String) : void
      {
         this.setLoginStatusPaneText(param1,param2);
      }
      
      private function onAlertDismissed() : void
      {
         this.busyLoggingIn = false;
         this.loginStatusPane.setCurrentState("hidden");
         RiotFocusManager.setFocus(this._passwordInputText,true);
         this.validateInputState();
      }
      
      public function displayBlockedFromPlatformAlert() : void
      {
         CursorManager.getInstance().removeBusyCursor();
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","partnerBetaBlocked_title"),_loc1_.getString("resources","partnerBetaBlocked_message"));
         _loc2_.getCompleted().addOnce(this.onBlockedAlertDismissed);
         _loc2_.add();
      }
      
      private function onDisableMusicChanged() : void
      {
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_MUTE_LOGIN_MUSIC,this.disableMusicButton.getSelected().toString()));
         if(this._loginAnimationHasEmbeddedMusic)
         {
            this.soundManager.toggleMuteLocalMusicOnAnimationEnabledToggle(UserPreferencesManager.globalPrefs.enableAnimations);
         }
         this.setSwfAudioMute();
      }
      
      public function retryWaitTick(param1:int) : void
      {
         this.loginButton.setText(String(param1));
      }
      
      private function resourcesChangedHandler(param1:Event = null) : void
      {
         this.accountLoginLabel.setText(this.resourceManager.getString("Login2","login_loginLabel"));
         this.usernameLabel.setText(this.resourceManager.getString("Login2","login_usernameLabel"));
         this.updatePasswordLabel();
         this.rememberUsernameButton.setText(this.resourceManager.getString("Login2","login_checkbox_rememberUsername"));
         this.loginButton.setText(this.resourceManager.getString("Login2","login_loginButtonLabel"));
         this.disableMusicButton.setText(this.resourceManager.getString("Login2","preferences_loginMusicToggleLabel"));
         this.disableAnimationButton.setText(this.resourceManager.getString("Login2","preferences_transitionsFilterLabel"));
         this._signUpBtn.textField.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_linkNoAccountSignUp") + "</font>");
         this._forgotUserNameBtn.textField.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_linkForgotUsername") + "</font>");
         this._forgotPasswordBtn.textField.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_linkForgotPassword") + "</font>");
         this._playForFreeBtn.textField.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_linkPlayForFreeAndSignUp") + "</font>");
         this._termsOfUseBtn.textField.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","footer_termsAndConditions") + "</font>");
         assignToolTip(this.loginButton,this.resourceManager.getString("Login2","login_loginButton_tooltip"));
         assignToolTip(this.disableAnimationButton,this.resourceManager.getString("Login2","preferences_transitionsFilterTooltip"));
      }
      
      private function onImageLoadError(param1:LoaderAction) : void
      {
         this.logger.error("0001 Could not load background: " + param1.getError().toString());
      }
      
      private function onCreateAccountLinkClicked(param1:MouseEvent) : void
      {
         if(this.busyLoggingIn)
         {
            return;
         }
         navigateToURL(new URLRequest(this.resourceManager.getString("Login2","createAccountURL")));
      }
      
      private function onTermsOfUseLinkClicked(param1:MouseEvent) : void
      {
         if(this.busyLoggingIn)
         {
            return;
         }
         navigateToURL(new URLRequest(this.resourceManager.getString("Login2","legalURL")));
      }
      
      public function getLoginStatusPane() : ILoginQueueView
      {
         return this.loginStatusPane;
      }
      
      private function toggleLoginElements(param1:Boolean) : void
      {
         if(param1)
         {
            setCurrentState("showLoginControls");
         }
         else
         {
            setCurrentState("hideLoginControls");
         }
      }
      
      public function validateButtonState() : Boolean
      {
         var _loc1_:Boolean = !this.busyLoggingIn && (this._usernameInputText.getText() != null && this._usernameInputText.getText().length > 0) && (this._passwordInputText.getText() != null && this._passwordInputText.getText().length > 0) && this.loginAllowed && !this.waitingToRetry;
         this.loginButton.setEnabled(_loc1_);
         this.loginButton.setUseHandCursor(_loc1_);
         return _loc1_;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.resourceManager = ResourceManager.getInstance();
         this.resourceManager.addEventListener(Event.CHANGE,this.resourcesChangedHandler,false,0,true);
      }
      
      public function displayAuthFailure(param1:AuthenticationFailureMessage) : void
      {
         var _loc4_:String = null;
         var _loc5_:ClientConfig = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc2_:String = this.resourceManager.getString("Login2","login_loginFailedErrorTitle");
         var _loc3_:String = null;
         if(param1.isBannedError)
         {
            _loc4_ = DateUtil.getDateString(new Date(param1.expire));
            _loc3_ = this.resourceManager.getString("Login2",param1.localeCode,[_loc4_]);
            if(this.loginTracker)
            {
               this.loginTracker.setLastUserFacingError(param1.localeCode);
            }
         }
         else if(param1.isRetryWait)
         {
            _loc3_ = this.resourceManager.getString("Login2",param1.localeCode,[param1.retryWait]);
            if(this.loginTracker)
            {
               this.loginTracker.setLastUserFacingError(param1.localeCode);
            }
         }
         else if(param1.isAccountTransferred)
         {
            _loc3_ = this.resourceManager.getString("Login2","login_failed_transferred_restart");
            if(this.loginTracker)
            {
               this.loginTracker.setLastUserFacingError("login_failed_transferred_restart");
            }
         }
         else
         {
            _loc5_ = ClientConfig.instance;
            _loc6_ = _loc5_.regionTag;
            _loc7_ = _loc5_.currentLocale.language;
            _loc3_ = this.resourceManager.getString("Login2",param1.localeCode,[_loc6_,_loc7_]);
            if(this.loginTracker)
            {
               this.loginTracker.setLastUserFacingError(param1.localeCode);
            }
         }
         this.busyLoggingIn = false;
         this.loginStatusPane.getDismissButtonClicked().addOnce(this.onAlertDismissed);
         this.loginStatusPane.setCurrentState("loginStatus");
         this.setLoginStatusPaneText(_loc2_,_loc3_);
      }
      
      private function onForgotUsernameButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = this.clientConfig.localePrefix;
         var _loc3_:String = this.resourceManager.getString("Login2","recoverUsernameURL",[this.clientConfig.regionTag,_loc2_]);
         navigateToURL(new URLRequest(_loc3_));
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this;
      }
      
      private function initializeListenersAndState() : void
      {
         this._usernameInputText.setMaxChars(30);
         this._passwordInputText.setMaxChars(30);
         this._passwordInputText.setDisplayAsPassword(true);
         this._passwordInputText.addEventListener(Event.CHANGE,this.onInputTextChange,false,0,true);
         this._usernameInputText.addEventListener(Event.CHANGE,this.onInputTextChange,false,0,true);
         this.rememberUsernameButton.setSelected(UserPreferencesManager.globalPrefs.rememberLogin);
         this.rememberUsernameButton.getSelectedChanged().add(this.onRememberUsernameChanged);
         this.loginButton.addEventListener(MouseEvent.CLICK,this.initiateLoginSequence,false,0,true);
         this._signUpBtn.addEventListener(MouseEvent.CLICK,this.onCreateAccountLinkClicked,false,0,true);
         this._forgotUserNameBtn.addEventListener(MouseEvent.CLICK,this.onForgotUsernameButtonClicked,false,0,true);
         this._forgotPasswordBtn.addEventListener(MouseEvent.CLICK,this.onForgotPasswordButtonClicked,false,0,true);
         this._playForFreeBtn.addEventListener(MouseEvent.CLICK,this.onCreateAccountLinkClicked,false,0,true);
         this._termsOfUseBtn.addEventListener(MouseEvent.CLICK,this.onTermsOfUseLinkClicked,false,0,true);
         this.disableAnimationButton.getSelectedChanged().add(this.onDisableAnimsChanged);
         this.disableAnimationButton.setSelected(!UserPreferencesManager.globalPrefs.enableAnimations);
         this.disableMusicButton.getSelectedChanged().add(this.onDisableMusicChanged);
         this.disableMusicButton.setSelected(UserPreferencesManager.globalPrefs.loginMusicMute);
         this.addEventListener(Event.ENTER_FRAME,this.onCapslockPoll,false,0,true);
         this.getIsOnStageChanged().add(this.isOnStageChangedHandler);
      }
      
      public function displayPasswordResetAlert() : void
      {
         var _loc1_:AlertAction = new AlertAction(this.resourceManager.getString("Login2","LOGIN-0018_Title"),this.resourceManager.getString("Login2","LOGIN-0018",[this.clientConfig.regionTag]));
         _loc1_.getCompleted().add(this.onPasswordResetAlertDismissed);
         _loc1_.add();
      }
      
      private function validateInputState() : void
      {
         this._usernameInputText.setSelectable(!this.busyLoggingIn && this.loginAllowed);
         this._passwordInputText.setSelectable(!this.busyLoggingIn && this.loginAllowed);
         this.validateButtonState();
      }
      
      public function retryWaitOver() : void
      {
         this.loginButton.setText(this.resourceManager.getString("Login2","login_loginButtonLabel"));
         this.waitingToRetry = false;
         this.validateButtonState();
      }
      
      private function playLoginMusic() : void
      {
         this.soundManager.playLoginMusic();
      }
      
      public function onLoginPostQueue() : void
      {
         this.waitingInQueue = false;
         if(this.clientConfig.partnerCredentials == null)
         {
            this.soundManager.play(AudioKeys.SOUND_LOGIN_OK_BUTTON_CLICK);
            this.validateInputState();
         }
      }
      
      private function onDisableAnimsChanged() : void
      {
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_ENABLE_ANIMATIONS,(!this.disableAnimationButton.getSelected()).toString()));
         this.loginStatusPane.setTransitionsEnabled(UserPreferencesManager.globalPrefs.enableAnimations);
         this.updateBackgroundImage();
      }
      
      public function set waitingInQueue(param1:Boolean) : void
      {
         this._waitingInQueue = param1;
         this.setLoginControlEnabledStatus(!this._busyLoggingIn && !this._waitingInQueue);
      }
      
      public function onLoginQueueCancelled() : void
      {
         this._passwordInputText.setText("");
         this.busyLoggingIn = false;
         this.waitingInQueue = false;
         this.validateInputState();
      }
      
      private function onInputTextChange(param1:Event) : void
      {
         this.validateInputState();
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_LOGINNAME,this._usernameInputText.getText()));
      }
      
      private function updatePasswordLabel() : void
      {
         if(this._capsLock)
         {
            this.passwordLabel.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_passwordLabelCapsWarning") + "</font>");
         }
         else
         {
            this.passwordLabel.setHtmlText("<font face=\'ApplicationFont2\'>" + this.resourceManager.getString("Login2","login_passwordLabel") + "</font>");
         }
      }
      
      public function setInGame(param1:Boolean) : void
      {
         this.loginStatusPane.setInGame(param1);
         this.loginStatusPane.getReconnectClicked().add(this.reconnectClicked);
      }
      
      private function onRememberUsernameChanged() : void
      {
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_REMEMBER_LOGINNAME,this.rememberUsernameButton.getSelected().toString()));
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_LOGINNAME,this._usernameInputText.getText()));
      }
      
      private function updateBackgroundImage() : void
      {
         if(this.backgroundImageRequest != null && this.backgroundSWFRequest != null)
         {
            this.backgroundImage.getErred().remove(this.onImageLoadError);
            this.isIronChickens = false;
            this.backgroundImage.getLoader().loaderAction.loader.contentLoaderInfo.addEventListener(Event.INIT,this.contentInitHandler);
            this.backgroundImage.getCompleted().remove(this.onBackgroundImageLoadComplete);
            if(this.rawAsset != null && this.rawAsset.hasOwnProperty("destroy"))
            {
               this.rawAsset.destroy();
            }
            this.backgroundImage.unloadAndStop(true);
            this.backgroundImage.getCompleted().add(this.onBackgroundImageLoadComplete);
            this.backgroundImage.getErred().add(this.onImageLoadError);
            if(this.clientConfig.partnerCredentials == null)
            {
               if(UserPreferencesManager.globalPrefs.enableAnimations)
               {
                  this.backgroundImage.load(this.backgroundSWFRequest);
               }
               else
               {
                  this.backgroundImage.load(this.backgroundImageRequest);
               }
            }
            else
            {
               this.backgroundImage.load(this.backgroundPartnerImageRequest);
            }
         }
      }
      
      public function get passwordInputText() : TextFieldProxy
      {
         return this._passwordInputText;
      }
      
      private function setLoginStatusPaneText(param1:String, param2:String) : void
      {
         this.loginStatusPane.updateLoginStatusText(param1,param2);
      }
      
      public function set busyLoggingIn(param1:Boolean) : void
      {
         var _loc2_:IResourceManager = null;
         this._busyLoggingIn = param1;
         if(param1)
         {
            CursorManager.getInstance().setBusyCursor();
            _loc2_ = ResourceManager.getInstance();
         }
         else
         {
            CursorManager.getInstance().removeBusyCursor();
            CursorManager.getInstance().removeAllCursors();
         }
         this.setLoginControlEnabledStatus(!this._busyLoggingIn && !this._waitingInQueue);
      }
      
      public function onLoginSuccess() : void
      {
         this.soundManager.stopBackgroundMusic();
         if(this.isIronChickens && this.rawAsset != null)
         {
            this.rawAsset.gotoAndPlay(2);
            this.rawAsset.addEventListener("outroComplete",this.outroCompleteListener);
         }
         else
         {
            this._outroComplete.dispatch();
         }
         if(this.session.isLoggedIn)
         {
            this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_REMEMBER_LOGINNAME,this.rememberUsernameButton.getSelected().toString()));
            this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.UPDATE_LOGINNAME,this._usernameInputText.getText()));
            UserPreferencesManager.instance.saveGlobalPreferences();
         }
      }
      
      private function onShellMinimizeChange(param1:NativeWindowDisplayStateEvent) : void
      {
         this.setSwfAudioMute();
         if(this._loginAnimationHasEmbeddedMusic)
         {
            this.soundManager.toggleMuteLocalMusicOnAnimationEnabledToggle(Boolean(UserPreferencesManager.globalPrefs.enableAnimations) || Boolean(this.soundManager.getMusicMute()));
         }
      }
      
      public function get usernameInputText() : TextFieldProxy
      {
         return this._usernameInputText;
      }
      
      private function onPasswordResetAlertDismissed(param1:*) : void
      {
         navigateToURL(new URLRequest(this.resourceManager.getString("Login2","LOGIN-0018_PromptURL",[this.clientConfig.regionTag])));
         this.onAlertDismissed();
      }
      
      public function get waitingInQueue() : Boolean
      {
         return this._waitingInQueue;
      }
      
      private function onCapslockPoll(param1:Event) : void
      {
         if(this._capsLock != Keyboard.capsLock)
         {
            this._capsLock = Keyboard.capsLock;
            this.updatePasswordLabel();
         }
      }
      
      public function get busyLoggingIn() : Boolean
      {
         return this._busyLoggingIn;
      }
      
      private function contentInitHandler(param1:Event) : void
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:int = 0;
         trace("content InitHandler " + param1.target);
         if(Boolean(param1) && Boolean(param1.target) && Boolean(param1.target.content))
         {
            this.rawAsset = param1.target.content;
            if(this.rawAsset.hasOwnProperty("getGlobalPreference"))
            {
               this.rawAsset.getGlobalPreference = this.getGlobalPreference;
            }
            if(this.rawAsset.hasOwnProperty("setGlobalPreference"))
            {
               this.rawAsset.setGlobalPreference = this.setGlobalPreference;
            }
            if(this.rawAsset.hasOwnProperty("themeWatchPath"))
            {
               this.rawAsset.themeWatchPath = this.themeWatchPath;
            }
            if(this.rawAsset.hasOwnProperty("ironChickens"))
            {
               this.isIronChickens = this.rawAsset.ironChickens;
            }
            if(this.rawAsset.hasOwnProperty("applyVolumeToMovieClip"))
            {
               this.rawAsset.applyVolumeToMovieClip = this.soundManager.applyVolumeToMovieClip;
            }
            if(this.rawAsset.hasOwnProperty("setLang"))
            {
               this.rawAsset.setLang(ClientConfig.instance.locale);
            }
            if(this.rawAsset.hasOwnProperty("loginAnimationHasEmbeddedMusic"))
            {
               this._loginAnimationHasEmbeddedMusic = this.rawAsset.loginAnimationHasEmbeddedMusic;
            }
            else
            {
               this._loginAnimationHasEmbeddedMusic = true;
            }
            if(this._loginAnimationHasEmbeddedMusic)
            {
               this.soundManager.toggleMuteLocalMusicOnAnimationEnabledToggle(UserPreferencesManager.globalPrefs.enableAnimations);
            }
            if(this.rawAsset.hasOwnProperty("setRandomStringData"))
            {
               _loc2_ = new Vector.<String>();
               _loc3_ = 0;
               while(_loc3_ < 16)
               {
                  _loc2_.push(RiotResourceLoader.getString("login_janna_newsfeed_" + _loc3_));
                  _loc3_++;
               }
               _loc2_.push(RiotResourceLoader.getString("breaking_news_title"));
               _loc2_.push(RiotResourceLoader.getString("live_news"));
               this.rawAsset.setRandomStringData(_loc2_);
            }
            this.setSwfAudioMute();
            this.backgroundImage.getLoader().loaderAction.loader.contentLoaderInfo.removeEventListener(Event.INIT,this.contentInitHandler);
         }
      }
      
      private function reconnectClicked() : void
      {
         this.dispatcher.dispatchEvent(new LoginViewEvent(LoginViewEvent.RECONNECT_TO_GAME));
      }
      
      public function displayLoginFailed(param1:String, param2:Array) : void
      {
         if(param1 == null)
         {
            param1 = "login_failed_unknown";
            param2 = [this.clientConfig.regionTag,this.clientConfig.localePrefix];
         }
         var _loc3_:String = this.resourceManager.getString("Login2","login_loginFailedErrorTitle");
         var _loc4_:String = this.resourceManager.getString("Login2",param1,param2);
         if(_loc4_ == null || _loc4_ == "null")
         {
            this.logger.error("0003 failed to look up an error code from the platform: " + param1);
            _loc4_ = this.resourceManager.getString("Login2","GEN-0006");
            if(this.loginTracker)
            {
               this.loginTracker.setLastUserFacingError("GEN-0006");
            }
         }
         else if(this.loginTracker)
         {
            this.loginTracker.setLastUserFacingError(param1);
         }
         this.busyLoggingIn = false;
         this.loginStatusPane.getDismissButtonClicked().addOnce(this.onAlertDismissed);
         this.setLoginStatusPaneText(_loc3_,_loc4_);
         this.loginStatusPane.setCurrentState("loginStatus");
      }
      
      private function onInputEnterPressed(param1:KeyboardEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         if(param1.keyCode == Keyboard.ENTER)
         {
            _loc2_ = param1.target as DisplayObject;
            _loc3_ = this.loginStatusPane.getAsset();
            while(_loc2_.parent != null)
            {
               if(_loc2_ == _loc3_)
               {
                  return;
               }
               _loc2_ = _loc2_.parent;
            }
            this.validateInputState();
            this.initiateLoginSequence();
            param1.stopPropagation();
         }
      }
      
      private function onForgotPasswordButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = this.clientConfig.localePrefix;
         var _loc3_:String = this.resourceManager.getString("Login2","recoverPasswordURL",[this.clientConfig.regionTag,_loc2_]);
         navigateToURL(new URLRequest(_loc3_));
      }
      
      override public function destroy() : void
      {
         if(this.rawAsset != null && this.rawAsset.hasOwnProperty("applyVolumeToMovieClip"))
         {
            if(this.rawAsset.hasOwnProperty("destroy"))
            {
               this.rawAsset.destroy();
            }
            this.rawAsset.applyVolumeToMovieClip = null;
            this.rawAsset = null;
         }
         this.backgroundImage.getErred().remove(this.onImageLoadError);
         this.backgroundImage.getCompleted().remove(this.onBackgroundImageLoadComplete);
         this.backgroundImage.unloadAndStop(true);
         this.soundManager.stopLoginMusic();
         this.resourceManager.removeEventListener(Event.CHANGE,this.resourcesChangedHandler);
         removeEventListener(Event.ENTER_FRAME,this.onCapslockPoll);
         super.destroy();
      }
      
      private function setLoginControlEnabledStatus(param1:Boolean) : void
      {
         this._usernameInputText.setSelectable(param1);
         this._passwordInputText.setSelectable(param1);
         this.validateButtonState();
      }
      
      public function get loginAllowed() : Boolean
      {
         return this._loginAllowed;
      }
   }
}

