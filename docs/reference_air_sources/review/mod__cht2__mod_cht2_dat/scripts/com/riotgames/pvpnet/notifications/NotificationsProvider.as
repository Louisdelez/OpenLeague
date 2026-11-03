package com.riotgames.pvpnet.notifications
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.chat.metrics.NotificationsTracker;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   
   public class NotificationsProvider implements INotificationsProvider
   {
      
      public static const RESPONSE_SOURCE_TOAST:String = "toast";
      
      public static const RESPONSE_SOURCE_PANEL:String = "panel";
      
      private var _notifications:Vector.<DockedPrompt> = new Vector.<DockedPrompt>();
      
      private var _notificationsChanged:Signal = new Signal();
      
      private var _notificationAdded:Signal = new Signal();
      
      private var _notificationRemoved:Signal = new Signal();
      
      public var automaticallyRejectInvites:Boolean = false;
      
      public function NotificationsProvider()
      {
         super();
      }
      
      public function getNotificationsChanged() : ISignal
      {
         return this._notificationsChanged;
      }
      
      public function getNotificationAdded() : ISignal
      {
         return this._notificationAdded;
      }
      
      public function getNotificationRemoved() : ISignal
      {
         return this._notificationRemoved;
      }
      
      public function getNotifications() : Vector.<DockedPrompt>
      {
         return this._notifications;
      }
      
      public function removeNotification(param1:DockedPrompt, param2:String, param3:String = null, param4:Boolean = true) : void
      {
         var _loc5_:Boolean = this.internalRemoveNotification(param1,param2,param4,param3);
         if(_loc5_)
         {
            this._notificationsChanged.dispatch();
            NotificationsTracker.instance.notificationsChanged(this._notifications);
         }
      }
      
      public function removeMultipleNotifications(param1:Vector.<DockedPrompt>, param2:String, param3:String = null, param4:Boolean = true) : void
      {
         var _loc6_:DockedPrompt = null;
         var _loc7_:Boolean = false;
         var _loc5_:Boolean = false;
         for each(_loc6_ in param1)
         {
            _loc7_ = this.internalRemoveNotification(_loc6_,param2,param4,param3);
            _loc5_ ||= _loc7_;
         }
         if(_loc5_)
         {
            this._notificationsChanged.dispatch();
            NotificationsTracker.instance.notificationsChanged(this._notifications);
         }
      }
      
      private function internalRemoveNotification(param1:DockedPrompt, param2:String, param3:Boolean, param4:String) : Boolean
      {
         var _loc5_:int = this._notifications.indexOf(param1);
         if(_loc5_ != -1)
         {
            this._notifications.splice(_loc5_,1);
            this._notificationRemoved.dispatch(param1);
            if(param3 && param1.closeHandlerCallback != null)
            {
               if(param1.closeHandlerProperty != null)
               {
                  param1.closeHandlerCallback(param2,param1.closeHandlerProperty);
               }
               else
               {
                  param1.closeHandlerCallback(param2);
               }
            }
            if(param3)
            {
               NotificationsTracker.instance.notificationRemoved(param1,param2,param4 == RESPONSE_SOURCE_TOAST);
            }
            return true;
         }
         return false;
      }
      
      private function checkForDuplicateNotifications(param1:DockedPrompt) : Boolean
      {
         var _loc2_:DockedPrompt = null;
         if(param1.type != DockedPrompt.TYPE_OTHER)
         {
            for each(_loc2_ in this._notifications)
            {
               if(param1.message == _loc2_.message && param1.title == _loc2_.title && param1.fromName == _loc2_.fromName && param1.type == _loc2_.type)
               {
                  param1.unread = _loc2_.unread;
                  this.internalRemoveNotification(_loc2_,ButtonNameType.MINIMIZE_BUTTON,false,null);
                  return true;
               }
            }
         }
         return false;
      }
      
      public function showDockedPrompt(param1:DockedPrompt) : void
      {
         if(this.automaticallyRejectInvites && (param1.type == DockedPrompt.TYPE_FRIEND_INVITE || param1.type == DockedPrompt.TYPE_GAME_INVITE))
         {
            if(Boolean(param1) && param1.closeHandlerCallback != null)
            {
               if(param1.closeHandlerProperty != null)
               {
                  param1.closeHandlerCallback(ButtonNameType.DISMISS_BUTTON,param1.closeHandlerProperty);
               }
               else
               {
                  param1.closeHandlerCallback(ButtonNameType.DISMISS_BUTTON);
               }
            }
         }
         else if(this._notifications.indexOf(param1) == -1)
         {
            if(!this.checkForDuplicateNotifications(param1))
            {
               param1.unread = true;
            }
            this._notifications.splice(0,0,param1);
            this._notificationsChanged.dispatch();
            this._notificationAdded.dispatch(param1);
            NotificationsTracker.instance.notificationsChanged(this._notifications);
            NotificationsTracker.instance.notificationAdded(param1);
         }
      }
   }
}

