package
{
   import flash.Boot;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class Type
   {
      
      public function Type()
      {
      }
      
      public static function getClass(param1:Object) : Class
      {
         var _loc2_:String = getQualifiedClassName(param1);
         if(_loc2_ == "null" || (_loc2_ == "Object" || (_loc2_ == "int" || (_loc2_ == "Number" || _loc2_ == "Boolean"))))
         {
            return null;
         }
         if(param1.hasOwnProperty("prototype"))
         {
            return null;
         }
         var _loc3_:* = getDefinitionByName(_loc2_) as Class;
         if(_loc3_.__isenum)
         {
            return null;
         }
         return _loc3_;
      }
      
      public static function getEnum(param1:*) : Class
      {
         var _loc2_:String = getQualifiedClassName(param1);
         if(_loc2_ == "null" || _loc2_.substr(0,8) == "builtin.")
         {
            return null;
         }
         if(param1.hasOwnProperty("prototype"))
         {
            return null;
         }
         var _loc3_:* = getDefinitionByName(_loc2_) as Class;
         if(!_loc3_.__isenum)
         {
            return null;
         }
         return _loc3_;
      }
      
      public static function getSuperClass(param1:Class) : Class
      {
         var _loc2_:String = getQualifiedSuperclassName(param1);
         if(_loc2_ == "Object")
         {
            return null;
         }
         return getDefinitionByName(_loc2_) as Class;
      }
      
      public static function getClassName(param1:Class) : String
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:String = _loc2_;
         if(_loc3_ == "int")
         {
            return "Int";
         }
         if(_loc3_ == "Number")
         {
            return "Float";
         }
         if(_loc3_ == "Boolean")
         {
            return "Bool";
         }
         return _loc2_.split("::").join(".");
      }
      
      public static function getEnumName(param1:Class) : String
      {
         return Type.getClassName(param1);
      }
      
      public static function resolveClass(param1:String) : Class
      {
         var _loc3_:* = null as Class;
         var _loc4_:* = null;
         var _loc5_:* = null as String;
         try
         {
            _loc3_ = getDefinitionByName(param1) as Class;
            if(_loc3_.__isenum)
            {
               return null;
            }
            return _loc3_;
         }
         catch(_loc_e_:*)
         {
            if(_loc5_ == "Float")
            {
               return Number;
            }
            return null;
         }
      }
      
      public static function resolveEnum(param1:String) : Class
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         try
         {
            _loc3_ = getDefinitionByName(param1);
            if(!_loc3_.__isenum)
            {
               return null;
            }
            return _loc3_;
         }
         catch(_loc_e_:*)
         {
            return null;
         }
      }
      
      public static function createInstance(param1:Class, param2:Array) : Object
      {
         switch(int(param2.length))
         {
            case 0:
               return new param1();
            case 1:
               return new param1(param2[0]);
            case 2:
               return new param1(param2[0],param2[1]);
            case 3:
               return new param1(param2[0],param2[1],param2[2]);
            case 4:
               return new param1(param2[0],param2[1],param2[2],param2[3]);
            case 5:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4]);
            case 6:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5]);
            case 7:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6]);
            case 8:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7]);
            case 9:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8]);
            case 10:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9]);
            case 11:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10]);
            case 12:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11]);
            case 13:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11],param2[12]);
            case 14:
               return new param1(param2[0],param2[1],param2[2],param2[3],param2[4],param2[5],param2[6],param2[7],param2[8],param2[9],param2[10],param2[11],param2[12],param2[13]);
            default:
               Boot.lastError = new Error();
               throw "Too many arguments";
         }
      }
      
      public static function createEmptyInstance(param1:Class) : Object
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null;
         try
         {
            Boot.skip_constructor = true;
            _loc3_ = new param1();
            Boot.skip_constructor = false;
            return _loc3_;
         }
         catch(_loc_e_:*)
         {
            Boot.skip_constructor = false;
            Boot.lastError = new Error();
            throw _loc4_;
         }
      }
      
      public static function createEnum(param1:Class, param2:String, param3:Array = undefined) : Object
      {
         var _loc4_:Object = param1 == null ? null : param1[param2];
         if(_loc4_ == null)
         {
            Boot.lastError = new Error();
            throw "No such constructor " + param2;
         }
         if(Reflect.isFunction(_loc4_))
         {
            if(param3 == null)
            {
               Boot.lastError = new Error();
               throw "Constructor " + param2 + " need parameters";
            }
            return _loc4_.apply(param1,param3);
         }
         if(param3 != null && int(param3.length) != 0)
         {
            Boot.lastError = new Error();
            throw "Constructor " + param2 + " does not need parameters";
         }
         return _loc4_;
      }
      
      public static function createEnumIndex(param1:Class, param2:int, param3:Array = undefined) : Object
      {
         var _loc4_:String = Type.getEnumConstructs(param1)[param2];
         if(_loc4_ == null)
         {
            Boot.lastError = new Error();
            throw param2 + " is not a valid enum constructor index";
         }
         return Type.createEnum(param1,_loc4_,param3);
      }
      
      public static function describe(param1:*, param2:Boolean) : Array
      {
         var _loc8_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:XML = describeType(param1);
         if(param2)
         {
            _loc4_ = _loc4_.factory[0];
         }
         var _loc5_:XMLList = _loc4_.child("method");
         var _loc6_:int = 0;
         var _loc7_:int = _loc5_.length();
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc3_.push(Std.string(_loc5_[_loc8_].attribute("name")));
         }
         var _loc9_:XMLList = _loc4_.child("variable");
         _loc6_ = 0;
         _loc7_ = _loc9_.length();
         while(_loc6_ < _loc7_)
         {
            _loc8_ = _loc6_++;
            _loc3_.push(Std.string(_loc9_[_loc8_].attribute("name")));
         }
         return _loc3_;
      }
      
      public static function getInstanceFields(param1:Class) : Array
      {
         return Type.describe(param1,true);
      }
      
      public static function getClassFields(param1:Class) : Array
      {
         var _loc2_:Array = Type.describe(param1,false);
         _loc2_.remove("__construct__");
         return _loc2_;
      }
      
      public static function getEnumConstructs(param1:Class) : Array
      {
         return param1.__constructs__;
      }
      
      public static function §typeof§(param1:*) : ValueType
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc3_:String = getQualifiedClassName(param1);
         var _loc4_:String = _loc3_;
         if(_loc4_ == "null")
         {
            return ValueType.TNull;
         }
         if(_loc4_ == "void")
         {
            return ValueType.TNull;
         }
         if(_loc4_ == "int")
         {
            return ValueType.TInt;
         }
         if(_loc4_ == "Number")
         {
            return ValueType.TFloat;
         }
         if(_loc4_ == "Boolean")
         {
            return ValueType.TBool;
         }
         if(_loc4_ == "Object")
         {
            return ValueType.TObject;
         }
         _loc5_ = null;
         try
         {
            _loc5_ = getDefinitionByName(_loc3_);
            if(param1.hasOwnProperty("prototype"))
            {
               return ValueType.TObject;
            }
            if(_loc5_.__isenum)
            {
               return ValueType.TEnum(_loc5_);
            }
            return ValueType.TClass(_loc5_);
         }
         catch(_loc_e_:*)
         {
            if(_loc3_ == "builtin.as$0::MethodClosure" || _loc3_.indexOf("-") != -1)
            {
               return ValueType.TFunction;
            }
            return _loc5_ == null ? ValueType.TFunction : ValueType.TClass(_loc5_);
         }
      }
      
      public static function enumEq(param1:Object, param2:Object) : Boolean
      {
         var _loc4_:* = null as Array;
         var _loc5_:* = null as Array;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         if(param1 == param2)
         {
            return true;
         }
         try
         {
            if(param1.index != param2.index)
            {
               return false;
            }
            _loc4_ = param1.params;
            _loc5_ = param2.params;
            _loc6_ = 0;
            _loc7_ = int(_loc4_.length);
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc6_++;
               if(!Type.enumEq(_loc4_[_loc8_],_loc5_[_loc8_]))
               {
                  return false;
               }
            }
         }
         catch(_loc_e_:*)
         {
         }
      }
      
      public static function enumConstructor(param1:*) : String
      {
         return param1.tag;
      }
      
      public static function enumParameters(param1:*) : Array
      {
         return param1.params == null ? [] : param1.params;
      }
      
      public static function enumIndex(param1:*) : int
      {
         return param1.index;
      }
   }
}

