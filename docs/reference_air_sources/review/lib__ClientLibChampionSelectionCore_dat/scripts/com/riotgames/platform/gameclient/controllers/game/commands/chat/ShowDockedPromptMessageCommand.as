package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import mx.resources.IResourceManager;
   
   public class ShowDockedPromptMessageCommand extends CommandBase
   {
      
      private var _resourceManager:IResourceManager;
      
      private var _bundle:String;
      
      private var _showTitle:Boolean;
      
      private var _titleKey:String;
      
      private var _dockedNotificationsProvider:INotificationsProvider;
      
      private var _messageParameters:Array;
      
      private var _fromName:String;
      
      private var _buttonKey:String;
      
      private var _messageKey:String;
      
      public function ShowDockedPromptMessageCommand(param1:String, param2:String, param3:Array, param4:String, param5:String, param6:String, param7:INotificationsProvider, param8:IResourceManager, param9:Boolean)
      {
         super();
         this._resourceManager = param8;
         this._dockedNotificationsProvider = param7;
         this._titleKey = param1;
         this._messageKey = param2;
         this._messageParameters = param3;
         this._buttonKey = param6;
         this._bundle = param4;
         this._fromName = param5;
         this._showTitle = param9;
      }
      
      override public function execute() : void
      {
         super.execute();
         var _loc1_:String = this._resourceManager.getString(this._bundle,this._titleKey);
         if(_loc1_ == null && this._showTitle)
         {
            _loc1_ = "**" + this._titleKey;
         }
         var _loc2_:String = this._resourceManager.getString(this._bundle,this._messageKey,this._messageParameters);
         if(_loc2_ == null)
         {
            _loc2_ = "**" + this._messageKey;
         }
         var _loc3_:String = this._resourceManager.getString(this._bundle,this._buttonKey);
         if(_loc3_ == null)
         {
            _loc3_ = "**" + this._buttonKey;
         }
         var _loc4_:String = this._resourceManager.getString(this._bundle,this._fromName);
         if(_loc4_ == null)
         {
            _loc4_ = "**" + this._fromName;
         }
         var _loc5_:DockedPrompt = DockedPrompt.create(_loc2_,_loc1_,_loc4_,_loc3_);
         this._dockedNotificationsProvider.showDockedPrompt(_loc5_);
         onComplete();
         onResult();
      }
   }
}

