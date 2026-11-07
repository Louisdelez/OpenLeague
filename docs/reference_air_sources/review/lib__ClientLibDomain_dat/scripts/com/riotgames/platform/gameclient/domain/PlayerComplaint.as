package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.harassment.HarassmentReport")]
   public class PlayerComplaint
   {
      
      public var ipAddress:String;
      
      public var offense:String;
      
      public var gameId:Number;
      
      public var reportSource:String;
      
      public var reportingSummonerId:Number;
      
      public var reportedSummonerId:Number;
      
      public var comment:String;
      
      public function PlayerComplaint()
      {
         super();
      }
   }
}

