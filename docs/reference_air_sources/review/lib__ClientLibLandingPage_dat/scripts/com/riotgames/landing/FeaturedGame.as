package com.riotgames.landing
{
   public class FeaturedGame
   {
      
      public var gameId:Number;
      
      public var gameMode:String;
      
      public var gameType:String;
      
      public var mapId:Number;
      
      public var encryptionKey:String;
      
      public var platformId:String;
      
      public var participants:Vector.<FeaturedGamesPlayer>;
      
      public var gameStartTime:Number;
      
      public var cacheAge:Number;
      
      public var queueType:String;
      
      public var downloadTime:Number;
      
      public function FeaturedGame(param1:Object)
      {
         super();
      }
   }
}

