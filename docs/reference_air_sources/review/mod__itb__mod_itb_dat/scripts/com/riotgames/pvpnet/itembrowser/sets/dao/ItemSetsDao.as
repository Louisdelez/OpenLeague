package com.riotgames.pvpnet.itembrowser.sets.dao
{
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetItem;
   import com.riotgames.pvpnet.itembrowser.sets.service.IItemSetsService;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.file.RiotRootDir;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.json.jsonEncode;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class ItemSetsDao
   {
      
      private static const FILE_NAME_PREFIX:String = "RIOT_ItemSet_";
      
      private static const SHOULD_WRITE_ALL_SETS:Boolean = false;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var service:IItemSetsService;
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") var selfCache:ItemSetCache = new ItemSetCache();
      
      public function ItemSetsDao(param1:IItemSetsService)
      {
         super();
         this.service = param1;
      }
      
      private function marshallItemSet(param1:ItemSet, param2:Champion = null, param3:Boolean = true) : Object
      {
         var _loc5_:ItemSetBlock = null;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:ItemSetItem = null;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc4_:Object = {};
         _loc4_.title = param1.title;
         _loc4_.type = param1.type;
         _loc4_.map = "any";
         _loc4_.mode = "any";
         _loc4_.priority = false;
         _loc4_.sortrank = param1.sortrank;
         _loc4_.uid = param1.uid;
         if(param1.getIsGlobalForChampions())
         {
            _loc4_.isGlobalForChampions = true;
            _loc4_.associatedChampions = [];
         }
         else
         {
            _loc4_.isGlobalForChampions = false;
            _loc6_ = [];
            if(param2 != null)
            {
               _loc4_.champion = param2.skinName;
            }
            else
            {
               for each(_loc7_ in param1.getAssignedChampions())
               {
                  _loc6_.push(_loc7_);
               }
            }
            _loc4_.associatedChampions = _loc6_;
         }
         _loc4_.blocks = [];
         for each(_loc5_ in param1.blocks)
         {
            _loc8_ = {};
            _loc8_.type = _loc5_.type;
            if(_loc8_.type == null)
            {
               _loc8_.type = "";
            }
            _loc8_.items = [];
            for each(_loc9_ in _loc5_.items)
            {
               if(_loc9_.getGameItem())
               {
                  _loc10_ = {};
                  _loc10_.id = _loc9_.getGameItem().id.toString();
                  _loc10_.count = _loc9_.getStacks();
                  _loc8_.items.push(_loc10_);
               }
            }
            if(_loc8_.items.length > 0 || param3)
            {
               _loc4_.blocks.push(_loc8_);
            }
         }
         if(param1.getIsGlobalForMaps())
         {
            _loc4_.isGlobalForMaps = true;
            _loc4_.associatedMaps = [];
         }
         else
         {
            _loc4_.isGlobalForMaps = false;
            _loc11_ = [];
            for each(_loc12_ in param1.getAssignedMaps())
            {
               _loc11_.push(_loc12_);
            }
            _loc4_.associatedMaps = _loc11_;
         }
         return _loc4_;
      }
      
      private function writeFilesForGame(param1:Array, param2:File) : void
      {
         var dto2:Object = null;
         var outputJson:String = null;
         var fs:FileStream = null;
         var res:Array = param1;
         var outputDir:File = param2;
         var i:int = 0;
         while(res.length > 0)
         {
            dto2 = res.shift();
            i++;
            try
            {
               outputJson = jsonEncode(dto2);
               fs = new FileStream();
               fs.open(outputDir.resolvePath(FILE_NAME_PREFIX + i + ".json"),FileMode.WRITE);
               fs.writeMultiByte(outputJson,"utf-8");
            }
            catch(e:Error)
            {
               logger.error("0003 failed to write a recommended item set! " + e.errorID);
            }
         }
      }
      
      private function sanityCheckItemSet(param1:ItemSet) : ItemSet
      {
         if(param1.blocks.length == 0 || !param1.getIsGlobalForChampions() && param1.getAssignedChampions().length == 0 || !param1.getIsGlobalForMaps() && param1.getAssignedMaps().length == 0 || param1.type == "")
         {
            return null;
         }
         return param1;
      }
      
      private function getFolderAndCreateIfNotExists(param1:File, param2:String) : File
      {
         var _loc3_:File = param1.resolvePath(param2);
         if(!_loc3_.exists)
         {
            _loc3_.createDirectory();
         }
         return _loc3_;
      }
      
      public function getMyItemSets(param1:Function, param2:Function) : void
      {
         var successCallback:Function = param1;
         var errorCallback:Function = param2;
         var action:LoadMyItemStatsAction = new LoadMyItemStatsAction(this.service,this.selfCache,this.unmarshallItemSets);
         action.getCompleted().add(function(param1:LoadMyItemStatsAction):void
         {
            var _loc2_:Vector.<ItemSet> = param1.data;
            if(_loc2_ == null)
            {
               _loc2_ = new Vector.<ItemSet>();
            }
            successCallback.apply(null,[_loc2_]);
         });
         action.getErred().add(errorCallback);
         action.invoke();
      }
      
      private function unmarshallItemSet(param1:Object) : ItemSet
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:ItemSetBlock = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:uint = 0;
         var _loc2_:GameItemDao = new GameItemDao(ClientConfig.instance.locale,null);
         var _loc3_:ItemSet = new ItemSet();
         _loc3_.title = param1.title;
         if(param1.uid != null)
         {
            _loc3_.uid = param1.uid;
         }
         _loc3_.type = param1.type;
         _loc3_.sortrank = param1.sortrank as Number;
         _loc3_.setIsGlobalForMaps(param1.isGlobalForMaps);
         _loc3_.setIsGlobalForChampions(param1.isGlobalForChampions);
         if(param1.hasOwnProperty("associatedChampions"))
         {
            for each(_loc5_ in param1.associatedChampions)
            {
               _loc3_.addAssignedChampion(_loc5_);
            }
         }
         _loc3_.blocks = new Vector.<ItemSetBlock>();
         for each(_loc4_ in param1.blocks)
         {
            _loc6_ = new ItemSetBlock();
            _loc6_.type = _loc4_.type;
            _loc6_.items = new Vector.<ItemSetItem>();
            for each(_loc7_ in _loc4_.items)
            {
               _loc2_.getGameItemById(parseInt(_loc7_.id),this.gotGameItem,null,_loc6_,_loc7_.count);
            }
            _loc3_.blocks.push(_loc6_);
         }
         if(param1.hasOwnProperty("associatedMaps"))
         {
            _loc8_ = new Vector.<uint>();
            for each(_loc9_ in param1.associatedMaps)
            {
               _loc8_.push(_loc9_);
            }
            _loc3_.setAssignedMaps(_loc8_);
         }
         return this.sanityCheckItemSet(_loc3_);
      }
      
      private function unmarshallItemSets(param1:String) : Vector.<ItemSet>
      {
         var sets:Vector.<ItemSet> = null;
         var setDTO:Object = null;
         var dto:Object = null;
         var itemSet:ItemSet = null;
         var json:String = param1;
         sets = new Vector.<ItemSet>();
         try
         {
            dto = jsonDecode(json);
         }
         catch(e:Error)
         {
            return sets;
         }
         for each(setDTO in dto.itemSets)
         {
            itemSet = this.unmarshallItemSet(setDTO);
            if(itemSet)
            {
               sets.push(itemSet);
            }
         }
         return sets;
      }
      
      public function jsonToItemSet(param1:String) : ItemSet
      {
         var decodedJSON:Object = null;
         var itemSet:ItemSet = null;
         var json:String = param1;
         try
         {
            decodedJSON = jsonDecode(json);
            try
            {
               itemSet = this.unmarshallItemSet(decodedJSON);
               return itemSet;
            }
            catch(e:Error)
            {
               return null;
            }
         }
         catch(e:Error)
         {
            return null;
         }
      }
      
      public function saveMyItemSets(param1:Vector.<ItemSet>, param2:Function, param3:Function) : void
      {
         var _loc5_:ItemSet = null;
         var _loc6_:Number = NaN;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc4_:Array = [];
         for each(_loc5_ in param1)
         {
            _loc9_ = this.marshallItemSet(_loc5_);
            _loc4_.push(_loc9_);
         }
         _loc6_ = new Date().getTime();
         this.selfCache.timeStamp = _loc6_;
         _loc7_ = {};
         _loc7_.timeStamp = _loc6_;
         _loc7_.itemSets = _loc4_;
         _loc8_ = jsonEncode(_loc7_);
         this.service.saveItemSets(_loc8_,param2);
      }
      
      private function gotGameItem(param1:GameItem, param2:ItemSetBlock, param3:int) : void
      {
         var _loc4_:ItemSetItem = null;
         if(param1)
         {
            _loc4_ = new ItemSetItem(param1,param3);
            param2.addItem(_loc4_);
         }
      }
      
      public function itemSetToJSON(param1:ItemSet) : String
      {
         var _loc2_:Object = this.marshallItemSet(param1);
         return jsonEncode(_loc2_);
      }
      
      public function outputItemSetsForChampion(param1:Vector.<ItemSet>, param2:Champion, param3:Number, param4:Function, param5:Function) : void
      {
         var _loc7_:Array = null;
         var _loc6_:File = this.getCleanOutputDirForChampion(param2);
         if(_loc6_ != null && Boolean(_loc6_.exists))
         {
            _loc7_ = this.buildSortedListOfItemSetsForMapAndChamp(param1,param2,param3);
            if(_loc7_.length > 0)
            {
               this.writeFilesForGame(_loc7_,_loc6_);
            }
         }
         else
         {
            param5.apply();
         }
      }
      
      public function multipleItemSetsToJSON(param1:Vector.<ItemSet>) : String
      {
         var _loc3_:ItemSet = null;
         var _loc4_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = this.marshallItemSet(_loc3_);
            _loc2_.push(_loc4_);
         }
         return jsonEncode(_loc2_);
      }
      
      private function getBlankItemSet() : ItemSet
      {
         var _loc1_:ItemSet = new ItemSet();
         _loc1_.title = ResourceManager.getInstance().getString("itemBrowser","customItemSet") + " 1";
         return _loc1_;
      }
      
      private function getCleanOutputDirForChampion(param1:Champion) : File
      {
         var directory:File = null;
         var filelisting:Array = null;
         var oldFile:File = null;
         var champion:Champion = param1;
         try
         {
            directory = this.getOutputDirForChampion(champion);
         }
         catch(e1:Error)
         {
            logger.error("0001 unable to locate the output folder for item sets " + e1.errorID);
            return null;
         }
         if(directory != null && Boolean(directory.exists) && Boolean(directory.isDirectory))
         {
            filelisting = directory.getDirectoryListing();
            for each(oldFile in filelisting)
            {
               if(oldFile.name.indexOf(FILE_NAME_PREFIX) > -1)
               {
                  try
                  {
                     oldFile.deleteFile();
                  }
                  catch(e2:Error)
                  {
                     logger.error("0002 unable to delete an item set. " + e2.errorID);
                  }
               }
            }
         }
         return directory;
      }
      
      private function getOutputDirForChampion(param1:Champion) : File
      {
         var _loc2_:File = null;
         if(RiotRootDir.isDevFolder())
         {
            _loc2_ = new File(File.applicationDirectory.nativePath);
            _loc2_ = this.getFolderAndCreateIfNotExists(_loc2_,"devItemSetOutput");
         }
         else
         {
            _loc2_ = RiotRootDir.getGameConfigFolder();
         }
         _loc2_ = this.getFolderAndCreateIfNotExists(_loc2_,"Champions");
         _loc2_ = this.getFolderAndCreateIfNotExists(_loc2_,param1.skinName);
         return this.getFolderAndCreateIfNotExists(_loc2_,"Recommended");
      }
      
      public function jsonToMultipleItemSets(param1:String) : Vector.<ItemSet>
      {
         var sets:Vector.<ItemSet> = null;
         var setDTO:Object = null;
         var dto:Object = null;
         var itemSet:ItemSet = null;
         var json:String = param1;
         sets = new Vector.<ItemSet>();
         try
         {
            dto = jsonDecode(json);
         }
         catch(e:Error)
         {
            return sets;
         }
         for each(setDTO in dto)
         {
            itemSet = this.unmarshallItemSet(setDTO);
            if(itemSet)
            {
               sets.push(itemSet);
            }
         }
         return sets;
      }
      
      private function buildSortedListOfItemSetsForMapAndChamp(param1:Vector.<ItemSet>, param2:Champion, param3:Number) : Array
      {
         var _loc9_:ItemSet = null;
         var _loc10_:Array = null;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:Boolean = false;
         var _loc18_:Array = null;
         var _loc19_:ItemSetBlock = null;
         var _loc20_:Object = null;
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         for each(_loc9_ in param1)
         {
            _loc11_ = _loc9_.isChampionIdAssignedToThisItemSet(param2.championId);
            _loc12_ = _loc9_.getIsGlobalForChampions();
            _loc13_ = _loc9_.isMapAssignedToThisItemSet(param3);
            _loc14_ = _loc9_.getIsGlobalForMaps();
            _loc15_ = false;
            _loc16_ = _loc9_.blocks.length > 0;
            _loc17_ = false;
            if(_loc16_)
            {
               for each(_loc19_ in _loc9_.blocks)
               {
                  if(_loc19_.items.length > 0)
                  {
                     _loc17_ = true;
                     break;
                  }
               }
            }
            if(SHOULD_WRITE_ALL_SETS)
            {
               _loc15_ = true;
            }
            else if(!(!_loc16_ || !_loc17_))
            {
               if(!_loc12_ && _loc11_ && !_loc14_ && _loc13_)
               {
                  _loc15_ = true;
                  _loc18_ = _loc5_;
                  _loc9_.type = ItemSet.TYPE_CUSTOM_IMPORTANCE6;
                  _loc9_.sortrank = 10000 - _loc9_.getAssignedChampions().length;
               }
               else if(!_loc12_ && _loc11_ && _loc14_)
               {
                  _loc15_ = true;
                  _loc18_ = _loc6_;
                  _loc9_.type = ItemSet.TYPE_CUSTOM_IMPORTANCE6;
                  _loc9_.sortrank = 5000 - _loc9_.getAssignedChampions().length;
               }
               else if(_loc12_ && !_loc14_ && _loc13_)
               {
                  _loc15_ = true;
                  _loc18_ = _loc7_;
                  _loc9_.type = ItemSet.TYPE_GLOBAL_IMPORTANCE4;
                  _loc9_.sortrank = 6;
               }
               else if(_loc12_ && _loc14_)
               {
                  _loc15_ = true;
                  _loc18_ = _loc8_;
                  _loc9_.type = ItemSet.TYPE_GLOBAL_IMPORTANCE4;
                  _loc9_.sortrank = 4;
               }
            }
            if(_loc15_)
            {
               _loc20_ = this.marshallItemSet(_loc9_,param2,false);
               _loc18_.push(_loc20_);
            }
         }
         _loc10_ = [];
         return _loc10_.concat(_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
   }
}

