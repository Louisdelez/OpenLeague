package com.riotgames.pvpnet.system.boot.actions
{
   import flash.filesystem.File;
   
   public class LoadFontsPathChecker
   {
      
      public function LoadFontsPathChecker()
      {
         super();
      }
      
      public function checkIfPathExists(param1:String) : Boolean
      {
         var _loc2_:File = File.applicationDirectory.resolvePath(param1);
         return _loc2_.exists;
      }
   }
}

