package com.riotgames.platform.common.utils
{
   public class XORcipher
   {
      
      public static var DEFAULTKEY:String = "LeagueOfLegends_ByRiotGames";
      
      public var KEY:String;
      
      public function XORcipher(param1:String)
      {
         super();
         if(param1 != null)
         {
            this.KEY = param1;
         }
         else
         {
            this.KEY = DEFAULTKEY;
         }
      }
      
      public static function generateRandomKey(param1:int, param2:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz") : String
      {
         var _loc4_:int = 0;
         var _loc3_:Array = new Array();
         while(Boolean(param1--))
         {
            _loc4_ = Math.floor(Math.random() * param2.length);
            _loc3_.push(param2.charAt(_loc4_));
         }
         return _loc3_.join("");
      }
      
      public function xor_unescape(param1:String) : String
      {
         return this.xor(unescape(param1));
      }
      
      public function xor(param1:String) : String
      {
         var _loc2_:Array = new Array();
         var _loc3_:int = this.KEY.length;
         var _loc4_:Function = String.fromCharCode;
         var _loc5_:int = 0;
         var _loc6_:int = param1.length;
         while(_loc5_ < _loc6_)
         {
            _loc2_.push(_loc4_(param1.charCodeAt(_loc5_) ^ this.KEY.charCodeAt(_loc5_ % _loc3_)));
            _loc5_++;
         }
         return _loc2_.join("");
      }
      
      public function xor_escape(param1:String) : String
      {
         return escape(this.xor(param1));
      }
   }
}

