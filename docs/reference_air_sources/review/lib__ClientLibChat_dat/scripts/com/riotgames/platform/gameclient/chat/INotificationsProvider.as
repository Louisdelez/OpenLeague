package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface INotificationsProvider extends IProvider
   {
      
      function showDockedPrompt(param1:DockedPrompt) : void;
      
      function removeNotification(param1:DockedPrompt, param2:String, param3:String = null, param4:Boolean = true) : void;
   }
}

