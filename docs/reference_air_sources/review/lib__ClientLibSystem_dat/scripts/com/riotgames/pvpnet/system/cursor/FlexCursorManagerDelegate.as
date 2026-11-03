package com.riotgames.pvpnet.system.cursor
{
   import mx.managers.ICursorManager;
   
   public class FlexCursorManagerDelegate implements mx.managers.ICursorManager
   {
      
      private static var instance:mx.managers.ICursorManager;
      
      public function FlexCursorManagerDelegate()
      {
         super();
      }
      
      public static function getInstance() : mx.managers.ICursorManager
      {
         if(instance == null)
         {
            instance = new FlexCursorManagerDelegate();
         }
         return instance;
      }
      
      public function get currentCursorID() : int
      {
         return 0;
      }
      
      public function set currentCursorID(param1:int) : void
      {
      }
      
      public function get currentCursorXOffset() : Number
      {
         return 0;
      }
      
      public function set currentCursorXOffset(param1:Number) : void
      {
      }
      
      public function get currentCursorYOffset() : Number
      {
         return 0;
      }
      
      public function set currentCursorYOffset(param1:Number) : void
      {
      }
      
      public function showCursor() : void
      {
      }
      
      public function hideCursor() : void
      {
      }
      
      public function setCursor(param1:Class, param2:int = 2, param3:Number = 0, param4:Number = 0) : int
      {
         return 0;
      }
      
      public function removeCursor(param1:int) : void
      {
      }
      
      public function removeAllCursors() : void
      {
      }
      
      public function setBusyCursor() : void
      {
      }
      
      public function removeBusyCursor() : void
      {
      }
      
      public function registerToUseBusyCursor(param1:Object) : void
      {
      }
      
      public function unRegisterToUseBusyCursor(param1:Object) : void
      {
      }
   }
}

