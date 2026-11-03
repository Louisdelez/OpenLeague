package blix.util.array
{
   public class ArrayUtils
   {
      
      public function ArrayUtils()
      {
         super();
      }
      
      public static function findInsertionIndex(param1:Object, param2:Object, param3:uint, param4:int = 0, param5:int = -1) : int
      {
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:int = 0;
         var _loc6_:Boolean = (param3 & Array.NUMERIC) > 0;
         var _loc7_:Boolean = (param3 & Array.CASEINSENSITIVE) > 0;
         var _loc8_:int = (param3 & Array.DESCENDING) > 0 ? 1 : 0;
         var _loc9_:* = _loc6_ ? Number(param2) : String(param2);
         if(!_loc6_ && _loc7_)
         {
            _loc9_ = _loc9_.toLowerCase();
         }
         if(param5 == -1)
         {
            param5 = int(param1.length);
         }
         while(param5 > param4)
         {
            _loc10_ = param4 + param5 >> 1;
            _loc11_ = param1[_loc10_];
            _loc12_ = _loc6_ ? Number(_loc11_) : String(_loc11_);
            if(!_loc6_ && _loc7_)
            {
               _loc12_ = _loc12_.toLowerCase();
            }
            _loc13_ = _loc9_ >= _loc12_ ? 1 : 0;
            if(Boolean(_loc13_ ^ _loc8_))
            {
               param4 = _loc10_ + 1;
            }
            else
            {
               param5 = _loc10_;
            }
         }
         return param4;
      }
      
      public static function findInsertionIndexWithCompare(param1:Object, param2:Object, param3:Function, param4:int = 0, param5:int = 0, param6:int = -1) : int
      {
         var _loc8_:int = 0;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc7_:int = (param4 & Array.DESCENDING) > 0 ? 1 : 0;
         if(param6 == -1)
         {
            param6 = int(param1.length);
         }
         while(param6 > param5)
         {
            _loc8_ = param5 + param6 >> 1;
            _loc9_ = param1[_loc8_];
            _loc10_ = param3(param2,_loc9_) >= 0 ? 1 : 0;
            if(Boolean(_loc10_ ^ _loc7_))
            {
               param5 = _loc8_ + 1;
            }
            else
            {
               param6 = _loc8_;
            }
         }
         return param5;
      }
      
      public static function findInsertionIndexWithField(param1:Object, param2:Object, param3:String, param4:uint = 0, param5:int = 0, param6:int = -1) : int
      {
         var _loc11_:int = 0;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:int = 0;
         var _loc7_:Boolean = (param4 & Array.NUMERIC) > 0;
         var _loc8_:Boolean = (param4 & Array.CASEINSENSITIVE) > 0;
         var _loc9_:int = (param4 & Array.DESCENDING) > 0 ? 1 : 0;
         var _loc10_:* = _loc7_ ? Number(param2[param3]) : String(param2[param3]);
         if(!_loc7_ && _loc8_)
         {
            _loc10_ = _loc10_.toLowerCase();
         }
         if(param6 == -1)
         {
            param6 = int(param1.length);
         }
         while(param6 > param5)
         {
            _loc11_ = param5 + param6 >> 1;
            _loc12_ = param1[_loc11_][param3];
            _loc13_ = _loc7_ ? Number(_loc12_) : String(_loc12_);
            if(!_loc7_ && _loc8_)
            {
               _loc13_ = _loc13_.toLowerCase();
            }
            _loc14_ = _loc10_ >= _loc13_ ? 1 : 0;
            if(Boolean(_loc14_ ^ _loc9_))
            {
               param5 = _loc11_ + 1;
            }
            else
            {
               param6 = _loc11_;
            }
         }
         return param5;
      }
      
      public static function findInsertionIndexWithFields(param1:Object, param2:Object, param3:Array, param4:Array = null, param5:int = 0, param6:int = -1) : int
      {
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Boolean = false;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         if(param4 == null)
         {
            param4 = [];
         }
         var _loc7_:uint = param3.length;
         var _loc8_:Array = [];
         _loc9_ = 0;
         while(_loc9_ < _loc7_)
         {
            _loc10_ = param3[_loc9_];
            _loc11_ = uint(param4[_loc9_]);
            _loc12_ = (_loc11_ & Array.NUMERIC) > 0;
            _loc13_ = (_loc11_ & Array.CASEINSENSITIVE) > 0;
            _loc14_ = _loc12_ ? Number(param2[_loc10_]) : String(param2[_loc10_]);
            if(!_loc12_ && _loc13_)
            {
               _loc14_ = _loc14_.toLowerCase();
            }
            _loc8_[_loc8_.length] = _loc14_;
            _loc9_++;
         }
         if(param6 == -1)
         {
            param6 = int(param1.length);
         }
         while(param6 > param5)
         {
            _loc15_ = param5 + param6 >> 1;
            _loc16_ = param1[_loc15_];
            _loc17_ = 1;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc10_ = param3[_loc9_];
               _loc14_ = _loc8_[_loc9_];
               _loc11_ = uint(param4[_loc9_]);
               _loc12_ = (_loc11_ & Array.NUMERIC) > 0;
               _loc13_ = (_loc11_ & Array.CASEINSENSITIVE) > 0;
               _loc18_ = (_loc11_ & Array.DESCENDING) > 0 ? 1 : 0;
               _loc19_ = _loc16_[_loc10_];
               _loc20_ = _loc12_ ? Number(_loc19_) : String(_loc19_);
               if(!_loc12_ && _loc13_)
               {
                  _loc20_ = _loc20_.toLowerCase();
               }
               if(_loc14_ != _loc20_)
               {
                  _loc17_ = _loc14_ >= _loc20_ ? 1 : 0;
                  break;
               }
               _loc9_++;
            }
            if(Boolean(_loc17_ ^ _loc18_))
            {
               param5 = _loc15_ + 1;
            }
            else
            {
               param6 = _loc15_;
            }
         }
         return param5;
      }
   }
}

