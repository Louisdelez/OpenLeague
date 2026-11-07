package com.riotgames.util.file
{
   import com.riotgames.util.logging.getLogger;
   import flash.filesystem.File;
   
   public class RiotRootDir
   {
      
      private static var rootDir:File;
      
      private static var gameConfigDir:File;
      
      private static var rootIsDev:Boolean = false;
      
      public static var isTencent:Boolean = false;
      
      public static var isGarena:Boolean = false;
      
      public static var isPBE:Boolean = false;
      
      public function RiotRootDir()
      {
         super();
      }
      
      public static function isDevFolder() : Boolean
      {
         var _loc1_:File = new File(File.applicationDirectory.nativePath);
         return _loc1_.name == "bin" && _loc1_.parent.name == "build";
      }
      
      public static function getGameConfigFolder() : File
      {
         var thisFile:File = null;
         var gameFolder:File = null;
         var configFolder:File = null;
         var gameDir:File = null;
         getRoot();
         try
         {
            if(gameConfigDir == null)
            {
               if(isDevFolder())
               {
                  thisFile = new File(File.applicationDirectory.nativePath);
                  gameConfigDir = getFolderAndCreateIfNotExists(thisFile,"Config");
                  rootIsDev = true;
               }
               else
               {
                  thisFile = new File(File.applicationDirectory.nativePath);
                  while(true)
                  {
                     gameFolder = thisFile.resolvePath("Game");
                     configFolder = thisFile.resolvePath("Config");
                     if(gameFolder.exists)
                     {
                        gameConfigDir = getFolderAndCreateIfNotExists(gameFolder,"Config");
                        break;
                     }
                     if(configFolder.exists)
                     {
                        gameConfigDir = configFolder;
                        break;
                     }
                     thisFile = thisFile.parent;
                     if(thisFile == null)
                     {
                        break;
                     }
                  }
                  if(gameConfigDir == null)
                  {
                     if(rootDir != null)
                     {
                        if(isTencent || isGarena)
                        {
                           gameDir = getFolderAndCreateIfNotExists(rootDir,"Game");
                           gameConfigDir = getFolderAndCreateIfNotExists(gameDir,"Config");
                        }
                        else
                        {
                           gameConfigDir = getFolderAndCreateIfNotExists(rootDir,"Config");
                        }
                     }
                  }
               }
            }
         }
         catch(e:Error)
         {
            getLogger(RiotRootDir).warn("Failed to fetch game root directory: " + e.message);
         }
         return gameConfigDir;
      }
      
      public static function getFolderAndCreateIfNotExists(param1:File, param2:String) : File
      {
         var _loc3_:File = param1.resolvePath(param2);
         if(!_loc3_.exists)
         {
            _loc3_.createDirectory();
         }
         return _loc3_;
      }
      
      public static function getRoot() : File
      {
         var thisFile:File = null;
         var ary:Array = null;
         var f:File = null;
         try
         {
            if(rootDir == null)
            {
               if(isDevFolder())
               {
                  rootDir = new File(File.applicationDirectory.nativePath);
                  rootIsDev = true;
               }
               else
               {
                  thisFile = new File(File.applicationDirectory.nativePath);
                  while(true)
                  {
                     ary = thisFile.getDirectoryListing();
                     for each(f in ary)
                     {
                        if(f.name.indexOf("lol.launcher") > -1)
                        {
                           if(f.name.toLowerCase().indexOf("pbe") > -1)
                           {
                              isPBE = true;
                           }
                           if(f.name.toLowerCase().indexOf("tencent") > -1)
                           {
                              isTencent = true;
                           }
                           rootDir = thisFile;
                           break;
                        }
                        if(f.name == "RADS")
                        {
                           rootDir = thisFile;
                           break;
                        }
                     }
                     if(rootDir != null)
                     {
                        break;
                     }
                     thisFile = thisFile.parent;
                     if(thisFile == null)
                     {
                        break;
                     }
                  }
               }
            }
         }
         catch(e:Error)
         {
            getLogger(RiotRootDir).warn("Failed to fetch root directory: " + e.message);
         }
         return rootDir;
      }
   }
}

