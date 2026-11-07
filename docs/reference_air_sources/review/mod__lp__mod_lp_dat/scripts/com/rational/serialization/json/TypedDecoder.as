package com.rational.serialization.json
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import com.rational.utils.DescribeTypeCache;
   import com.rational.utils.IProperty;
   import com.rational.utils.IntReference;
   import com.rational.utils.Record;
   import flash.Boot;
   import flash.utils.ByteArray;
   
   public class TypedDecoder extends AbstractDecoder
   {
      
      public var typeCache:DescribeTypeCache;
      
      public function TypedDecoder()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         super();
         typeCache = new DescribeTypeCache(Record.newInstance);
      }
      
      public function getRecord(param1:Class) : Record
      {
         return typeCache.describeType(param1);
      }
      
      public function decodeValue(param1:ByteArray, param2:IntReference, param3:Class) : *
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null as String;
         var _loc7_:Number = NaN;
         param2.referent = (_loc4_ = param2.referent) + 1;
         switch(li8(_loc4_))
         {
            case 0:
               _loc4_ = param2.referent;
               _loc5_ = li32(_loc4_);
               _loc4_ += 4;
               param1.position = _loc4_;
               _loc6_ = param1.readUTFBytes(_loc5_);
               param2.referent = param1.position;
               return _loc6_;
            case 1:
               var _temp_4:* = nullRegExp;
               _loc5_ = li32(_loc4_ = param2.referent);
               _loc4_ += 4;
               param1.position = _loc4_;
               _loc6_ = param1.readUTFBytes(_loc5_);
               param2.referent = param1.position;
               return _temp_4.split(_loc6_).join("\x00");
            case 2:
               _loc4_ = li8(param2.referent);
               param2.referent += 1;
               return _loc4_;
            case 3:
               _loc4_ = li16(param2.referent);
               param2.referent += 2;
               return _loc4_;
            case 4:
               _loc4_ = li32(param2.referent);
               param2.referent += 4;
               return _loc4_;
            case 5:
               _loc7_ = lf64(param2.referent);
               param2.referent += 8;
               return _loc7_;
            case 6:
               return decodeObject(param1,param2,typeCache.describeType(param3));
            case 7:
               return decodeArray(param1,param2,typeCache.describeType(param3));
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
      
      public function decodeProperty(param1:ByteArray, param2:IntReference, param3:IProperty) : *
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null as String;
         var _loc7_:Number = NaN;
         param2.referent = (_loc4_ = param2.referent) + 1;
         switch(li8(_loc4_))
         {
            case 0:
               _loc4_ = param2.referent;
               _loc5_ = li32(_loc4_);
               _loc4_ += 4;
               param1.position = _loc4_;
               _loc6_ = param1.readUTFBytes(_loc5_);
               param2.referent = param1.position;
               return _loc6_;
            case 1:
               var _temp_4:* = nullRegExp;
               _loc5_ = li32(_loc4_ = param2.referent);
               _loc4_ += 4;
               param1.position = _loc4_;
               _loc6_ = param1.readUTFBytes(_loc5_);
               param2.referent = param1.position;
               return _temp_4.split(_loc6_).join("\x00");
            case 2:
               _loc4_ = li8(param2.referent);
               param2.referent += 1;
               return _loc4_;
            case 3:
               _loc4_ = li16(param2.referent);
               param2.referent += 2;
               return _loc4_;
            case 4:
               _loc4_ = li32(param2.referent);
               param2.referent += 4;
               return _loc4_;
            case 5:
               _loc7_ = lf64(param2.referent);
               param2.referent += 8;
               return _loc7_;
            case 6:
               return decodeObject(param1,param2,typeCache.describeType(param3.getType()));
            case 7:
               return decodeArray(param1,param2,typeCache.describeType(param3.getElementType()));
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
      
      public function decodeObject(param1:ByteArray, param2:IntReference, param3:Record) : Object
      {
         var _loc5_:* = null as String;
         var _loc6_:* = null as IProperty;
         var _loc7_:* = null;
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         var _loc10_:* = null as String;
         var _loc11_:Boolean = false;
         var _loc4_:Object = Type.createInstance(param3.type,[]);
         loop0:
         while(true)
         {
            param2.referent = (_loc8_ = param2.referent) + 1;
            switch(li8(_loc8_))
            {
               case 0:
                  _loc8_ = param2.referent;
                  _loc9_ = li32(_loc8_);
                  _loc8_ += 4;
                  param1.position = _loc8_;
                  _loc10_ = param1.readUTFBytes(_loc9_);
                  param2.referent = param1.position;
                  _loc5_ = _loc10_;
                  _loc6_ = param3.getProperty(_loc5_);
                  _loc7_ = decodeProperty(param1,param2,_loc6_);
                  while(true)
                  {
                     _loc10_ = _loc6_.getAccess();
                     if(_loc10_ != "writeonly")
                     {
                        if(_loc10_ != "readwrite")
                        {
                           _loc11_ = false;
                           break;
                        }
                     }
                     _loc11_ = true;
                     break;
                  }
                  if(_loc11_)
                  {
                     _loc4_[_loc5_] = _loc7_;
                  }
                  break;
               case 1:
                  var _temp_5:* = nullRegExp;
                  _loc9_ = li32(_loc8_ = param2.referent);
                  _loc8_ += 4;
                  param1.position = _loc8_;
                  _loc10_ = param1.readUTFBytes(_loc9_);
                  param2.referent = param1.position;
                  _loc5_ = _temp_5.split(_loc10_).join("\x00");
                  _loc6_ = param3.getProperty(_loc5_);
                  _loc7_ = decodeProperty(param1,param2,_loc6_);
                  while(true)
                  {
                     _loc10_ = _loc6_.getAccess();
                     if(_loc10_ != "writeonly")
                     {
                        if(_loc10_ != "readwrite")
                        {
                           _loc11_ = false;
                           break;
                        }
                     }
                     _loc11_ = true;
                     break;
                  }
                  if(_loc11_)
                  {
                     _loc4_[_loc5_] = _loc7_;
                  }
                  break;
               case 11:
                  return _loc4_;
               default:
                  break loop0;
            }
         }
         Boot.lastError = new Error();
         throw new Error("fallthrough");
      }
      
      public function decodeArray(param1:ByteArray, param2:IntReference, param3:Record) : *
      {
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null as String;
         var _loc10_:Number = NaN;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         loop0:
         while(true)
         {
            param2.referent = (_loc7_ = param2.referent) + 1;
            switch(li8(_loc7_))
            {
               case 0:
                  var _temp_4:* = _loc4_;
                  var _temp_3:* = _loc5_++;
                  _loc8_ = li32(_loc7_ = param2.referent);
                  _loc7_ += 4;
                  param1.position = _loc7_;
                  _loc9_ = param1.readUTFBytes(_loc8_);
                  param2.referent = param1.position;
                  _temp_4[_temp_3] = _loc9_;
                  break;
               case 1:
                  var _temp_8:* = _loc4_;
                  var _temp_7:* = _loc5_++;
                  var _temp_6:* = nullRegExp;
                  _loc8_ = li32(_loc7_ = param2.referent);
                  _loc7_ += 4;
                  param1.position = _loc7_;
                  _loc9_ = param1.readUTFBytes(_loc8_);
                  param2.referent = param1.position;
                  _temp_8[_temp_7] = _temp_6.split(_loc9_).join("\x00");
                  break;
               case 2:
                  var _temp_10:* = _loc4_;
                  var _temp_9:* = _loc5_++;
                  _loc7_ = li8(param2.referent);
                  param2.referent += 1;
                  _temp_10[_temp_9] = _loc7_;
                  break;
               case 3:
                  var _temp_12:* = _loc4_;
                  var _temp_11:* = _loc5_++;
                  _loc7_ = li16(param2.referent);
                  param2.referent += 2;
                  _temp_12[_temp_11] = _loc7_;
                  break;
               case 4:
                  var _temp_14:* = _loc4_;
                  var _temp_13:* = _loc5_++;
                  _loc7_ = li32(param2.referent);
                  param2.referent += 4;
                  _temp_14[_temp_13] = _loc7_;
                  break;
               case 5:
                  var _temp_16:* = _loc4_;
                  var _temp_15:* = _loc5_++;
                  _loc10_ = lf64(param2.referent);
                  param2.referent += 8;
                  _temp_16[_temp_15] = _loc10_;
                  break;
               case 6:
                  _loc4_[_loc5_++] = decodeObject(param1,param2,param3);
                  break;
               case 7:
                  _loc4_[_loc5_++] = decodeArray(param1,param2,typeCache.describeType(Object));
                  break;
               case 8:
                  _loc4_[_loc5_++] = true;
                  break;
               case 9:
                  _loc4_[_loc5_++] = false;
                  break;
               case 10:
                  _loc4_[_loc5_++] = null;
                  break;
               case 11:
                  if(int(_loc4_.length) == 2 && (Std.§is§(_loc4_[0],String) && (_loc4_[0] == "time" && (Std.§is§(_loc4_[1],int) || Std.§is§(_loc4_[1],Number)))))
                  {
                     return new Date(_loc4_[1]);
                  }
                  return _loc4_;
                  break;
               default:
                  break loop0;
            }
         }
         Boot.lastError = new Error();
         throw new Error("fallthrough");
      }
      
      public function decode(param1:ByteArray, param2:int, param3:Class) : *
      {
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc5_:int = int(param1.position);
         try
         {
            _loc6_ = decodeValue(param1,new IntReference(param2),param3);
         }
         catch(_loc_e_:*)
         {
            param1.position = _loc5_;
            Boot.lastError = new Error();
            throw _loc7_;
         }
         param1.position = _loc5_;
         return _loc6_;
      }
   }
}

