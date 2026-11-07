package com.riotgames.platform.gameclient.domain
{
   [RemoteClass]
   public class UserLocaleProperties
   {
      
      public var summonerName:String;
      
      public var localId:Number;
      
      public var timeZone:Number;
      
      public var languageSaved:Boolean;
      
      public function UserLocaleProperties()
      {
         super();
      }
      
      public static function convertToLeaverData(param1:UserLocaleProperties) : LeaverData
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:LeaverData = new LeaverData();
         _loc2_.summonerName = param1.summonerName;
         _loc2_.gameInProgress = param1.languageSaved;
         _loc2_.gameTime = param1.timeZone;
         _loc2_.gameId = param1.localId;
         return _loc2_;
      }
      
      public static function convertToFakeData(param1:LeaverData) : UserLocaleProperties
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:UserLocaleProperties = new UserLocaleProperties();
         _loc2_.summonerName = param1.summonerName;
         _loc2_.languageSaved = param1.gameInProgress;
         _loc2_.timeZone = param1.gameTime;
         _loc2_.localId = param1.gameId;
         return _loc2_;
      }
   }
}

