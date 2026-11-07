package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.components.timeline.TimelineAnimation;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.platform.gameclient.utils.DateUtil;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class EventNotificationListRenderer extends StatefulView implements IItemRenderer
   {
      
      private var _index:uint;
      
      private var _notification:DockedPrompt;
      
      private var _notificationsProvider:NotificationsProvider;
      
      private var _title:TextFieldProxy;
      
      private var _message:TextFieldProxy;
      
      private var _background:StatefulView;
      
      private var _timeStamp:TextFieldProxy;
      
      private var _overlay:SpriteProxy;
      
      private var _sheen:StatefulView;
      
      private var _buttonContainer:StatefulView;
      
      private var _button1:LabelButtonX;
      
      private var notificationButton:ButtonX;
      
      private var _button2:LabelButtonX;
      
      public function EventNotificationListRenderer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         setLinkage("NotificationEventListRenderer");
         setCurrentState("opened");
         this._sheen.setCurrentState("noSheen");
         UserPrefs.enableAnimationsChanged.add(this.enableAnimationsChangedHandler);
         this.enableAnimationsChangedHandler();
      }
      
      private function enableAnimationsChangedHandler() : void
      {
         setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
         this._sheen.setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
      }
      
      override protected function initializeDependencies() : void
      {
         this._notificationsProvider = getDependency(NotificationsProvider);
         super.initializeDependencies();
      }
      
      override protected function createChildren() : void
      {
         this.notificationButton = new ButtonX(this);
         setTimelineChildByName("notificationButton",this.notificationButton);
         this.notificationButton.setUseHandCursor(false);
         this.notificationButton.setButtonMode(false);
         this.notificationButton.setMouseChildren(true);
         this._title = new TextFieldProxy(this);
         this.notificationButton.setTimelineChildByName("title",this._title);
         this._title.setAutoSize(TextFieldAutoSize.LEFT);
         this._title.getLayoutInvalidated().add(invalidateLayout);
         this._title.setMouseWheelEnabled(false);
         this._message = new TextFieldProxy(this);
         this.notificationButton.setTimelineChildByName("message",this._message);
         this._message.setAutoSize(TextFieldAutoSize.LEFT);
         this._message.getLayoutInvalidated().add(invalidateLayout);
         this._message.setMouseWheelEnabled(false);
         this._background = new StatefulView(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         this.notificationButton.setTimelineChildByName("background",this._background);
         this._buttonContainer = new StatefulView(this);
         this.notificationButton.setTimelineChildByName("buttonContainer",this._buttonContainer);
         this._button1 = new LabelButtonX(this);
         this._buttonContainer.setTimelineChildByName("button1",this._button1);
         this._button1.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this._button1.getLayoutInvalidated().add(invalidateLayout);
         this._button2 = new LabelButtonX(this);
         this._buttonContainer.setTimelineChildByName("button2",this._button2);
         this._button2.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         this._button2.getLayoutInvalidated().add(invalidateLayout);
         this._overlay = new SpriteProxy(this);
         this.notificationButton.setTimelineChildByName("overlay",this._overlay);
         this._overlay.getLayoutInvalidated().add(invalidateLayout);
         this._overlay.setTransformBehavior(new ScalingTransformBehavior());
         this._timeStamp = new TextFieldProxy(this);
         this.notificationButton.setTimelineChildByName("timestamp",this._timeStamp);
         this._sheen = new StatefulView(this);
         this.notificationButton.setTimelineChildByName("sheen",this._sheen);
         this._sheen.setTransformBehavior(new ScalingTransformBehavior());
         this._sheen.setMouseEnabled(false);
         this._sheen.setMouseChildren(false);
         getMouseIsOverChanged().add(this.handleMouseIsOverChanged);
         getTransitionAnimation("closed","opened").getTransitionProgressed().add(invalidateLayout);
         getTransitionAnimation("opened","closed").getTransitionProgressed().add(invalidateLayout);
         super.createChildren();
      }
      
      private function handleMouseIsOverChanged() : void
      {
         if(Boolean(getMouseIsOver()) && Boolean(this._notification) && Boolean(this._notification.unread))
         {
            this._notification.unread = false;
         }
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         switch(param1.currentTarget)
         {
            case this._button1:
               _loc2_ = ButtonNameType.LEFT_BUTTON;
               break;
            case this._button2:
               _loc2_ = ButtonNameType.RIGHT_BUTTON;
         }
         this.close(_loc2_);
      }
      
      private function close(param1:String) : void
      {
         var notification:DockedPrompt = null;
         var buttonType:String = param1;
         notification = this._notification;
         var timelineAnimation:TimelineAnimation = getStateAnimation("closed");
         timelineAnimation.getCompleted().add(function():void
         {
            _notificationsProvider.removeNotification(notification,buttonType,NotificationsProvider.RESPONSE_SOURCE_PANEL);
            getStateAnimation("closed").getCompleted().removeAll();
         });
         setCurrentState("closed");
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._title.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this._message.setExplicitSize(NaN,NaN);
         var _loc5_:Number = Math.round(_loc3_.y + _loc4_.y + 38);
         var _loc6_:Point = this._background.setExplicitSize(NaN,_loc5_);
         this._message.setExplicitPosition(NaN,_loc3_.y + 8);
         this._overlay.setExplicitSize(NaN,_loc5_);
         this._buttonContainer.setExplicitPosition(NaN,10);
         this._timeStamp.setExplicitPosition(NaN,Math.round(_loc5_ - 25));
         this._sheen.setExplicitSize(NaN,_loc6_.y);
         return _asset.getBounds(null);
      }
      
      private function updateView() : void
      {
         if(this._notification == null)
         {
            return;
         }
         if(this._notification.disabled)
         {
            this.setEnabled(false);
            if(Boolean(this._notification.disabledMessage) && this._notification.disabledMessage.length > 0)
            {
               this._message.setHtmlText("<font face=\'ApplicationFont1\'>" + this._notification.disabledMessage + "</font>");
            }
            else
            {
               this._message.setHtmlText("<font face=\'ApplicationFont1\'>" + this._notification.message + "</font>");
            }
            this._button1.setEnabled(false);
            this._button2.setEnabled(false);
         }
         else
         {
            this.setEnabled(true);
            this._message.setHtmlText("<font face=\'ApplicationFont1\'>" + this._notification.message + "</font>");
            this._button1.setEnabled(!this._notification.leftButtonDisabled);
            this._button2.setEnabled(!this._notification.rightButtonDisabled);
         }
         this._title.setText(this._notification.title);
         this._timeStamp.setText(DateUtil.getDateAndTimeString(this._notification.timeStamp));
         if(this._notification.rightButtonLabel != null && this._notification.rightButtonLabel.length > 0)
         {
            this._button2.setText(this._notification.rightButtonLabel);
            this._button2.setVisible(true);
            this._buttonContainer.setCurrentState("twoButtons");
            assignToolTip(this._button2,this._notification.rightButtonLabel);
         }
         else
         {
            this._button2.setText("");
            this._button2.setVisible(false);
            this._buttonContainer.setCurrentState("oneButton");
            unassignToolTip(this._button2);
         }
         this.handleShowIntro();
         this._button1.setText(this._notification.leftButtonLabel);
         assignToolTip(this._button1,this._notification.leftButtonLabel);
         this.notificationButton.setSelected(this._notification.unread);
      }
      
      private function handleShowIntro() : void
      {
         if(this._notification)
         {
            if(Boolean(this._notification.showIntro) && !this._notification.introShown && Boolean(this._notification.unread))
            {
               setCurrentState("closed");
               setCurrentState("opened");
               this._sheen.setCurrentState("noSheen");
               this._sheen.setCurrentState("sheen");
               this._notification.introShown = true;
               this._background.setCurrentState("selectedUp");
            }
            else if(Boolean(this._notification.showIntro) && Boolean(this._notification.introShown) && Boolean(this._notification.unread))
            {
               this._sheen.setTransitionsEnabled(false);
               this._sheen.setCurrentState("sheen");
               this._sheen.setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
               this._background.setCurrentState("selectedUp");
            }
            else
            {
               setTransitionsEnabled(false);
               setCurrentState("opened");
               this._sheen.setCurrentState("noSheen");
               setTransitionsEnabled(UserPreferencesManager.userPrefs.enableAnimations);
               this._background.setCurrentState("up");
            }
         }
      }
      
      private function addSignalListeners() : void
      {
         if(!this._notification)
         {
            return;
         }
         this._notification.getTitleChangedSignal().add(this.updateView);
         this._notification.getMessageChangedSignal().add(this.updateView);
         this._notification.getLeftButtonLabelChangedSignal().add(this.updateView);
         this._notification.getRightButtonLabelChangedSignal().add(this.updateView);
         this._notification.getDisabledChanged().add(this.updateView);
         this._notification.getDisabledMessageChanged().add(this.updateView);
         this._notification.getLeftButtonDisabledChanged().add(this.updateView);
         this._notification.getRightButtonDisabledChanged().add(this.updateView);
         this._notification.getShowIntroChanged().add(this.updateView);
         this._notification.getUnreadChangedSignal().add(this.updateView);
      }
      
      private function removeSignalListeners() : void
      {
         if(!this._notification)
         {
            return;
         }
         this._notification.getTitleChangedSignal().remove(this.updateView);
         this._notification.getMessageChangedSignal().remove(this.updateView);
         this._notification.getLeftButtonLabelChangedSignal().remove(this.updateView);
         this._notification.getRightButtonLabelChangedSignal().remove(this.updateView);
         this._notification.getDisabledChanged().remove(this.updateView);
         this._notification.getDisabledMessageChanged().remove(this.updateView);
         this._notification.getLeftButtonDisabledChanged().remove(this.updateView);
         this._notification.getRightButtonDisabledChanged().remove(this.updateView);
         this._notification.getShowIntroChanged().remove(this.updateView);
         this._notification.getUnreadChangedSignal().remove(this.updateView);
      }
      
      private function setNotification(param1:DockedPrompt) : void
      {
         if(param1 != this._notification)
         {
            this.removeSignalListeners();
            this._notification = param1;
            setCurrentState("opened");
            this.updateView();
            this.addSignalListeners();
         }
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function getData() : *
      {
         return this._notification;
      }
      
      public function setData(param1:*) : void
      {
         this.setNotification(param1);
      }
      
      override public function destroy() : void
      {
         this.setNotification(null);
         UserPreferencesManager.userPrefsAvailableChangedSignal.remove(this.enableAnimationsChangedHandler);
         super.destroy();
      }
   }
}

