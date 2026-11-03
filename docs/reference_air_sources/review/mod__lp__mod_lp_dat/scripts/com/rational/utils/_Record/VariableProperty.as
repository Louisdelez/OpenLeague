package com.rational.utils._Record
{
   import com.rational.utils.IProperty;
   import flash.Boot;
   
   public class VariableProperty implements IProperty
   {
      
      public var variable:XML;
      
      public var type:Class;
      
      public var name:String;
      
      public var elementType:Class;
      
      public function VariableProperty(param1:String = undefined, param2:XML = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         name = param1;
         variable = param2;
         type = null;
         elementType = null;
      }
      
      public function getType() : Class
      {
         if(type != null)
         {
            return type;
         }
         type = Type.resolveClass(variable.attribute("type").toString());
         return type;
      }
      
      public function getName() : String
      {
         return name;
      }
      
      public function getElementType() : Class
      {
         var _loc2_:* = null as XML;
         var _loc3_:* = null as XMLList;
         var _loc4_:* = null as XML;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(elementType != null)
         {
            return elementType;
         }
         var _loc1_:XMLList = variable.elements("metadata");
         var _loc5_:int = 0;
         var _loc6_:int = _loc1_.length();
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc2_ = _loc1_[_loc7_];
            if(_loc2_.attribute("name").toString() == "ArrayElementType")
            {
               _loc3_ = _loc2_.elements("arg");
               _loc8_ = 0;
               _loc9_ = _loc3_.length();
               while(_loc8_ < _loc9_)
               {
                  _loc10_ = _loc8_++;
                  _loc4_ = _loc3_[_loc10_];
                  if(_loc4_.attribute("key").toString() == "")
                  {
                     elementType = Type.resolveClass(_loc4_.attribute("value").toString());
                     return elementType;
                  }
               }
               Boot.lastError = new Error();
               throw new Error("ArrayElementType metadata missing single unnamed argument");
            }
         }
         elementType = Object;
         return elementType;
      }
      
      public function getAccess() : String
      {
         return "readwrite";
      }
   }
}

