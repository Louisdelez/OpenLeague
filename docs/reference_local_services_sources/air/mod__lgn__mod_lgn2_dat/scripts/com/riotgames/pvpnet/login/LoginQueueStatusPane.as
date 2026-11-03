package com.riotgames.pvpnet.login
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.module.login.controller.LoginQueueController;
   import com.riotgames.platform.gameclient.module.login.view.ILoginQueueView;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LoginQueueStatusPane extends StatefulView implements ILoginQueueView
   {
      
      private var messageTextArea:TextFieldProxy;
      
      private var titleLabel:TextFieldProxy;
      
      private var updateHandshakeCallback:Function;
      
      private var isCappedKey:String;
      
      private var delayingLoginQueueShow:Boolean = false;
      
      private var dismissButtonClicked:Signal = new Signal();
      
      private var inGameTextArea:TextFieldProxy;
      
      private var positionCheckInDisplay:SpriteProxy;
      
      private var resourceManager:IResourceManager;
      
      private var showingLoginQueue:Boolean = false;
      
      private var reconnectClicked:Signal = new Signal();
      
      private var quitQueueButton:LabelButtonX;
      
      private var dismissButton:LabelButtonX;
      
      private var quitQueueCallback:Function;
      
      private var reconnectButton:LabelButtonX;
      
      private var showLoginQueueDelayTimer:Timer;
      
      private var _isInGame:Boolean;
      
      private var positionCheckInLabel:TextFieldProxy;
      
      public function LoginQueueStatusPane(param1:IContext)
      {
         super(param1);
         this.setCurrentState("hidden");
      }
      
      public function showAuthSuccess() : void
      {
         this.setCurrentState("loginBusy");
         this.updateLoginStatusText(this.resourceManager.getString("Login2","login_status_title"),this.resourceManager.getString("Login2","login_status_auth_successful_postqueue"));
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.resourceManager.removeEventListener(Event.CHANGE,this.resourcesChangedHandler);
      }
      
      public function updateLoginQueueViewForHours(param1:Number, param2:int, param3:int, param4:int) : void
      {
         this.updateLoginQueueText(param1,param2,param3 + " " + ResourceManager.getInstance().getString("resources","common_time_hours_short") + " " + param4 + ResourceManager.getInstance().getString("resources","common_time_minutes_short"));
      }
      
      public function updateLoginQueueViewForMinutes(param1:Number, param2:int, param3:int, param4:int) : void
      {
         this.updateLoginQueueText(param1,param2,param3 + " " + ResourceManager.getInstance().getString("resources","common_time_minutes_short") + " " + param4 + ResourceManager.getInstance().getString("resources","common_time_seconds_short"));
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.resourceManager = ResourceManager.getInstance();
         this.resourceManager.addEventListener(Event.CHANGE,this.resourcesChangedHandler);
      }
      
      public function get showingLoginQueueView() : Boolean
      {
         return this.showingLoginQueue;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.titleLabel = new TextFieldProxy(this);
         setTimelineChildByName("titleLabel",this.titleLabel);
         this.positionCheckInLabel = new TextFieldProxy(this);
         setTimelineChildByName("positionCheckInLabel",this.positionCheckInLabel);
         this.positionCheckInDisplay = new SpriteProxy(this);
         setTimelineChildByName("positionCheckInDisplay",this.positionCheckInDisplay);
         this.messageTextArea = new TextFieldProxy(this);
         setTimelineChildByName("messageTextArea",this.messageTextArea);
         this.quitQueueButton = new LabelButtonX(this);
         setTimelineChildByName("quitQueueButton",this.quitQueueButton);
         this.dismissButton = new LabelButtonX(this);
         setTimelineChildByName("dismissButton",this.dismissButton);
         this.dismissButton.addEventListener(MouseEvent.CLICK,this.onDismissButtonClicked);
         this.inGameTextArea = new TextFieldProxy(this);
         setTimelineChildByName("inGameMessageText",this.inGameTextArea);
         this.reconnectButton = new LabelButtonX(this);
         setTimelineChildByName("reconnectButton",this.reconnectButton);
         this.reconnectButton.addEventListener(MouseEvent.CLICK,this.onReconnectClicked);
         this.resourcesChangedHandler();
      }
      
      private function getTimeRemainingUpdate(param1:Event) : void
      {
         this.updateHandshakeCallback();
      }
      
      private function updateLoginQueueText(param1:Number, param2:int, param3:String) : void
      {
         var _loc4_:String = null;
         if(!this.delayingLoginQueueShow)
         {
            this.drawPieGraphics(this.positionCheckInDisplay.getGraphics(),param1);
            _loc4_ = this.getQueueDepthString(param2);
            this.messageTextArea.setHtmlText("<font face=\'ApplicationFont2\'>" + ResourceManager.getInstance().getString("Login2",this.isCappedKey,[_loc4_,param3]) + "</font>");
         }
      }
      
      private function setReconnectButtonEnabled(param1:Boolean) : void
      {
         if(this.reconnectButton != null)
         {
            this.reconnectButton.setEnabled(param1);
         }
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         if(param1 == "loginQueue")
         {
            RiotFocusManager.setFocus(this.quitQueueButton);
         }
         else if(param1 != "hidden")
         {
            RiotFocusManager.setFocus(this.dismissButton);
         }
      }
      
      private function onDismissButtonClicked(param1:Event = null) : void
      {
         this.dismissButtonClicked.dispatch();
      }
      
      public function updateLoginQueueViewForSeconds(param1:Number, param2:int, param3:int) : void
      {
         this.updateLoginQueueText(param1,param2,param3 + " " + ResourceManager.getInstance().getString("resources","common_time_seconds_long"));
      }
      
      public function getDismissButtonClicked() : ISignal
      {
         return this.dismissButtonClicked;
      }
      
      public function getReconnectClicked() : ISignal
      {
         return this.reconnectClicked;
      }
      
      public function showLoginQueueView(param1:Boolean, param2:Function, param3:Function) : void
      {
         if(this.showingLoginQueue)
         {
            return;
         }
         this.showLoginQueueDelayTimer = new Timer(2000,1);
         this.showLoginQueueDelayTimer.addEventListener(TimerEvent.TIMER,this.onShowQueueDelayTimer,false,0,true);
         this.showLoginQueueDelayTimer.start();
         this.delayingLoginQueueShow = true;
         this.showingLoginQueue = true;
         this.isCappedKey = param1 ? "login_queue_dialog" : "login_queue_momentary";
         this.updateHandshakeCallback = param2;
         this.quitQueueCallback = param3;
         this.quitQueueButton.addEventListener(MouseEvent.CLICK,this.onQuitButtonClicked,false,0,true);
         addEventListener(Event.ENTER_FRAME,this.getTimeRemainingUpdate,false,0,true);
      }
      
      private function onReconnectClicked(param1:MouseEvent) : void
      {
         this.reconnectClicked.dispatch(this);
         this.setReconnectButtonEnabled(false);
      }
      
      private function drawPieGraphics(param1:Graphics, param2:Number) : void
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(!param1)
         {
            return;
         }
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 15;
         var _loc6_:uint = 0;
         var _loc7_:uint = 16777215;
         var _loc8_:Number = 1;
         var _loc9_:Number = 0.2;
         param1.clear();
         param1.lineStyle();
         param1.beginFill(_loc6_);
         param1.drawCircle(_loc3_,_loc4_,_loc5_);
         param1.endFill();
         _loc5_ -= _loc8_;
         var _loc10_:Number = param2 * Math.PI * 2 - 0.5 * Math.PI;
         param1.moveTo(_loc3_,_loc4_);
         param1.beginFill(_loc7_);
         param1.lineTo(_loc3_,_loc4_ - _loc5_);
         var _loc11_:Number = Math.PI * 1.5;
         var _loc12_:Boolean = false;
         var _loc13_:Number = Math.PI * 1.5 - _loc9_;
         while(!_loc12_)
         {
            if(_loc13_ <= _loc10_)
            {
               _loc13_ = _loc10_;
               _loc12_ = true;
            }
            _loc14_ = _loc5_ * Math.cos(_loc13_);
            _loc15_ = _loc5_ * Math.sin(_loc13_);
            _loc16_ = _loc5_ * (Math.cos(_loc11_) - Math.cos(_loc13_)) / (Math.sin(_loc13_) + Math.sin(_loc11_));
            _loc17_ = _loc14_ + _loc16_ * Math.sin(_loc13_);
            _loc18_ = _loc15_ - _loc16_ * Math.cos(_loc13_);
            param1.curveTo(_loc3_ + _loc17_,_loc4_ + _loc18_,_loc3_ + _loc14_,_loc4_ + _loc15_);
            _loc11_ = _loc13_;
            _loc13_ -= _loc9_;
         }
         param1.lineTo(_loc3_,_loc4_);
         param1.endFill();
      }
      
      private function onShowQueueDelayTimer(param1:TimerEvent) : void
      {
         this.showLoginQueueDelayTimer.removeEventListener(TimerEvent.TIMER,this.onShowQueueDelayTimer);
         this.showLoginQueueDelayTimer.stop();
         this.showLoginQueueDelayTimer = null;
         this.delayingLoginQueueShow = false;
         this.titleLabel.setText(this.resourceManager.getString("Login2","login_queue_title"));
         this.positionCheckInLabel.setText(this.resourceManager.getString("Login2","login_queue_refreshTimerLabel"));
         this.messageTextArea.setText(this.resourceManager.getString("Login2","login_queue_dialog"));
         if(!this._isInGame)
         {
            this.setCurrentState("loginQueue");
         }
         else
         {
            this.setCurrentState("loginQueueInGame");
            this.setReconnectButtonEnabled(true);
         }
      }
      
      private function getQueueDepthString(param1:int) : String
      {
         if(param1 > LoginQueueController.MAX_POSITION)
         {
            return ResourceManager.getInstance().getString("Login2","login_queue_max_depth",[LoginQueueController.MAX_POSITION]);
         }
         return param1.toString();
      }
      
      public function setInGame(param1:Boolean) : void
      {
         this._isInGame = param1;
         if(param1 && _currentState == "loginQueue")
         {
            this.setCurrentState("loginQueueInGame");
            this.setReconnectButtonEnabled(true);
         }
         else if(!param1 && _currentState == "loginQueueInGame")
         {
            this.setCurrentState("loginQueue");
         }
      }
      
      public function hideLoginQueueView() : void
      {
         if(this.showLoginQueueDelayTimer != null)
         {
            this.showLoginQueueDelayTimer.removeEventListener(TimerEvent.TIMER,this.onShowQueueDelayTimer);
            this.showLoginQueueDelayTimer.stop();
            this.showLoginQueueDelayTimer = null;
            this.delayingLoginQueueShow = false;
         }
         this.showingLoginQueue = false;
         this.quitQueueButton.removeEventListener(MouseEvent.CLICK,this.onQuitButtonClicked);
         removeEventListener(Event.ENTER_FRAME,this.getTimeRemainingUpdate);
         this.setCurrentState("loginBusy");
      }
      
      public function updateLoginQueueViewForIndefinite(param1:Number, param2:int) : void
      {
         this.updateLoginQueueText(param1,param2,ResourceManager.getInstance().getString("resources","common_time_indefinite"));
      }
      
      public function onQuitButtonClicked(param1:Event = null) : void
      {
         this.quitQueueCallback();
         this.updateLoginStatusText("","");
         this.setCurrentState("hidden");
      }
      
      private function resourcesChangedHandler(param1:Event = null) : void
      {
         this.quitQueueButton.setText(this.resourceManager.getString("resources","common_button_cancel"));
         this.dismissButton.setText(this.resourceManager.getString("resources","common_button_ok"));
         this.inGameTextArea.setText(this.resourceManager.getString("Login2","inGameReconnectMessage"));
         this.reconnectButton.setText(this.resourceManager.getString("Login2","reconnectButtonText"));
      }
      
      public function updateLoginStatusText(param1:String, param2:String) : void
      {
         this.titleLabel.setText(param1);
         this.messageTextArea.setHtmlText("<font face=\'ApplicationFont2\'>" + param2 + "</font>");
      }
   }
}

