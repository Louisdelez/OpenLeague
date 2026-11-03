package com.riotgames.platform.gameclient.chat.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import mx.resources.ResourceManager;
   
   public class DockedPromptAction extends BasicAction
   {
      
      public static const FROM_PVP_NET:String = "PVP.NET";
      
      private var _isPersistent:Boolean;
      
      private var _prompt:String;
      
      private var _rightButtonLabel:String;
      
      private var _message:String;
      
      private var _dockedNotificationProvider:INotificationsProvider;
      
      private var _closeHandlerProperty:Object;
      
      private var _type:String;
      
      private var _leftButtonLabel:String;
      
      private var _title:String;
      
      private var _fromName:String;
      
      private var _closeHandlerCallback:Function;
      
      private var _timeStamp:Date;
      
      private var _rewardsIcon:int;
      
      public function DockedPromptAction(param1:Boolean, param2:INotificationsProvider, param3:String, param4:String, param5:String, param6:String, param7:String = null, param8:String = null, param9:Function = null, param10:Object = null, param11:Boolean = true, param12:int = -1)
      {
         super(param1);
         this._dockedNotificationProvider = param2;
         this._message = param3;
         this._title = param4;
         this._fromName = param5;
         this._leftButtonLabel = param6;
         this._rightButtonLabel = param7;
         this._closeHandlerCallback = param9;
         this._closeHandlerProperty = param10;
         this._rewardsIcon = param12;
         this._isPersistent = param11;
      }
      
      public static function getCommonOkButtonLable() : String
      {
         return ResourceManager.getInstance().getString("resources","common_button_ok");
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:DockedPrompt = DockedPrompt.create(this._message,this._title,this._fromName,this._leftButtonLabel,this._rightButtonLabel,this._prompt,this._closeHandlerCallback,this._closeHandlerProperty,this._isPersistent,this._rewardsIcon);
         this._dockedNotificationProvider.showDockedPrompt(_loc1_);
         complete();
      }
   }
}

