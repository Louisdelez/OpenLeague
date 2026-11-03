package com.riotgames.platform.common.utils.file
{
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   
   public class GameCfgData
   {
      
      public static const groupedOpeners:Array = ["\"","<","["];
      
      public static const groupedClosers:Array = ["\"",">","]"];
      
      public static const commentChar:String = ";";
      
      private static const categorySeparatorChar:String = "*";
      
      private var categoryCache:Dictionary;
      
      private var sections:Array;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.platform.gameclient.utils.file.IniReader");
      
      public function GameCfgData()
      {
         super();
      }
      
      public static function deSerializeFromCloud(param1:ArrayCollection) : GameCfgData
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:ILogger = null;
         var _loc2_:GameCfgData = new GameCfgData();
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.search("\\" + categorySeparatorChar);
            _loc5_ = false;
            if(_loc4_ > 0)
            {
               _loc6_ = _loc3_.slice(0,_loc4_);
               _loc7_ = _loc3_.slice(_loc4_ + 1);
               _loc4_ = _loc7_.search("\\" + categorySeparatorChar);
               if(_loc4_ > 0)
               {
                  _loc8_ = _loc7_.slice(0,_loc4_);
                  _loc9_ = _loc7_.slice(_loc4_ + 1);
                  _loc2_.setValue(_loc6_,_loc8_,_loc9_);
                  _loc5_ = true;
               }
            }
            if(!_loc5_)
            {
               _loc10_ = Log.getLogger("com.riotgames.platform.gameclient.utils.file.IniReader");
               _loc10_.warn("deSerializeFromCloud: error processing key=" + _loc3_);
            }
         }
         return _loc2_;
      }
      
      private static function isCharOpener(param1:String) : int
      {
         if(param1.length < 1)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < groupedOpeners.length)
         {
            if(groupedOpeners[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function createCache() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:CfgCategory = null;
         if(this.sections == null)
         {
            this.sections = [];
         }
         this.categoryCache = new Dictionary();
         for each(_loc1_ in this.sections)
         {
            if(_loc1_ is CfgCategory)
            {
               _loc2_ = _loc1_;
               this.categoryCache[_loc2_.name] = _loc2_;
               _loc2_.createCache();
            }
         }
      }
      
      private function buildEntry(param1:String) : CfgEntry
      {
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:int = param1.indexOf("=");
         if(_loc2_ == -1)
         {
            this.logger.warn("no key value pair found in line: " + param1);
            return null;
         }
         var _loc3_:String = StringUtil.trim(param1.substring(0,_loc2_));
         var _loc4_:String = param1.substr(_loc2_ + 1);
         var _loc5_:String = _loc4_;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc9_ = _loc4_.charAt(_loc7_);
            _loc10_ = isCharOpener(_loc9_);
            if(_loc10_ > -1)
            {
               _loc11_ = _loc4_.indexOf(groupedClosers[_loc10_],_loc7_);
               if(_loc11_ == -1)
               {
                  _loc7_++;
               }
               else
               {
                  _loc7_ = _loc11_ + 1;
               }
            }
            else
            {
               if(_loc9_ == commentChar)
               {
                  _loc5_ = _loc4_.slice(0,_loc7_);
                  _loc6_ = _loc4_.substr(_loc7_);
                  break;
               }
               _loc7_++;
            }
         }
         _loc5_ = StringUtil.trim(_loc5_);
         var _loc8_:CfgEntry = new CfgEntry();
         _loc8_.key = _loc3_;
         _loc8_.value = _loc5_;
         _loc8_.lineComment = _loc6_;
         return _loc8_;
      }
      
      public function serializeForCloud() : ArrayCollection
      {
         var _loc2_:CfgCategory = null;
         var _loc3_:CfgEntry = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.categoryCache)
         {
            for each(_loc3_ in _loc2_.contents)
            {
               _loc1_.addItem(_loc2_.name + categorySeparatorChar + _loc3_.key + categorySeparatorChar + _loc3_.value);
            }
         }
         return _loc1_;
      }
      
      public function setValue(param1:String, param2:String, param3:String, param4:String = null) : void
      {
         if(this.categoryCache == null)
         {
            this.createCache();
         }
         var _loc5_:CfgCategory = this.categoryCache[param1];
         if(!_loc5_)
         {
            _loc5_ = new CfgCategory();
            _loc5_.name = param1;
            _loc5_.createCache();
            this.sections.push(_loc5_);
            this.categoryCache[param1] = _loc5_;
         }
         if(Boolean(param4) && Boolean(param4.length > 0) && param4.charAt(0) != commentChar)
         {
            param4 = commentChar + param4;
         }
         _loc5_.setValue(param2,param3,param4);
      }
      
      public function render() : String
      {
         var _loc3_:* = undefined;
         var _loc4_:CfgCategory = null;
         var _loc5_:CfgEntry = null;
         var _loc6_:CfgEntry = null;
         var _loc1_:String = "";
         var _loc2_:String = File.lineEnding;
         for each(_loc3_ in this.sections)
         {
            if(_loc3_ is CfgCategory)
            {
               _loc4_ = _loc3_ as CfgCategory;
               _loc1_ += _loc4_.render() + _loc2_;
               for each(_loc5_ in _loc4_.contents)
               {
                  _loc1_ += _loc5_.render() + _loc2_;
               }
            }
            else if(_loc3_ is CfgEntry)
            {
               _loc6_ = _loc3_ as CfgEntry;
               _loc1_ += _loc6_.render() + _loc2_;
            }
            else
            {
               this.logger.error("bad section.");
            }
         }
         return _loc1_;
      }
      
      public function parse(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:CfgEntry = null;
         var _loc7_:int = 0;
         var _loc8_:CfgCategory = null;
         var _loc9_:CfgEntry = null;
         this.sections = [];
         var _loc2_:Array = this.sections;
         var _loc3_:RegExp = /[\f\n\r\x0b]+/m;
         var _loc4_:Array = param1.split(_loc3_);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.charAt(0) == commentChar || StringUtil.trim(_loc5_).length == 0)
            {
               _loc6_ = new CfgEntry();
               _loc6_.lineComment = _loc5_;
               _loc2_.push(_loc6_);
            }
            else if(_loc5_.charAt(0) == "[")
            {
               _loc7_ = _loc5_.lastIndexOf("]");
               if(_loc7_ == -1)
               {
                  this.logger.warn("readProperties: error processing category=" + _loc5_);
               }
               else
               {
                  _loc8_ = new CfgCategory();
                  _loc8_.name = _loc5_.slice(1,_loc7_);
                  this.sections.push(_loc8_);
                  _loc2_ = _loc8_.contents;
               }
            }
            else
            {
               _loc9_ = this.buildEntry(_loc5_);
               if(Boolean(_loc9_))
               {
                  if(_loc2_ == this.sections)
                  {
                     this.logger.warn("invalid property outside of a category, discarding: " + _loc5_);
                  }
                  else
                  {
                     _loc2_.push(_loc9_);
                  }
               }
            }
         }
         this.createCache();
      }
      
      public function readValue(param1:String, param2:String, param3:String) : String
      {
         var _loc5_:CfgCategory = null;
         var _loc4_:String = null;
         if(Boolean(this.categoryCache))
         {
            _loc5_ = this.categoryCache[param1];
            if(Boolean(_loc5_))
            {
               _loc4_ = _loc5_.readValue(param2);
            }
         }
         if(!_loc4_)
         {
            _loc4_ = param3;
         }
         return _loc4_;
      }
      
      public function findCategoryOfFirstOccuranceOfKey(param1:String) : String
      {
         var _loc2_:CfgCategory = null;
         for each(_loc2_ in this.categoryCache)
         {
            if(_loc2_.readValue(param1) != null)
            {
               return _loc2_.name;
            }
         }
         return "";
      }
   }
}

