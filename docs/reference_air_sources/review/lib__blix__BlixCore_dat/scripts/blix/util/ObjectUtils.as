package blix.util
{
   import blix.util.type.describeType;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ObjectUtils
   {
      
      public static const PRIMITIVE_TYPES:Array = ["String","Number","uint","int","Boolean","Date","Array"];
      
      public static const IGNORE_TYPES:Array = ["*","Function"];
      
      public function ObjectUtils()
      {
         super();
      }
      
      public static function mergeObjects(param1:*, param2:*, param3:Boolean = false, param4:Boolean = true, param5:Boolean = false) : void
      {
         if(getQualifiedClassName(param1) != getQualifiedClassName(param2))
         {
            throw new ArgumentError("objectA and objectB are not the same type.");
         }
         internalMergeObjects(param1,param2,param3,param4,param5,new Dictionary(true));
      }
      
      private static function internalMergeObjects(param1:*, param2:*, param3:Boolean, param4:Boolean, param5:Boolean, param6:Dictionary) : void
      {
         var properties:XMLList;
         var typeXml:XML = null;
         var property:XML = null;
         var propertyValueA:* = undefined;
         var propertyValueB:* = undefined;
         var propertyType:String = null;
         var objectA:* = param1;
         var objectB:* = param2;
         var transferNulls:Boolean = param3;
         var recursive:Boolean = param4;
         var ignoreTransient:Boolean = param5;
         var ref:Dictionary = param6;
         if(getQualifiedClassName(objectA) != getQualifiedClassName(objectB))
         {
            return;
         }
         ref[objectA] = true;
         typeXml = describeType(objectA);
         properties = typeXml.factory.children().(name() == "accessor" && @access == "readwrite" || name() == "variable");
         for each(property in properties)
         {
            if(!(ignoreTransient && property.metadata.(@name == "Transient").length() > 0))
            {
               propertyValueA = objectA[property.@name];
               propertyValueB = objectB[property.@name];
               if(transferNulls || propertyValueB != null)
               {
                  propertyType = property.@type;
                  if(IGNORE_TYPES.indexOf(propertyType) == -1)
                  {
                     if(PRIMITIVE_TYPES.indexOf(propertyType) == -1 && recursive)
                     {
                        if(propertyValueA != null && propertyValueB != null)
                        {
                           if(!ref[propertyValueA])
                           {
                              internalMergeObjects(propertyValueA,propertyValueB,transferNulls,recursive,ignoreTransient,ref);
                           }
                        }
                        else
                        {
                           objectA[property.@name] = propertyValueB;
                        }
                     }
                     else
                     {
                        objectA[property.@name] = propertyValueB;
                     }
                  }
               }
            }
         }
      }
      
      public static function compare(param1:Object, param2:Object) : Boolean
      {
         if(param1 == param2)
         {
            return true;
         }
         if(param1 == null || param2 == null)
         {
            return false;
         }
         if(param1.constructor != param2.constructor)
         {
            return false;
         }
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(param1);
         var _loc4_:uint = _loc3_.length;
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.writeObject(param2);
         var _loc6_:uint = _loc5_.length;
         if(_loc4_ != _loc6_)
         {
            return false;
         }
         _loc3_.position = 0;
         _loc5_.position = 0;
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            if(_loc3_.readByte() != _loc5_.readByte())
            {
               return false;
            }
            _loc7_++;
         }
         return true;
      }
      
      public static function compareObjectValues(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:Boolean = false;
         if(!!param1 != !!param2)
         {
            return false;
         }
         _loc3_ = recursiveCompare(param1,[],param2);
         if(!_loc3_)
         {
            return false;
         }
         _loc3_ = recursiveCompare(param2,[],param1);
         if(!_loc3_)
         {
            return false;
         }
         return true;
      }
      
      private static function recursiveCompare(param1:Object, param2:Array, param3:Object, param4:Dictionary = null) : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc8_:Boolean = false;
         var _loc9_:String = null;
         if(!param4)
         {
            param4 = new Dictionary(true);
         }
         if(Boolean(param4[param1]))
         {
            return true;
         }
         param4[param1] = true;
         for(_loc5_ in param1)
         {
            if(!_loc5_ || param1[_loc5_] == null)
            {
               continue;
            }
            switch(typeof param1[_loc5_])
            {
               case "object":
                  _loc6_ = recursiveCompare(param1[_loc5_],param2.concat(_loc5_),param3,param4);
                  if(!_loc6_)
                  {
                     return false;
                  }
                  break;
               case "boolean":
               case "string":
               case "number":
                  _loc7_ = param3;
                  for each(_loc9_ in param2)
                  {
                     _loc7_ = _loc7_[_loc9_];
                     if(!_loc7_)
                     {
                        return false;
                     }
                  }
                  _loc8_ = param1[_loc5_] == _loc7_[_loc5_];
                  if(!_loc8_)
                  {
                     return false;
                  }
            }
         }
         return true;
      }
   }
}

