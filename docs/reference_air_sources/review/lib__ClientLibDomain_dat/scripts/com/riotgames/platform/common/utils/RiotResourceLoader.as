package com.riotgames.platform.common.utils
{
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.Item;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.errors.IOError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceBundle;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceBundle;
   import mx.resources.ResourceManager;
   
   public class RiotResourceLoader
   {
      
      public static var RESOURCES_MAP:String = "map_resources";
      
      public static var RESOURCES_CHAMPION:String = "champion_resources";
      
      public static var RESOURCES_CHAMPION_SKIN:String = "champion_skin_resources";
      
      public static var RESOURCES_SPELL:String = "spell_resources";
      
      public static var RESOURCES_TALENT:String = "talent_resources";
      
      public static var RESOURCES_ITEM:String = "item_resources";
      
      public static var RESOURCES_EFFECT:String = "effect_resources";
      
      public static var RESOURCES_STATS:String = "statistic_resources";
      
      public static var RESOURCES_TAGS:String = "champion_search_tag_resources";
      
      public static var RESOURCES_FILTER:String = "filter_resources";
      
      public static var RESOURCES_STRING:String = "resources";
      
      public static var RESOURCES_TYPES:Array = [RESOURCES_MAP,RESOURCES_CHAMPION,RESOURCES_CHAMPION_SKIN,RESOURCES_SPELL,RESOURCES_TALENT,RESOURCES_ITEM,RESOURCES_EFFECT,RESOURCES_STATS,RESOURCES_TAGS,RESOURCES_FILTER,RESOURCES_STRING];
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.RiotResourceLoader");
      
      private static var calcRemovalRegex:RegExp = /\([^\(]*<calc>[^<]*<\/calc>[^\)]*\)/g;
      
      public function RiotResourceLoader()
      {
         super();
      }
      
      public static function getTalentResourceString(param1:String, param2:int, param3:int) : String
      {
         var _loc4_:String = "summoner_data_talent_" + param1;
         if(param3 > -1)
         {
            _loc4_ += param3;
         }
         _loc4_ += "_" + param2;
         return getResourceString(RESOURCES_TALENT,_loc4_,"Undefined " + param1 + param2);
      }
      
      public static function getString(param1:String, param2:String = null, param3:Array = null) : String
      {
         return getResourceString(RESOURCES_STRING,param1,param2,param3);
      }
      
      public static function getSpellResourceString(param1:String, param2:String, param3:String) : String
      {
         return getResourceString(RESOURCES_SPELL,"summoner_data_spell_" + param1 + "_" + param2,param3);
      }
      
      public static function getMapResourceString(param1:String, param2:int, param3:String) : String
      {
         return getResourceString(RESOURCES_MAP,"map_" + param1 + "_" + param2,param3);
      }
      
      public static function registerFlatFile(param1:String, param2:String, param3:String = "{0}") : void
      {
         var file:File;
         var content:String = null;
         var fileStream:FileStream = null;
         var bundle:UserResourceBundle = null;
         var resourceId:String = param1;
         var path:String = param2;
         var pathLocaleToken:String = param3;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var locale:String = resourceManager.localeChain[0];
         if(pathLocaleToken != null)
         {
            path = path.replace(pathLocaleToken,locale);
         }
         if(path.charAt(0) != "/")
         {
            path = "/" + path;
         }
         file = new File(File.applicationDirectory.nativePath + path);
         if(file.exists)
         {
            fileStream = new FileStream();
            try
            {
               fileStream.open(file,FileMode.READ);
            }
            catch(e:IOError)
            {
               logger.error("IOError: Unable to read file: " + path);
               return;
            }
            catch(e:SecurityError)
            {
               logger.error("SecurityError: Unable to read file: " + path);
               return;
            }
            content = fileStream.readUTFBytes(fileStream.bytesAvailable);
            fileStream.close();
            bundle = new UserResourceBundle(resourceId,locale);
            bundle.parse(content);
            addOrAppendResourceBundle(bundle);
            resourceManager.update();
         }
      }
      
      public static function getChampionSkinResourceString(param1:String, param2:String, param3:Number, param4:String) : String
      {
         return getResourceString(RESOURCES_CHAMPION_SKIN,"champion_skin_" + param1 + "_" + param2 + "_" + param3,param4);
      }
      
      public static function loadMapResourceStrings(param1:ArrayCollection) : void
      {
         var _loc2_:GameMap = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc2_.displayName = getMapResourceString("displayname",_loc2_.mapId,"**" + _loc2_.displayName);
            _loc2_.description = getMapResourceString("description",_loc2_.mapId,"**" + _loc2_.description);
         }
      }
      
      public static function loadSpellResourceStrings(param1:ArrayCollection) : void
      {
         var _loc2_:Spell = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc2_.displayName = getSpellResourceString("name",_loc2_.name,_loc2_.name + "*");
            _loc2_.description = getSpellResourceString("description",_loc2_.name,_loc2_.description + "*");
         }
      }
      
      public static function getSearchTagResourceString(param1:String, param2:String) : String
      {
         return getResourceString(RESOURCES_TAGS,"champion_search_tag_" + param1,param2);
      }
      
      public static function getStatResourceString(param1:String, param2:String) : String
      {
         return getResourceString(RESOURCES_STATS,param1,param2);
      }
      
      public static function loadStatisticResourceStrings(param1:ArrayCollection) : void
      {
         var _loc2_:Object = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc2_.displayName = getResourceString(RESOURCES_STATS,_loc2_.statTypeName,"**" + _loc2_.description);
         }
      }
      
      public static function loadStatisticAndChampionResourceStrings(param1:ArrayCollection, param2:Array) : void
      {
         var _loc3_:AggregatedStat = null;
         var _loc4_:Champion = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc3_ in param1)
         {
            _loc3_.displayName = getResourceString(RESOURCES_STATS,_loc3_.statTypeName,"**" + _loc3_.description);
            _loc3_.championDisplayName = null;
            if(_loc3_.championId > 0)
            {
               _loc4_ = param2[_loc3_.championId];
               if(Boolean(_loc4_))
               {
                  _loc3_.championDisplayName = _loc4_.displayName;
               }
            }
         }
      }
      
      public static function getFilterString(param1:String, param2:String = null, param3:Array = null) : String
      {
         return getResourceString(RESOURCES_FILTER,param1,param2,param3);
      }
      
      public static function getItemResourceString(param1:String, param2:int, param3:String) : String
      {
         var _loc4_:String = getResourceString(RESOURCES_ITEM,"summoner_data_item_" + param1 + "_" + param2,param3);
         if(param1 === "description")
         {
            _loc4_ = _loc4_.replace(calcRemovalRegex,"");
         }
         return _loc4_;
      }
      
      public static function getEffectResourceString(param1:String, param2:String, param3:String) : String
      {
         return getResourceString(RESOURCES_EFFECT,"summoner_data_effect_" + param1 + "_" + param2,param3);
      }
      
      public static function getChampionResourceString(param1:String, param2:String, param3:String) : String
      {
         return getResourceString(RESOURCES_CHAMPION,"champion_" + param1 + "_" + param2,param3);
      }
      
      public static function loadItemResourceStrings(param1:ArrayCollection) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Item = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.item;
            _loc3_.name = getItemResourceString("name",_loc3_.gameCode,"resource not found!");
            _loc3_.description = getItemResourceString("description",_loc3_.gameCode,"resource not found!");
            _loc3_.uniqueEffect = getItemResourceString("uniqueEffect",_loc3_.gameCode,"resource not found!");
         }
      }
      
      public static function getResourceString(param1:String, param2:String, param3:String, param4:Array = null) : String
      {
         var _loc5_:String = ResourceManager.getInstance().getString(param1,param2,param4);
         if(param3 == null)
         {
            param3 = "**" + param2;
         }
         if(_loc5_ == null)
         {
            _loc5_ = param3;
         }
         return _loc5_;
      }
      
      private static function addOrAppendResourceBundle(param1:ResourceBundle) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:String = _loc2_.localeChain[0];
         var _loc4_:IResourceBundle = _loc2_.getResourceBundle(_loc3_,param1.bundleName);
         if(Boolean(_loc4_))
         {
            appendToExistingResourceBundle(_loc4_,param1);
         }
         else
         {
            _loc2_.addResourceBundle(param1);
         }
      }
      
      private static function appendToExistingResourceBundle(param1:IResourceBundle, param2:IResourceBundle) : void
      {
         var _loc5_:String = null;
         var _loc3_:Object = param1.content;
         var _loc4_:Object = param2.content;
         for(_loc5_ in _loc4_)
         {
            _loc3_[_loc5_] = _loc4_[_loc5_];
         }
      }
   }
}

