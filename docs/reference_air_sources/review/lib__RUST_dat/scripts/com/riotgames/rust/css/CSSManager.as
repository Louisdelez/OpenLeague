package com.riotgames.rust.css
{
   import flash.errors.IOError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.text.StyleSheet;
   
   public class CSSManager
   {
      
      public static var globalStyleSheet:StyleSheet = new StyleSheet();
      
      public function CSSManager()
      {
         super();
      }
      
      public static function loadGlobalStyleSheet(param1:String) : void
      {
         var _loc2_:File = File.applicationDirectory.resolvePath(param1);
         if(!_loc2_.exists)
         {
            throw new IOError("StyleSheet does not exist: " + param1);
         }
         var _loc3_:FileStream = new FileStream();
         _loc3_.open(_loc2_,FileMode.READ);
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.bytesAvailable);
         _loc3_.close();
         globalStyleSheet.parseCSS(_loc4_);
      }
   }
}

