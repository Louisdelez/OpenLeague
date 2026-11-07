package com.rational.serialization.json
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import com.rational.utils.IntReference;
   import flash.Boot;
   import flash.utils.ByteArray;
   
   public class Decoder extends AbstractDecoder
   {
      
      public function Decoder()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
      }
      
      public function decodeValue(param1:ByteArray, param2:IntReference) : *
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:* = null as String;
         var _loc6_:Number = NaN;
         param2.referent = (_loc3_ = param2.referent) + 1;
         switch(li8(_loc3_))
         {
            case 0:
               _loc3_ = param2.referent;
               _loc4_ = li32(_loc3_);
               _loc3_ += 4;
               param1.position = _loc3_;
               _loc5_ = param1.readUTFBytes(_loc4_);
               param2.referent = param1.position;
               return _loc5_;
            case 1:
               var _temp_2:* = nullRegExp;
               _loc3_ = param2.referent;
               _loc4_ = li32(_loc3_);
               _loc3_ += 4;
               param1.position = _loc3_;
               _loc5_ = param1.readUTFBytes(_loc4_);
               param2.referent = param1.position;
               return _temp_2.split(_loc5_).join("\x00");
            case 2:
               _loc3_ = li8(param2.referent);
               param2.referent += 1;
               return _loc3_;
            case 3:
               _loc3_ = li16(param2.referent);
               param2.referent += 2;
               return _loc3_;
            case 4:
               _loc3_ = li32(param2.referent);
               param2.referent += 4;
               return _loc3_;
            case 5:
               _loc6_ = lf64(param2.referent);
               param2.referent += 8;
               return _loc6_;
            case 6:
               return decodeObject(param1,param2);
            case 7:
               return decodeArray(param1,param2);
            case 8:
               return true;
            case 9:
               return false;
            case 10:
               return null;
            default:
               Boot.lastError = new Error();
               throw new Error("fallthrough");
         }
      }
      
      public function decodeObject(param1:ByteArray, param2:IntReference) : *
      {
         var _loc4_:* = null as String;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as String;
         var _loc3_:* = {};
         loop0:
         while(true)
         {
            param2.referent = (_loc6_ = param2.referent) + 1;
            switch(li8(_loc6_))
            {
               case 0:
                  _loc6_ = param2.referent;
                  _loc7_ = li32(_loc6_);
                  _loc6_ += 4;
                  param1.position = _loc6_;
                  _loc8_ = param1.readUTFBytes(_loc7_);
                  param2.referent = param1.position;
                  _loc4_ = _loc8_;
                  _loc5_ = decodeValue(param1,param2);
                  _loc3_[_loc4_] = _loc5_;
                  break;
               case 1:
                  var _temp_4:* = nullRegExp;
                  _loc7_ = li32(_loc6_ = param2.referent);
                  _loc6_ += 4;
                  param1.position = _loc6_;
                  _loc8_ = param1.readUTFBytes(_loc7_);
                  param2.referent = param1.position;
                  _loc4_ = _temp_4.split(_loc8_).join("\x00");
                  _loc5_ = decodeValue(param1,param2);
                  _loc3_[_loc4_] = _loc5_;
                  break;
               case 11:
                  return _loc3_;
               default:
                  break loop0;
            }
         }
         Boot.lastError = new Error();
         throw new Error("fallthrough");
      }
      
      public function decodeArray(param1:ByteArray, param2:IntReference) : *
      {
         var _loc6_:* = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null as String;
         var _loc9_:Number = NaN;
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         loop0:
         while(true)
         {
            param2.referent = (_loc6_ = param2.referent) + 1;
            switch(li8(_loc6_))
            {
               case 0:
                  var _temp_4:* = _loc3_;
                  var _temp_3:* = _loc4_++;
                  _loc7_ = li32(_loc6_ = param2.referent);
                  _loc6_ += 4;
                  param1.position = _loc6_;
                  _loc8_ = param1.readUTFBytes(_loc7_);
                  param2.referent = param1.position;
                  _temp_4[_temp_3] = _loc8_;
                  break;
               case 1:
                  var _temp_8:* = _loc3_;
                  var _temp_7:* = _loc4_++;
                  var _temp_6:* = nullRegExp;
                  _loc7_ = li32(_loc6_ = param2.referent);
                  _loc6_ += 4;
                  param1.position = _loc6_;
                  _loc8_ = param1.readUTFBytes(_loc7_);
                  param2.referent = param1.position;
                  _temp_8[_temp_7] = _temp_6.split(_loc8_).join("\x00");
                  break;
               case 2:
                  var _temp_10:* = _loc3_;
                  var _temp_9:* = _loc4_++;
                  _loc6_ = li8(param2.referent);
                  param2.referent += 1;
                  _temp_10[_temp_9] = _loc6_;
                  break;
               case 3:
                  var _temp_12:* = _loc3_;
                  var _temp_11:* = _loc4_++;
                  _loc6_ = li16(param2.referent);
                  param2.referent += 2;
                  _temp_12[_temp_11] = _loc6_;
                  break;
               case 4:
                  var _temp_14:* = _loc3_;
                  var _temp_13:* = _loc4_++;
                  _loc6_ = li32(param2.referent);
                  param2.referent += 4;
                  _temp_14[_temp_13] = _loc6_;
                  break;
               case 5:
                  var _temp_16:* = _loc3_;
                  var _temp_15:* = _loc4_++;
                  _loc9_ = lf64(param2.referent);
                  param2.referent += 8;
                  _temp_16[_temp_15] = _loc9_;
                  break;
               case 6:
                  _loc3_[_loc4_++] = decodeObject(param1,param2);
                  break;
               case 7:
                  _loc3_[_loc4_++] = decodeArray(param1,param2);
                  break;
               case 8:
                  _loc3_[_loc4_++] = true;
                  break;
               case 9:
                  _loc3_[_loc4_++] = false;
                  break;
               case 10:
                  _loc3_[_loc4_++] = null;
                  break;
               case 11:
                  if(int(_loc3_.length) == 2 && (Std.§is§(_loc3_[0],String) && (_loc3_[0] == "time" && (Std.§is§(_loc3_[1],int) || Std.§is§(_loc3_[1],Number)))))
                  {
                     return new Date(_loc3_[1]);
                  }
                  return _loc3_;
                  break;
               default:
                  break loop0;
            }
         }
         Boot.lastError = new Error();
         throw new Error("fallthrough");
      }
      
      public function decode(param1:ByteArray, param2:int) : *
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc4_:int = int(param1.position);
         try
         {
            _loc5_ = decodeValue(param1,new IntReference(param2));
         }
         catch(_loc_e_:*)
         {
            param1.position = _loc4_;
            Boot.lastError = new Error();
            throw _loc6_;
         }
         param1.position = _loc4_;
         return _loc5_;
      }
   }
}

