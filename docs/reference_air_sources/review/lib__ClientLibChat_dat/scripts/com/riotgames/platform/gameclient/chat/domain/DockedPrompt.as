package com.riotgames.platform.gameclient.chat.domain
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class DockedPrompt extends EventDispatcher
   {
      
      public static const TYPE_OTHER:String = "other";
      
      public static const TYPE_ALARM:String = "alarm";
      
      public static const TYPE_FRIEND_INVITE:String = "friendInvite";
      
      public static const TYPE_GAME_INVITE:String = "gameInvite";
      
      private var _rightButtonLabel:String;
      
      public var introShown:Boolean = false;
      
      private var _messageChangedSignal:Signal = new Signal();
      
      public var shown:Boolean = false;
      
      private var _rewardsIconChangedSignal:Signal = new Signal();
      
      private var _leftButtonLabel:String;
      
      private var _showIntroChanged:Signal = new Signal();
      
      public var closeHandlerProperty:Object;
      
      private var _titleChangedSignal:Signal = new Signal();
      
      private var _disabledMessage:String = "";
      
      private var _closeHandlerCallbackChangedSignal:Signal = new Signal();
      
      public var type:String = "other";
      
      private var _leftButtonLabelChangedSignal:Signal = new Signal();
      
      private var _message:String;
      
      private var _rightButtonDisabled:Boolean = false;
      
      private var _unread:Boolean;
      
      private var _leftButtonDisabledChanged:Signal = new Signal();
      
      private var _leftButtonDisabled:Boolean = false;
      
      private var _unreadChangedSignal:Signal = new Signal();
      
      private var _title:String;
      
      public var fromName:String;
      
      private var _disabledChanged:Signal = new Signal();
      
      public var isPersistent:Boolean = true;
      
      private var _disabled:Boolean = false;
      
      private var _disabledMessageChanged:Signal = new Signal();
      
      private var _rightButtonDisabledChanged:Signal = new Signal();
      
      public var timeStamp:Date;
      
      private var _rightButtonLabelChangedSignal:Signal = new Signal();
      
      private var _closeHandlerCallback:Function;
      
      private var _rewardsIcon:int;
      
      private var _showIntro:Boolean = false;
      
      public function DockedPrompt()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:String, param5:String = null, param6:String = null, param7:Function = null, param8:Object = null, param9:Boolean = true, param10:int = -1, param11:String = "") : DockedPrompt
      {
         var _loc12_:DockedPrompt = new DockedPrompt();
         _loc12_.message = param1;
         _loc12_.title = param2;
         _loc12_.fromName = param3;
         _loc12_.leftButtonLabel = param4;
         _loc12_.rightButtonLabel = param5;
         _loc12_.closeHandlerCallback = param7;
         _loc12_.closeHandlerProperty = param8;
         _loc12_.rewardsIcon = param10;
         if(param6 != null)
         {
            _loc12_.type = param6;
         }
         _loc12_.timeStamp = new Date();
         _loc12_.isPersistent = param9;
         _loc12_.disabledMessage = param11;
         return _loc12_;
      }
      
      public function set rewardsIcon(param1:int) : void
      {
         if(this._rewardsIcon == param1)
         {
            return;
         }
         this._rewardsIcon = param1;
         dispatchEvent(new Event("REWARDS_ICON_CHANGED"));
         this._rewardsIconChangedSignal.dispatch(param1);
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function getLeftButtonDisabledChanged() : ISignal
      {
         return this._leftButtonDisabledChanged;
      }
      
      public function set message(param1:String) : void
      {
         if(this._message == param1)
         {
            return;
         }
         this._message = param1;
         this._messageChangedSignal.dispatch(param1);
      }
      
      public function get rightButtonDisabled() : Boolean
      {
         return this._rightButtonDisabled;
      }
      
      public function get closeHandlerCallback() : Function
      {
         return this._closeHandlerCallback;
      }
      
      public function set rightButtonDisabled(param1:Boolean) : void
      {
         if(this._rightButtonDisabled == param1)
         {
            return;
         }
         this._rightButtonDisabled = param1;
         this._rightButtonDisabledChanged.dispatch();
      }
      
      [Bindable(event="RIGHT_BUTTON_LABEL_CHANGED")]
      public function get rightButtonLabel() : String
      {
         return this._rightButtonLabel;
      }
      
      public function getMessageChangedSignal() : ISignal
      {
         return this._messageChangedSignal;
      }
      
      public function set closeHandlerCallback(param1:Function) : void
      {
         if(param1 == this._closeHandlerCallback)
         {
            return;
         }
         this._closeHandlerCallback = param1;
         this._closeHandlerCallbackChangedSignal.dispatch(param1);
      }
      
      public function get unread() : Boolean
      {
         return this._unread;
      }
      
      public function set title(param1:String) : void
      {
         if(this._title == param1)
         {
            return;
         }
         this._title = param1;
         this._titleChangedSignal.dispatch(param1);
      }
      
      public function getRewardsIconChangedSignal() : ISignal
      {
         return this._rewardsIconChangedSignal;
      }
      
      public function set leftButtonLabel(param1:String) : void
      {
         if(this._leftButtonLabel == param1)
         {
            return;
         }
         this._leftButtonLabel = param1;
         dispatchEvent(new Event("LEFT_BUTTON_LABEL_CHANGED"));
         this._leftButtonLabelChangedSignal.dispatch(param1);
      }
      
      public function getShowIntroChanged() : ISignal
      {
         return this._showIntroChanged;
      }
      
      [Bindable(event="REWARDS_ICON_CHANGED")]
      public function get rewardsIcon() : int
      {
         return this._rewardsIcon;
      }
      
      public function getDisabledMessageChanged() : ISignal
      {
         return this._disabledMessageChanged;
      }
      
      public function getCloseHandlerCallbackChangedSignal() : ISignal
      {
         return this._closeHandlerCallbackChangedSignal;
      }
      
      public function get leftButtonDisabled() : Boolean
      {
         return this._leftButtonDisabled;
      }
      
      public function getRightButtonLabelChangedSignal() : ISignal
      {
         return this._rightButtonLabelChangedSignal;
      }
      
      public function set rightButtonLabel(param1:String) : void
      {
         if(this._rightButtonLabel == param1)
         {
            return;
         }
         this._rightButtonLabel = param1;
         dispatchEvent(new Event("RIGHT_BUTTON_LABEL_CHANGED"));
         this._rightButtonLabelChangedSignal.dispatch(param1);
      }
      
      public function set disabledMessage(param1:String) : void
      {
         if(param1 == this._disabledMessage)
         {
            return;
         }
         this._disabledMessage = param1;
         this._disabledMessageChanged.dispatch();
      }
      
      public function getLeftButtonLabelChangedSignal() : ISignal
      {
         return this._leftButtonLabelChangedSignal;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      [Bindable(event="LEFT_BUTTON_LABEL_CHANGED")]
      public function get leftButtonLabel() : String
      {
         return this._leftButtonLabel;
      }
      
      public function set unread(param1:Boolean) : void
      {
         if(this._unread == param1)
         {
            return;
         }
         this._unread = param1;
         this._unreadChangedSignal.dispatch(param1);
      }
      
      public function set showIntro(param1:Boolean) : void
      {
         if(this._showIntro != param1)
         {
            this._showIntro = param1;
            this._showIntroChanged.dispatch();
         }
      }
      
      public function getUnreadChangedSignal() : ISignal
      {
         return this._unreadChangedSignal;
      }
      
      public function getDisabledChanged() : ISignal
      {
         return this._disabledChanged;
      }
      
      public function set leftButtonDisabled(param1:Boolean) : void
      {
         if(this._leftButtonDisabled == param1)
         {
            return;
         }
         this._leftButtonDisabled = param1;
         this._leftButtonDisabledChanged.dispatch();
      }
      
      public function get disabledMessage() : String
      {
         return this._disabledMessage;
      }
      
      public function getRightButtonDisabledChanged() : ISignal
      {
         return this._rightButtonDisabledChanged;
      }
      
      public function get showIntro() : Boolean
      {
         return this._showIntro;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         if(this.disabled == param1)
         {
            return;
         }
         this._disabled = param1;
         this._disabledChanged.dispatch();
      }
      
      public function getTitleChangedSignal() : ISignal
      {
         return this._titleChangedSignal;
      }
   }
}

