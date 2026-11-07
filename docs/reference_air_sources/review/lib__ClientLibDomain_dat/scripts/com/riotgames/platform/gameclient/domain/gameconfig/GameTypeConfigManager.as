package com.riotgames.platform.gameclient.domain.gameconfig
{
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class GameTypeConfigManager
   {
      
      private static var _instance:GameTypeConfigManager;
      
      private var gameTypeConfigs:ArrayCollection = null;
      
      private var practiceGameConfigIds:ArrayCollection = null;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function GameTypeConfigManager()
      {
         super();
      }
      
      public static function get instance() : GameTypeConfigManager
      {
         if(_instance == null)
         {
            _instance = new GameTypeConfigManager();
         }
         return _instance;
      }
      
      public function setPracticeGameConfigs(param1:ArrayCollection) : void
      {
         this.practiceGameConfigIds = param1;
      }
      
      public function setGameTypeConfigs(param1:ArrayCollection) : void
      {
         if(param1 == null)
         {
            this.logger.error("setGameTypeConfigs was passed a null list");
         }
         else
         {
            this.gameTypeConfigs = param1;
         }
      }
      
      public function getGameTypeConfig(param1:int) : GameTypeConfig
      {
         var _loc3_:GameTypeConfig = null;
         var _loc2_:GameTypeConfig = null;
         for each(_loc3_ in this.gameTypeConfigs)
         {
            if(_loc3_.id == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         if(_loc2_ == null)
         {
            this.logger.error("GameTypeConfigManager.getGameTypeConfig: ERROR! Found no game type config for index: " + param1);
         }
         return _loc2_;
      }
      
      public function getPracticeGameTypeConfigs() : ArrayCollection
      {
         var _loc2_:GameTypeConfig = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.gameTypeConfigs)
         {
            if(this.isPracticeGameConfig(_loc2_))
            {
               _loc1_.addItem(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function isPracticeGameConfig(param1:GameTypeConfig) : Boolean
      {
         var _loc2_:Number = NaN;
         for each(_loc2_ in this.practiceGameConfigIds)
         {
            if(param1.id == _loc2_)
            {
               return true;
            }
         }
         return false;
      }
   }
}

