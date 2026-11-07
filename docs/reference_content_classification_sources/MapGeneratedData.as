package com.riotgames.platform.gameclient.domain
{
   import flash.utils.Dictionary;
   
   public class MapGeneratedData
   {
      
      public var maps:Dictionary;
      
      public function MapGeneratedData()
      {
         super();
         fillMapData();
      }
      
      public static function createMap(param1:int, param2:String, param3:String, param4:String, param5:int) : Object
      {
         var _loc6_:Object = new Object();
         _loc6_.mapId = param1;
         _loc6_.name = param2;
         _loc6_.displayName = param3;
         _loc6_.description = param4;
         _loc6_.totalPlayers = param5;
         return _loc6_;
      }
      
      public function fillMapData() : void
      {
         maps = new Dictionary();
         maps[1] = createMap(1,"SummonersRift","Summoner\'s Rift","",10);
         maps[2] = createMap(2,"SummonersRiftWinter","Summoner\'s Rift (Autumn)","",10);
         maps[4] = createMap(4,"OldTwistedTreeline","The Twisted Treeline","",6);
         maps[7] = createMap(7,"ProvingGroundsARAM","The Proving Grounds","",10);
         maps[8] = createMap(8,"CrystalScar","The Crystal Scar","",10);
         maps[10] = createMap(10,"TwistedTreeline","The Twisted Treeline","",6);
         maps[11] = createMap(11,"SummonersRiftUpdate","Summoner\'s Rift (updated)","",10);
         maps[12] = createMap(12,"HowlingAbyss","The Howling Abyss","",10);
         maps[13] = createMap(13,"SummonersRiftUpdatePerf","Summoner\'s Rift (updated) Performance","",10);
         maps[90] = createMap(90,"DebugMap5","Debug Map 5","",10);
      }
   }
}

