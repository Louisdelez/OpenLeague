package com.riotgames.pvpnet.docked.chat.view.notifications
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.metrics.NotificationsTracker;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.pvpnet.docked.chat.view.buddypanel.BuddyPanelView;
   import com.riotgames.pvpnet.docked.model.DockedChatViewModel;
   import com.riotgames.pvpnet.notifications.NotificationsProvider;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class NotificationToaster extends SpriteProxy
   {
      
      private static const PADDING:Number = 3;
      
      private var _notificationsProvider:NotificationsProvider;
      
      private var _activeToasts:Vector.<NotificationToast> = new Vector.<NotificationToast>(0);
      
      private var _activeToastNotifications:Vector.<DockedPrompt> = new Vector.<DockedPrompt>();
      
      private var _lastFrame:int;
      
      private var _frameTime:int = 10;
      
      private var _needInvalidateOnFrame:Boolean = false;
      
      private var _model:DockedChatViewModel;
      
      public function NotificationToaster(param1:IContext)
      {
         super(param1);
         this._notificationsProvider.getNotificationAdded().add(this.onNotificationAdded);
         this._notificationsProvider.getNotificationRemoved().add(this.onNotificationRemoved);
         getEnterFrame().add(this.updateFrame);
         this._lastFrame = getTimer();
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(DockedChatViewModel);
         this._notificationsProvider = getDependency(NotificationsProvider);
         super.initializeDependencies();
      }
      
      private function updateFrame() : void
      {
         var _loc1_:int = getTimer();
         var _loc2_:int = _loc1_ - this._lastFrame;
         this._frameTime = Math.min(Math.max(_loc2_,5),100);
         this._lastFrame = _loc1_;
         if(this._needInvalidateOnFrame)
         {
            invalidateLayout();
         }
      }
      
      private function onNotificationAdded(param1:DockedPrompt) : void
      {
         var _loc2_:NotificationToast = null;
         if(this._model.getBuddyPanelState() != BuddyPanelView.VIEW_STATE_NOTIFICATIONS && !UserPreferencesManager.userPrefs.suppressNotificationPopups)
         {
            _loc2_ = new NotificationToast(this);
            _loc2_.setPrompt(param1);
            _loc2_.userAction.add(this.onToastUserAction);
            _loc2_.complete.add(this.onToastComplete);
            _loc2_.getMessageTextChangedSignal().add(invalidateLayout);
            addChild(_loc2_);
            this._activeToasts.push(_loc2_);
            this._activeToastNotifications.push(param1);
            NotificationsTracker.instance.activeToastsChanged(this._activeToastNotifications);
            invalidateLayout();
         }
      }
      
      private function onNotificationRemoved(param1:DockedPrompt) : void
      {
         var _loc2_:NotificationToast = null;
         for each(_loc2_ in this._activeToasts)
         {
            if(_loc2_.getPrompt() == param1)
            {
               _loc2_.userAction.remove(this.onToastUserAction);
               _loc2_.dismiss();
            }
         }
      }
      
      private function onToastUserAction(param1:NotificationToast, param2:String) : void
      {
         if(param2 != ButtonNameType.MINIMIZE_BUTTON)
         {
            this._notificationsProvider.removeNotification(param1.getPrompt(),param2,NotificationsProvider.RESPONSE_SOURCE_TOAST);
         }
         param1.userAction.remove(this.onToastUserAction);
      }
      
      private function onToastComplete(param1:NotificationToast) : void
      {
         param1.userAction.remove(this.onToastUserAction);
         param1.complete.remove(this.onToastComplete);
         removeChild(param1);
         param1.destroy();
         var _loc2_:int = this._activeToasts.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._activeToasts.splice(_loc2_,1);
            this._activeToastNotifications.splice(_loc2_,1);
            NotificationsTracker.instance.activeToastsChanged(this._activeToastNotifications);
         }
         invalidateLayout();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:NotificationToast = null;
         var _loc5_:Point = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc3_:Number = 0;
         this._needInvalidateOnFrame = false;
         for each(_loc4_ in this._activeToasts)
         {
            _loc5_ = _loc4_.setExplicitSize(NaN,NaN);
            if(!_loc5_.x)
            {
               _loc5_ = new Point(300,150);
            }
            _loc3_ -= _loc5_.y;
            _loc7_ = _loc3_ - _loc4_.getY();
            if(_loc7_ > 0)
            {
               _loc8_ = this._frameTime * (40 + _loc7_) * 0.006;
               _loc6_ = _loc4_.getY() + _loc8_;
               _loc6_ = Math.min(_loc6_,_loc3_);
            }
            else
            {
               _loc6_ = _loc3_;
            }
            if(_loc6_ != _loc3_)
            {
               this._needInvalidateOnFrame = true;
            }
            _loc4_.setExplicitPosition(0 - _loc5_.x,_loc6_);
            _loc3_ -= PADDING;
         }
         return super.updateLayout(param1,param2);
      }
   }
}

