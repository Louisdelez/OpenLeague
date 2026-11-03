package com.riotgames.displayheuristics
{
   public class PathInfo
   {
      
      public var path:String;
      
      private var _pathSegments:Vector.<Vector.<String>>;
      
      public function PathInfo(param1:String)
      {
         super();
         this.path = param1;
      }
      
      public static function analyzePath(param1:String) : Vector.<Vector.<String>>
      {
         var _loc3_:Object = null;
         var _loc6_:String = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:RegExp = null;
         param1 = param1.substring(0,1).toUpperCase() + param1.substring(1);
         var _loc2_:RegExp = /([A-Z])([A-Z]+)[^a-z]/g;
         while(Boolean(_loc3_ = _loc2_.exec(param1)))
         {
            param1 = param1.substring(0,_loc3_.index + 1) + _loc3_[2].toLowerCase() + param1.substring(_loc3_.index + _loc3_[2].length + 1);
         }
         var _loc4_:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
         var _loc5_:Array = param1.split(".");
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = new Vector.<String>();
            _loc8_ = /.[a-z]+|[0-9]+/g;
            while(Boolean(_loc3_ = _loc8_.exec(_loc6_)))
            {
               addWord(_loc7_,_loc3_[0]);
            }
            _loc4_[_loc4_.length] = _loc7_;
         }
         return _loc4_;
      }
      
      private static function addWord(param1:Vector.<String>, param2:String) : void
      {
         param2 = param2.replace(/[^A-Za-z0-9]/g,"");
         if(param2.length == 0)
         {
            return;
         }
         param2 = param2.toLowerCase();
         if(DisplayHeuristicsConfig.STOP_WORDS.indexOf(param2) == -1)
         {
            param1[param1.length] = param2;
         }
      }
      
      public function get pathSegments() : Vector.<Vector.<String>>
      {
         if(this._pathSegments == null)
         {
            this._pathSegments = analyzePath(this.path);
         }
         return this._pathSegments;
      }
      
      public function toString() : String
      {
         return "[PathInfo path=" + this.path + "]";
      }
   }
}

