package com.riotgames.pvpnet.system.cursor
{
   public class CursorManager
   {
      
      private static var _instance:ICursorManager;
      
      public function CursorManager()
      {
         super();
      }
      
      public static function getInstance() : ICursorManager
      {
         if(_instance == null)
         {
            _instance = new CursorManagerImpl();
         }
         return _instance;
      }
      
      public static function setInstance(param1:ICursorManager) : void
      {
         _instance = param1;
      }
      
      public static function addCursor(param1:String, param2:Number = 0) : void
      {
         getInstance().addCursor(param1,param2);
      }
      
      public static function removeCursor(param1:String, param2:Number = 0) : Boolean
      {
         return getInstance().removeCursor(param1,param2);
      }
      
      public static function getCurrentCursorId() : String
      {
         return getInstance().getCurrentCursorId();
      }
   }
}

