package com.riotgames.pvpnet.game.controllers.shutdown
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ShutdownTimingTables
   {
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.shutdown.ShutdownTimingTables");
      
      private static const queueTimingTable:Object = {
         0:60,
         30:65,
         10:75,
         1:60,
         2:60,
         14:65,
         4:75,
         6:75,
         42:75,
         8:50,
         11:75,
         9:75,
         41:75,
         15:35,
         16:35,
         17:65,
         18:75,
         19:75,
         12:60,
         13:60,
         7:60,
         "custom":60
      };
      
      internal static var SHUTDOWN_WINDOW_LENGTH:Number = 6 * 60 * 60 * 1000;
      
      public static var SHUTDOWN_WARNING_TIME:Number = 90 * 60 * 1000;
      
      public static var NO_QUEUES_WARNING_TIME:Number = 35 * 60 * 1000;
      
      public static var SELECTIVE_SHUTDOWN_MODE:Boolean = true;
      
      private static var enabled:Boolean = false;
      
      private static var cutoffTime:Number = 0;
      
      public function ShutdownTimingTables()
      {
         super();
      }
      
      public static function setCutoffTime(param1:Number) : void
      {
         enabled = true;
         cutoffTime = new Date().getTime() + param1;
      }
      
      public static function isInShutdownWindow() : Boolean
      {
         if(!enabled)
         {
            return false;
         }
         var _loc1_:Number = cutoffTime - new Date().getTime();
         if(_loc1_ <= 0)
         {
            return true;
         }
         if(!SELECTIVE_SHUTDOWN_MODE)
         {
            return _loc1_ + SHUTDOWN_WINDOW_LENGTH > 24 * 60 * 60 * 1000;
         }
         return false;
      }
      
      public static function isInWarningWindow() : Boolean
      {
         return new Date().getTime() + SHUTDOWN_WARNING_TIME > cutoffTime;
      }
      
      public static function noQueuesAvailable() : Boolean
      {
         if(!enabled)
         {
            return false;
         }
         if(isInShutdownWindow())
         {
            return true;
         }
         return new Date().getTime() + NO_QUEUES_WARNING_TIME > cutoffTime;
      }
      
      public static function getTimeUntilShutdown() : Number
      {
         return cutoffTime - new Date().getTime();
      }
      
      public static function getTimeUntilNoQueuesAvailable() : Number
      {
         return cutoffTime - NO_QUEUES_WARNING_TIME - new Date().getTime();
      }
      
      public static function getTimeUntilShutdownWarning() : Number
      {
         return cutoffTime - SHUTDOWN_WARNING_TIME - new Date().getTime();
      }
      
      public static function canJoinQueueRightNow(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         if(!enabled)
         {
            return true;
         }
         if(int(param1) == -1)
         {
            return false;
         }
         if(isInShutdownWindow())
         {
            return false;
         }
         if(cutoffTime <= 0)
         {
            logger.warn("A cutoff time wasn\'t defined when checking ability to join queue ID " + param1);
            return true;
         }
         if(queueTimingTable.hasOwnProperty(param1))
         {
            _loc2_ = int(queueTimingTable[param1]);
         }
         else
         {
            _loc2_ = 75;
            logger.warn("A cutoff time wasn\'t defined for queueID " + param1);
         }
         return new Date().time + _loc2_ * 60 * 1000 < cutoffTime;
      }
   }
}

