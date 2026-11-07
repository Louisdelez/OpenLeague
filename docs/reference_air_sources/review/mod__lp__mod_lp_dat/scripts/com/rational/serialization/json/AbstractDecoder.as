package com.rational.serialization.json
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li16;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import com.rational.utils.IntReference;
   import flash.Boot;
   import flash.utils.ByteArray;
   
   public class AbstractDecoder
   {
      
      public var nullRegExp:EReg;
      
      public function AbstractDecoder()
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(192);
         _loc1_.writeByte(128);
         _loc1_.position = 0;
         nullRegExp = new EReg(_loc1_.readUTFBytes(2),"g");
      }
      
      public function decodeUI16(param1:ByteArray, param2:IntReference) : int
      {
         var _loc3_:int = li16(param2.referent);
         param2.referent += 2;
         return _loc3_;
      }
      
      public function decodeString(param1:ByteArray, param2:IntReference) : String
      {
         var _loc3_:* = param2.referent;
         var _loc4_:int = li32(_loc3_);
         _loc3_ += 4;
         param1.position = _loc3_;
         var _loc5_:String = param1.readUTFBytes(_loc4_);
         param2.referent = param1.position;
         return _loc5_;
      }
      
      public function decodeModifiedString(param1:ByteArray, param2:IntReference) : String
      {
         var _temp_1:* = nullRegExp;
         var _loc3_:* = param2.referent;
         var _loc4_:int = li32(_loc3_);
         _loc3_ += 4;
         param1.position = _loc3_;
         var _loc5_:String = param1.readUTFBytes(_loc4_);
         param2.referent = param1.position;
         return _temp_1.split(_loc5_).join("\x00");
      }
      
      public function decodeI32(param1:ByteArray, param2:IntReference) : int
      {
         var _loc3_:int = li32(param2.referent);
         param2.referent += 4;
         return _loc3_;
      }
      
      public function decodeDouble(param1:ByteArray, param2:IntReference) : Number
      {
         var _loc3_:Number = lf64(param2.referent);
         param2.referent += 8;
         return _loc3_;
      }
      
      public function decodeByte(param1:ByteArray, param2:IntReference) : int
      {
         var _loc3_:int = li8(param2.referent);
         param2.referent += 1;
         return _loc3_;
      }
   }
}

