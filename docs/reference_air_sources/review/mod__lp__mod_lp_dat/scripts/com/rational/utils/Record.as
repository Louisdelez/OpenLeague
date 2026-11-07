package com.rational.utils
{
   import com.rational.utils._Record.AccessorProperty;
   import com.rational.utils._Record.DynamicProperty;
   import com.rational.utils._Record.VariableProperty;
   import flash.Boot;
   
   public class Record
   {
      
      public static var OBJECT_TYPE:Class = Object;
      
      public var variables:XMLList;
      
      public var typeDescription:XML;
      
      public var type:Class;
      
      public var properties:Hash;
      
      public var accessors:XMLList;
      
      public function Record(param1:Class = undefined, param2:XML = undefined)
      {
         if(Boot.skip_constructor)
         {
            return;
         }
         type = param1;
         typeDescription = param2;
         var _loc3_:XML = param2.elements("factory")[0];
         variables = _loc3_.elements("variable");
         accessors = _loc3_.elements("accessor");
         properties = new Hash();
      }
      
      public static function newInstance(param1:Class, param2:XML) : Record
      {
         return new Record(param1,param2);
      }
      
      public function getProperty(param1:String) : IProperty
      {
         var _loc4_:* = null as XML;
         var _loc7_:int = 0;
         var _loc9_:* = null as XML;
         var _loc2_:IProperty = properties.get(param1);
         if(_loc2_ != null)
         {
            return _loc2_;
         }
         var _loc3_:XMLList = variables;
         var _loc5_:int = 0;
         var _loc6_:int = _loc3_.length();
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc4_ = _loc3_[_loc7_];
            if(_loc4_.attribute("name").toString() == param1)
            {
               _loc2_ = new VariableProperty(param1,_loc4_);
               properties.set(param1,_loc2_);
               return _loc2_;
            }
         }
         var _loc8_:XMLList = accessors;
         _loc5_ = 0;
         _loc6_ = _loc8_.length();
         while(_loc5_ < _loc6_)
         {
            _loc7_ = _loc5_++;
            _loc9_ = _loc8_[_loc7_];
            if(_loc9_.attribute("name").toString() == param1)
            {
               _loc2_ = new AccessorProperty(param1,_loc9_);
               properties.set(param1,_loc2_);
               return _loc2_;
            }
         }
         if(typeDescription.attribute("type").toString() == "Object" || typeDescription.attribute("isDynamic").toString() == "true")
         {
            _loc2_ = new DynamicProperty(param1);
            properties.set(param1,_loc2_);
            return _loc2_;
         }
         Boot.lastError = new Error();
         throw new Error("No such field");
      }
      
      public function createInstance() : Object
      {
         return Type.createInstance(type,[]);
      }
   }
}

