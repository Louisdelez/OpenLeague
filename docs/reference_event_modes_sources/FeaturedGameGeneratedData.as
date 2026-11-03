package com.riotgames.platform.gameclient.domain
{
   import flash.utils.Dictionary;
   
   public class FeaturedGameGeneratedData
   {
      
      public var featuredGames:Dictionary;
      
      public function FeaturedGameGeneratedData()
      {
         super();
         fillFeaturedGameData();
      }
      
      public static function createFeaturedGame(param1:String, param2:String, param3:Array) : Object
      {
         var _loc4_:Object = new Object();
         _loc4_.key = param1;
         _loc4_.gameMode = param2;
         _loc4_.gameMutators = param3;
         return _loc4_;
      }
      
      public function fillFeaturedGameData() : void
      {
         featuredGames = new Dictionary();
         featuredGames["asc"] = createFeaturedGame("asc","ASCENSION",null);
         featuredGames["fbl"] = createFeaturedGame("fbl","FIRSTBLOOD",null);
         featuredGames["nbots"] = createFeaturedGame("nbots",null,["NightmareBots"]);
         featuredGames["ofa"] = createFeaturedGame("ofa",null,["OneForAll"]);
         featuredGames["ofax"] = createFeaturedGame("ofax",null,["OneForAllX"]);
         featuredGames["sr6"] = createFeaturedGame("sr6",null,["6v6"]);
         featuredGames["tagteam"] = createFeaturedGame("tagteam",null,["TagTeam"]);
         featuredGames["tt6"] = createFeaturedGame("tt6",null,["6v6"]);
         featuredGames["urf"] = createFeaturedGame("urf",null,["URF"]);
      }
   }
}

