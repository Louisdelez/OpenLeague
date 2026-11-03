package com.riotgames.pvpnet.system.cursor
{
   public interface ICursorManager
   {
      
      function addCursor(param1:String, param2:Number = 0) : void;
      
      function removeCursor(param1:String, param2:Number = 0) : Boolean;
      
      function getCurrentCursorId() : String;
   }
}

