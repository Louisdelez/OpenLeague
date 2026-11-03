package com.riotgames.pvpnet.system.wordfilter
{
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.utils.StringUtil;
   
   public class WordFilter
   {
      
      private static var _instance:WordFilter;
      
      private static const SEPARATORS:String = "[\\s!-/:-@[\\]^`{|}~]";
      
      private static const REGEXP_BOUNDARY:RegExp = new RegExp("(" + SEPARATORS + ")");
      
      private static const ASTERISKS:String = "********************************************************";
      
      private var _userPreferencesManager:UserPreferencesManager = UserPreferencesManager.instance;
      
      private var isEnabled:Boolean = true;
      
      private var _wholeWordFiltering:Boolean = true;
      
      private var badWordList:Array;
      
      private var restrictedWordList:Array;
      
      private var allowedCharacterMap:Object = null;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function WordFilter()
      {
         super();
         this.userPreferencesManager = UserPreferencesManager.instance;
      }
      
      public static function get instance() : WordFilter
      {
         if(_instance == null)
         {
            _instance = new WordFilter();
         }
         return _instance;
      }
      
      public function get userPreferencesManager() : UserPreferencesManager
      {
         return this._userPreferencesManager;
      }
      
      public function set userPreferencesManager(param1:UserPreferencesManager) : void
      {
         this._userPreferencesManager = param1;
         this.isEnabled = UserPreferencesManager.userPrefs.EnableChatFilter;
         this.userPreferencesManager.addEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.onUserPreferencesLoaded);
         this.userPreferencesManager.addEventListener(UserPreferencesManager.USER_PREFERENCES_SAVED,this.onUserPreferencesSaved);
      }
      
      public function get wholeWordFiltering() : Boolean
      {
         return this._wholeWordFiltering;
      }
      
      public function set wholeWordFiltering(param1:Boolean) : void
      {
         this._wholeWordFiltering = param1;
      }
      
      public function initialize(param1:String, param2:String, param3:String, param4:String) : void
      {
         if(param1 == "zh_CN")
         {
            this.wholeWordFiltering = false;
         }
         this.loadBadWordList(param2);
         this.loadRestrictedWordList(param3);
         this.loadAllowedCharacters(param4);
      }
      
      private function loadBadWordList(param1:String) : void
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            this.logger.error("Bad words list is null!");
         }
         else
         {
            _loc2_ = param1.split(",");
            this.badWordList = _loc2_.map(this.scrubWord);
            this.badWordList = this.sortByLength(this.badWordList);
         }
      }
      
      private function loadRestrictedWordList(param1:String) : void
      {
         var _loc2_:Array = null;
         if(param1 == null)
         {
            this.logger.error("Restricted words list is null!");
         }
         else
         {
            _loc2_ = param1.split(",");
            this.restrictedWordList = _loc2_.map(this.scrubWord);
            this.restrictedWordList = this.sortByLength(this.restrictedWordList);
         }
      }
      
      private function loadAllowedCharacters(param1:String) : void
      {
         var _loc2_:int = 0;
         if(Boolean(param1) && param1.length > 0)
         {
            this.allowedCharacterMap = {};
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               this.allowedCharacterMap[param1.charAt(_loc2_)] = true;
               _loc2_++;
            }
         }
      }
      
      public function getInvalidCharacters(param1:String) : Array
      {
         var _loc4_:String = null;
         if(!this.allowedCharacterMap)
         {
            return null;
         }
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc3_);
            if(!this.allowedCharacterMap[_loc4_])
            {
               if(!_loc2_)
               {
                  _loc2_ = [];
               }
               if(_loc2_.indexOf(_loc4_) == -1)
               {
                  _loc2_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function maskOffensiveWords(param1:String) : String
      {
         var _loc3_:WordFilterEntry = null;
         var _loc4_:RegExp = null;
         if(param1 == null || !this.isEnabled)
         {
            return param1;
         }
         var _loc2_:String = param1;
         for each(_loc3_ in this.badWordList)
         {
            if("" != _loc3_.plainText)
            {
               if(_loc2_.toLocaleLowerCase().indexOf(_loc3_.plainText) >= 0)
               {
                  _loc4_ = this.getASCIIRegExp(_loc3_.regexText,this.wholeWordFiltering);
                  if(_loc4_ == null)
                  {
                     _loc2_ = this.filterUnicodeBadWordBoundary(_loc3_.plainText,param1);
                  }
                  else
                  {
                     _loc2_ = param1.replace(_loc4_,WordFilter.ASTERISKS.substring(0,_loc3_.plainText.length));
                  }
                  param1 = _loc2_;
               }
            }
         }
         return _loc2_;
      }
      
      private function filterUnicodeBadWordBoundary(param1:String, param2:String) : String
      {
         var _loc5_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>();
         var _loc4_:Array = param2.split(REGEXP_BOUNDARY);
         for each(_loc5_ in _loc4_)
         {
            if(_loc5_.length > 0)
            {
               if(_loc5_.charAt(0).search(REGEXP_BOUNDARY) == 0)
               {
                  _loc3_.push(_loc5_);
               }
               else
               {
                  _loc3_.push(_loc5_.toLowerCase() == param1 ? ASTERISKS.substring(0,_loc5_.length) : _loc5_);
               }
            }
         }
         return _loc3_.join("");
      }
      
      private function testUnicodeBadWordBoundary(param1:String, param2:String) : Boolean
      {
         var _loc4_:String = null;
         var _loc3_:Array = param2.split(REGEXP_BOUNDARY);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.length > 0)
            {
               if(_loc4_.charAt(0).search(REGEXP_BOUNDARY) < 0 && _loc4_.toLowerCase() == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function containsWordFromWordsList(param1:String, param2:Array, param3:Boolean) : Boolean
      {
         var _loc6_:WordFilterEntry = null;
         var _loc7_:RegExp = null;
         if(param1 == null)
         {
            return false;
         }
         var _loc4_:Boolean = param3 ? false : this.wholeWordFiltering;
         var _loc5_:String = param1.toLocaleLowerCase();
         for each(_loc6_ in param2)
         {
            if("" != _loc6_.plainText)
            {
               if(_loc5_.indexOf(_loc6_.plainText) >= 0)
               {
                  _loc7_ = this.getASCIIRegExp(_loc6_.regexText,_loc4_);
                  if(_loc7_ == null)
                  {
                     return this.testUnicodeBadWordBoundary(_loc6_.plainText,param1);
                  }
                  return _loc7_.test(param1);
               }
            }
         }
         return false;
      }
      
      public function containsOffensiveWords(param1:String, param2:Boolean) : Boolean
      {
         return this.containsWordFromWordsList(param1,this.badWordList,param2);
      }
      
      public function containsRestrictedWords(param1:String, param2:Boolean) : Boolean
      {
         return this.containsWordFromWordsList(param1,this.restrictedWordList,param2);
      }
      
      private function getASCIIRegExp(param1:String, param2:Boolean) : RegExp
      {
         if(param2)
         {
            if(param1.match(/[\W]/gi).length > 0)
            {
               return null;
            }
            return new RegExp("\\b" + param1 + "\\b","gi");
         }
         return new RegExp(param1,"gi");
      }
      
      private function onUserPreferencesLoaded(param1:Event) : void
      {
         this.isEnabled = UserPreferencesManager.userPrefs.EnableChatFilter;
      }
      
      private function onUserPreferencesSaved(param1:Event) : void
      {
         this.isEnabled = UserPreferencesManager.userPrefs.EnableChatFilter;
      }
      
      private function scrubWord(param1:*, param2:int, param3:Array) : WordFilterEntry
      {
         var _loc4_:String = param1 as String;
         _loc4_ = StringUtil.trim(_loc4_).toLowerCase();
         return new WordFilterEntry(_loc4_);
      }
      
      private function sortByLength(param1:Array) : Array
      {
         var _loc6_:Object = null;
         var _loc7_:WordFilterEntry = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = param1[_loc4_] as WordFilterEntry;
            _loc8_ = _loc2_[_loc7_.plainText.length];
            if(_loc8_ == null)
            {
               _loc8_ = [];
            }
            _loc2_[_loc7_.plainText.length] = _loc8_;
            _loc8_.push(_loc7_);
            _loc4_++;
         }
         var _loc5_:Array = [];
         for(_loc6_ in _loc2_)
         {
            _loc9_ = _loc2_[_loc6_];
            _loc5_ = _loc5_.concat(_loc9_);
         }
         _loc5_.reverse();
         return _loc5_;
      }
   }
}

