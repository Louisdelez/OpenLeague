package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.text.Text;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.chat.config.DockedPromptConfig;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   
   public class NotificationToast extends StatefulView
   {
      
      private static const STATE_OPENED:String = "opened";
      
      private static const STATE_CLOSED:String = "closed";
      
      private static const INITIAL_TIME_TO_LIVE_MS:int = 4500;
      
      private static const ROLL_OVER_TIME_TO_LIVE_MS:int = 1500;
      
      private static const ROLL_OVER_ALPHA_VELOCITY:Number = 5;
      
      private static const FADE_OUT_ALPHA_VELOCITY:Number = -0.8;
      
      private static const FADE_IN_ALPHA_VELOCITY:Number = 3;
      
      private static const QUICK_FADE_OUT_ALPHA_VELOCITY:Number = -12;
      
      private var _background:SpriteProxy;
      
      private var _panelTop:SpriteProxy;
      
      private var _panelMid:SpriteProxy;
      
      private var _panelBot:SpriteProxy;
      
      private var _titleText:Text;
      
      private var _messageText:Text;
      
      private var _minimizeButton:ButtonX;
      
      private var _button1:LabelButtonX;
      
      private var _button2:LabelButtonX;
      
      private var _buttonContainer:StatefulView;
      
      private var _rewardIcon:StatefulView;
      
      private var _parentToastContainer:StatefulView;
      
      private var _prompt:DockedPrompt;
      
      public var userAction:Signal = new Signal();
      
      public var complete:Signal = new Signal();
      
      private var _messageTextChangedSignal:Signal = new Signal();
      
      private var _alphaVelocityPerSecond:Number = 0;
      
      private var _lastFrame:int;
      
      private var _timeToLive:int;
      
      private var _isAlive:Boolean;
      
      private var _backgroundHeightOffset:Number;
      
      private var _defaultSize:Point;
      
      public function NotificationToast(param1:IContext)
      {
         super(param1);
         setLinkage("nt.NotificationToast");
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
      }
      
      public function getMessageTextChangedSignal() : ISignal
      {
         return this._messageTextChangedSignal;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._parentToastContainer = new StatefulView(this);
         setTimelineChildByName("animationContainer",this._parentToastContainer);
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         this._parentToastContainer.setTimelineChildByName("background",this._background);
         this._panelTop = new SpriteProxy(this);
         this._parentToastContainer.setTimelineChildByName("panelTop",this._panelTop);
         this._panelTop.setTransformBehavior(new ScalingTransformBehavior());
         this._panelMid = new SpriteProxy(this);
         this._parentToastContainer.setTimelineChildByName("panelMid",this._panelMid);
         this._panelMid.setTransformBehavior(new ScalingTransformBehavior());
         this._panelBot = new SpriteProxy(this);
         this._parentToastContainer.setTimelineChildByName("panelBot",this._panelBot);
         this._panelBot.setTransformBehavior(new ScalingTransformBehavior());
         this._titleText = new Text(this);
         this._parentToastContainer.setTimelineChildByName("titleText",this._titleText);
         this._messageText = new Text(this);
         this._parentToastContainer.setTimelineChildByName("messageText",this._messageText);
         this._messageText.getLayoutInvalidated().add(invalidateLayout);
         this._messageText.setMouseWheelEnabled(false);
         this._minimizeButton = new ButtonX(this);
         this._parentToastContainer.setTimelineChildByName("minimizeButton",this._minimizeButton);
         this._minimizeButton.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this._buttonContainer = new StatefulView(this);
         this._parentToastContainer.setTimelineChildByName("buttonContainer",this._buttonContainer);
         this._button1 = new LabelButtonX(this);
         this._buttonContainer.setTimelineChildByName("button1",this._button1);
         this._button1.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this._button2 = new LabelButtonX(this);
         this._buttonContainer.setTimelineChildByName("button2",this._button2);
         this._button2.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this._rewardIcon = new StatefulView(this);
         this._parentToastContainer.setTimelineChildByName("rewardIcon",this._rewardIcon);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this._parentToastContainer.setCurrentState("normal");
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onFrame);
         this._lastFrame = getTimer();
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onFrame);
      }
      
      private function onFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this._lastFrame;
         this._lastFrame = _loc2_;
         if(this._isAlive)
         {
            this.manageFade(_loc3_);
         }
         var _loc4_:Number = _loc3_ * 0.001 * this._alphaVelocityPerSecond;
         var _loc5_:Number = getAlpha() + _loc4_;
         _loc5_ = Math.min(Math.max(_loc5_,0),1);
         setAlpha(_loc5_);
         if(getAlpha() <= 0)
         {
            this.complete.dispatch(this);
         }
      }
      
      private function manageFade(param1:int) : void
      {
         if(this.getMouseIsOver())
         {
            this._alphaVelocityPerSecond = ROLL_OVER_ALPHA_VELOCITY;
            this._timeToLive = Math.max(this._timeToLive,ROLL_OVER_TIME_TO_LIVE_MS);
         }
         else if(this._timeToLive > 0)
         {
            this._timeToLive -= param1;
            if(this._timeToLive <= 0)
            {
               this._alphaVelocityPerSecond = FADE_OUT_ALPHA_VELOCITY;
            }
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(!this._isAlive)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._button1:
               _loc2_ = ButtonNameType.LEFT_BUTTON;
               break;
            case this._button2:
               _loc2_ = ButtonNameType.RIGHT_BUTTON;
               break;
            case this._minimizeButton:
               _loc2_ = ButtonNameType.MINIMIZE_BUTTON;
         }
         this.userAction.dispatch(this,_loc2_);
         this.dismiss();
      }
      
      private function addSignalListeners() : void
      {
         if(!this._prompt)
         {
            return;
         }
         this._prompt.getTitleChangedSignal().add(this.setTitle);
         this._prompt.getMessageChangedSignal().add(this.setMessage);
         this._prompt.getLeftButtonLabelChangedSignal().add(this.setLeftButton);
         this._prompt.getRightButtonLabelChangedSignal().add(this.setRightButton);
         this._prompt.getLeftButtonDisabledChanged().add(this.updateLeftButtonEnabled);
         this._prompt.getRightButtonDisabledChanged().add(this.updateRightButtonEnabled);
         this._prompt.getRewardsIconChangedSignal().add(this.updateSeasonRewardIcon);
      }
      
      private function removeSignalListeners() : void
      {
         if(!this._prompt)
         {
            return;
         }
         this._prompt.getTitleChangedSignal().remove(this.setTitle);
         this._prompt.getMessageChangedSignal().remove(this.setMessage);
         this._prompt.getLeftButtonLabelChangedSignal().remove(this.setLeftButton);
         this._prompt.getRightButtonLabelChangedSignal().remove(this.setRightButton);
         this._prompt.getLeftButtonDisabledChanged().remove(this.updateLeftButtonEnabled);
         this._prompt.getRightButtonDisabledChanged().remove(this.updateRightButtonEnabled);
         this._prompt.getRewardsIconChangedSignal().remove(this.updateSeasonRewardIcon);
      }
      
      public function setTitle(param1:String) : void
      {
         this._titleText.setText(param1);
      }
      
      public function setMessage(param1:String) : void
      {
         this._messageText.setHtmlText("<font face=\'ApplicationFont1\'>" + param1 + "</font>");
         this._messageTextChangedSignal.dispatch();
      }
      
      private function setRightButton(param1:String) : void
      {
         if(param1 != null && param1.length > 0)
         {
            this._button2.setText(param1);
            this._button2.setVisible(true);
         }
         else
         {
            this._button2.setText("");
            this._button2.setVisible(false);
         }
      }
      
      public function setLeftButton(param1:String) : void
      {
         this._button1.setText(param1);
      }
      
      public function updateLeftButtonEnabled() : void
      {
         this._button1.setEnabled(!this._prompt.leftButtonDisabled);
         this._button1.setVisible(!this._prompt.leftButtonDisabled);
      }
      
      public function updateRightButtonEnabled() : void
      {
         this._button2.setEnabled(!this._prompt.rightButtonDisabled);
         this._button2.setVisible(!this._prompt.rightButtonDisabled);
      }
      
      public function setPrompt(param1:DockedPrompt) : void
      {
         this.removeSignalListeners();
         setCurrentState(STATE_CLOSED);
         setCurrentState(STATE_OPENED);
         this._prompt = param1;
         this.setTitle(param1.title);
         this.setMessage(param1.message);
         this.setLeftButton(param1.leftButtonLabel);
         this.setRightButton(param1.rightButtonLabel);
         this.updateLeftButtonEnabled();
         this.updateRightButtonEnabled();
         if(param1.rightButtonLabel == null || param1.rightButtonLabel.length == 0)
         {
            this._buttonContainer.setCurrentState("oneButton");
         }
         else
         {
            this._buttonContainer.setCurrentState("twoButtons");
         }
         this.updateSeasonRewardIcon();
         this._timeToLive = INITIAL_TIME_TO_LIVE_MS;
         this._isAlive = true;
         setAlpha(0.5);
         this._alphaVelocityPerSecond = FADE_IN_ALPHA_VELOCITY;
         invalidateLayout();
         this.addSignalListeners();
      }
      
      private function updateSeasonRewardIcon() : void
      {
         var _loc1_:ConfigurationModel = null;
         var _loc2_:LeagueTier = null;
         var _loc3_:Boolean = false;
         if(this._prompt)
         {
            _loc1_ = DynamicClientConfigManager.getConfiguration(DockedPromptConfig.NAMESPACE,DockedPromptConfig.ENABLED_NEW_DOCKED_PROMPT_RENDERER,DockedPromptConfig.ENABLED_NEW_DOCKED_PROMPT_DEFAULT);
            _loc2_ = LeagueCache.getTierForIconReward(this._prompt.rewardsIcon);
            _loc3_ = _loc2_ != LeagueTier.NULL && Boolean(_loc1_.getBoolean());
            if(_loc3_)
            {
               this._parentToastContainer.setCurrentState("seasonRewards");
               this._rewardIcon.setCurrentState(_loc2_.value());
            }
            else
            {
               this._parentToastContainer.setCurrentState("normal");
            }
         }
      }
      
      public function dismiss() : void
      {
         setCurrentState(STATE_OPENED);
         setCurrentState(STATE_CLOSED);
         this._isAlive = false;
         this._alphaVelocityPerSecond = QUICK_FADE_OUT_ALPHA_VELOCITY;
      }
      
      public function getPrompt() : DockedPrompt
      {
         return this._prompt;
      }
      
      override public function setAsset(param1:DisplayObject) : void
      {
         super.setAsset(param1);
         var _loc2_:MovieClip = param1 as MovieClip;
         if(_loc2_ != null)
         {
            _loc2_.gotoAndStop(STATE_OPENED);
            this._defaultSize = new Point(this._parentToastContainer.getWidth(),this._parentToastContainer.getHeight());
            this._backgroundHeightOffset = this._defaultSize.y - this._messageText.getHeight();
            this._messageText.setAutoSize(TextFieldAutoSize.LEFT);
         }
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._messageText.setExplicitSize(NaN,NaN);
         var _loc4_:Number = Math.max(this._defaultSize.y,_loc3_.y + this._backgroundHeightOffset);
         this._background.setExplicitSize(NaN,_loc4_);
         this._panelMid.setHeight(_loc4_ - this._panelTop.getHeight() - this._panelBot.getHeight());
         this._panelBot.setY(this._panelMid.getY() + this._panelMid.getHeight());
         this._buttonContainer.setExplicitPosition(NaN,_loc4_ - this._button1.getHeight() - 12);
         return new Rectangle(0,0,this._defaultSize.x,_loc4_);
      }
   }
}

