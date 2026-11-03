package com.riotgames.championdetails
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   
   public class CDPConfig
   {
      
      public var championAssetsPath:String;
      
      public var abilityAssetsPath:String;
      
      public var itemAssetsPath:String;
      
      public var videosPath:String;
      
      public var videoStillsPath:String;
      
      public var useMockServices:Boolean;
      
      public var entryPoint:String;
      
      public var initialChampionId:int;
      
      public var initialSkinId:int;
      
      public var validSkins:Vector.<int>;
      
      public function CDPConfig()
      {
         super();
      }
      
      public function parseXml(param1:XML) : void
      {
         this.championAssetsPath = param1.championAssetsPath[0];
         this.abilityAssetsPath = param1.abilityAssetsPath[0];
         this.itemAssetsPath = param1.itemAssetsPath[0];
         this.videosPath = param1.videosPath[0];
         this.videoStillsPath = param1.videoStillsPath[0];
      }
      
      public function toString() : String
      {
         return "[CDPConfig  championId=\'" + this.initialChampionId + "\' initialSkinId=\'" + this.initialSkinId + "\']";
      }
      
      public function get useTransitions() : Boolean
      {
         return UserPreferencesManager.userPrefs.enableAnimations;
      }
   }
}

