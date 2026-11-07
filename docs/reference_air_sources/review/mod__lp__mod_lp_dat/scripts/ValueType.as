package
{
   import flash.Boot;
   
   public final class ValueType
   {
      
      public static const __isenum:Boolean = true;
      
      public static var __constructs__:*;
      
      public static var TUnknown:ValueType;
      
      public static var TObject:ValueType;
      
      public static var TNull:ValueType;
      
      public static var TInt:ValueType;
      
      public static var TFunction:ValueType;
      
      public static var TFloat:ValueType;
      
      public static var TBool:ValueType;
      
      public var tag:String;
      
      public var index:int;
      
      public var params:Array;
      
      public const __enum__:Boolean = true;
      
      public function ValueType(param1:String, param2:int, param3:*)
      {
         tag = param1;
         index = param2;
         params = param3;
      }
      
      public static function TEnum(param1:Class) : ValueType
      {
         return new ValueType("TEnum",7,[param1]);
      }
      
      public static function TClass(param1:Class) : ValueType
      {
         return new ValueType("TClass",6,[param1]);
      }
      
      final public function toString() : String
      {
         return Boot.enum_to_string(this);
      }
   }
}

_loc1_.§§slot[1] = new ValueType("TBool",3,null);
_loc1_.§§slot[4] = new ValueType("TFloat",2,null);
_loc1_.§§slot[5] = new ValueType("TFunction",5,null);
_loc1_.§§slot[6] = new ValueType("TInt",1,null);
_loc1_.§§slot[7] = new ValueType("TNull",0,null);
_loc1_.§§slot[8] = new ValueType("TObject",4,null);
_loc1_.§§slot[9] = new ValueType("TUnknown",8,null);
_loc1_.__constructs__ = ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"];

