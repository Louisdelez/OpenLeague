package org.igniterealtime.xiff.data.auth
{
   public class SHA1
   {
      
      private static var hex_chr:String = "0123456789abcdef";
      
      public function SHA1()
      {
         super();
      }
      
      public static function calcSHA1(param1:String) : String
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc2_:Array = SHA1.str2blks(param1);
         var _loc3_:Array = new Array(80);
         var _loc4_:Number = 1732584193;
         var _loc5_:Number = -271733879;
         var _loc6_:Number = -1732584194;
         var _loc7_:Number = 271733878;
         var _loc8_:Number = -1009589776;
         var _loc9_:Number = 0;
         while(_loc9_ < _loc2_.length)
         {
            _loc10_ = _loc4_;
            _loc11_ = _loc5_;
            _loc12_ = _loc6_;
            _loc13_ = _loc7_;
            _loc14_ = _loc8_;
            _loc15_ = 0;
            while(_loc15_ < 80)
            {
               if(_loc15_ < 16)
               {
                  _loc3_[_loc15_] = _loc2_[_loc9_ + _loc15_];
               }
               else
               {
                  _loc3_[_loc15_] = SHA1.rol(_loc3_[_loc15_ - 3] ^ _loc3_[_loc15_ - 8] ^ _loc3_[_loc15_ - 14] ^ _loc3_[_loc15_ - 16],1);
               }
               _loc16_ = Number(SHA1.safe_add(SHA1.safe_add(SHA1.rol(_loc4_,5),SHA1.ft(_loc15_,_loc5_,_loc6_,_loc7_)),SHA1.safe_add(SHA1.safe_add(_loc8_,_loc3_[_loc15_]),SHA1.kt(_loc15_))));
               _loc8_ = _loc7_;
               _loc7_ = _loc6_;
               _loc6_ = Number(SHA1.rol(_loc5_,30));
               _loc5_ = _loc4_;
               _loc4_ = _loc16_;
               _loc15_++;
            }
            _loc4_ = Number(SHA1.safe_add(_loc4_,_loc10_));
            _loc5_ = Number(SHA1.safe_add(_loc5_,_loc11_));
            _loc6_ = Number(SHA1.safe_add(_loc6_,_loc12_));
            _loc7_ = Number(SHA1.safe_add(_loc7_,_loc13_));
            _loc8_ = Number(SHA1.safe_add(_loc8_,_loc14_));
            _loc9_ += 16;
         }
         return SHA1.hex(_loc4_) + SHA1.hex(_loc5_) + SHA1.hex(_loc6_) + SHA1.hex(_loc7_) + SHA1.hex(_loc8_);
      }
      
      private static function hex(param1:Number) : String
      {
         var _loc2_:String = "";
         var _loc3_:Number = 7;
         while(_loc3_ >= 0)
         {
            _loc2_ += hex_chr.charAt(param1 >> _loc3_ * 4 & 0x0F);
            _loc3_--;
         }
         return _loc2_;
      }
      
      private static function str2blks(param1:String) : Array
      {
         var _loc2_:Number = (param1.length + 8 >> 6) + 1;
         var _loc3_:Array = new Array(_loc2_ * 16);
         var _loc4_:Number = 0;
         while(_loc4_ < _loc2_ * 16)
         {
            _loc3_[_loc4_] = 0;
            _loc4_++;
         }
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            _loc3_[_loc5_ >> 2] |= param1.charCodeAt(_loc5_) << 24 - _loc5_ % 4 * 8;
            _loc5_++;
         }
         _loc3_[_loc5_ >> 2] |= 128 << 24 - _loc5_ % 4 * 8;
         _loc3_[_loc2_ * 16 - 1] = param1.length * 8;
         return _loc3_;
      }
      
      private static function safe_add(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param1 & 0xFFFF) + (param2 & 0xFFFF);
         var _loc4_:Number = (param1 >> 16) + (param2 >> 16) + (_loc3_ >> 16);
         return _loc4_ << 16 | _loc3_ & 0xFFFF;
      }
      
      private static function rol(param1:Number, param2:Number) : Number
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
      
      private static function ft(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 < 20)
         {
            return param2 & param3 | ~param2 & param4;
         }
         if(param1 < 40)
         {
            return param2 ^ param3 ^ param4;
         }
         if(param1 < 60)
         {
            return param2 & param3 | param2 & param4 | param3 & param4;
         }
         return param2 ^ param3 ^ param4;
      }
      
      private static function kt(param1:Number) : Number
      {
         return param1 < 20 ? 1518500249 : (param1 < 40 ? 1859775393 : (param1 < 60 ? -1894007588 : -899497514));
      }
   }
}

