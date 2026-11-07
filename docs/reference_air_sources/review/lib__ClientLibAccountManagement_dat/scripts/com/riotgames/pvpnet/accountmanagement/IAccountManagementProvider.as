package com.riotgames.pvpnet.accountmanagement
{
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IAccountManagementProvider extends IProvider
   {
      
      function createEmailVerificationAlert(param1:String) : void;
   }
}

