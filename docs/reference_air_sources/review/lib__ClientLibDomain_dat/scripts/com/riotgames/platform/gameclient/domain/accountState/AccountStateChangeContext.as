package com.riotgames.platform.gameclient.domain.accountState
{
   public class AccountStateChangeContext
   {
      
      public var transactionId:String = "";
      
      public var sourcePlatformId:String = "";
      
      public var destinationPlatformId:String = "";
      
      public var migrationStatusCode:String = "";
      
      public function AccountStateChangeContext(param1:Object)
      {
         super();
         if(param1 != null)
         {
            this.destinationPlatformId = param1.destinationPlatformId;
            this.migrationStatusCode = param1.migrationStatusCode;
            this.sourcePlatformId = param1.sourcePlatformId;
            this.transactionId = param1.transactionId;
         }
      }
   }
}

