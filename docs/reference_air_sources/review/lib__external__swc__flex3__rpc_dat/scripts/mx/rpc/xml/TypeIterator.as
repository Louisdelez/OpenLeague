package mx.rpc.xml
{
   import mx.collections.IList;
   
   [ExcludeClass]
   public class TypeIterator
   {
      
      private var _value:*;
      
      private var counter:uint;
      
      public function TypeIterator(value:*)
      {
         super();
         _value = value;
      }
      
      public static function push(parent:*, value:*) : uint
      {
         var result:uint = 0;
         var complexParent:* = undefined;
         var arrayValue:Array = null;
         var listValue:IList = null;
         var xmlList:XMLList = null;
         if(parent != null)
         {
            if(parent is ContentProxy && !ContentProxy(parent).isSimple)
            {
               complexParent = ContentProxy(parent).content;
               if(TypeIterator.isIterable(complexParent))
               {
                  parent = complexParent;
               }
            }
            if(parent is Array)
            {
               arrayValue = parent as Array;
               result = arrayValue.push(value);
            }
            else if(parent is IList)
            {
               listValue = parent as IList;
               listValue.addItem(value);
               result = uint(listValue.length);
            }
            else if(parent is XMLList)
            {
               xmlList = parent as XMLList;
               xmlList += value;
               result = uint(xmlList.length());
            }
         }
         return result;
      }
      
      public static function getLength(value:*) : uint
      {
         var result:uint = 0;
         var arrayValue:Array = null;
         var listValue:IList = null;
         var xmlList:XMLList = null;
         if(value != null)
         {
            if(value is Array)
            {
               arrayValue = value as Array;
               result = arrayValue.length;
            }
            else if(value is IList)
            {
               listValue = value as IList;
               result = uint(listValue.length);
            }
            else if(value is XMLList)
            {
               xmlList = value as XMLList;
               result = uint(xmlList.length());
            }
         }
         return result;
      }
      
      public static function getItemAt(value:*, index:uint) : *
      {
         var result:* = undefined;
         var arrayValue:Array = null;
         var listValue:IList = null;
         var xmlList:XMLList = null;
         if(value != null)
         {
            if(value is Array)
            {
               arrayValue = value as Array;
               result = arrayValue[index];
            }
            else if(value is IList)
            {
               listValue = value as IList;
               result = listValue.getItemAt(index);
            }
            else if(value is XMLList)
            {
               xmlList = value as XMLList;
               result = xmlList[index];
            }
         }
         return result;
      }
      
      public static function isIterable(value:*) : Boolean
      {
         var complexValue:* = undefined;
         if(value is ContentProxy && !ContentProxy(value).isSimple)
         {
            complexValue = ContentProxy(value).content;
            if(TypeIterator.isIterable(complexValue))
            {
               value = complexValue;
            }
         }
         if(value is Array || value is IList || value is XMLList)
         {
            return true;
         }
         return false;
      }
      
      public function get value() : *
      {
         return _value;
      }
      
      public function next() : *
      {
         var result:* = undefined;
         try
         {
            result = getItemAt(_value,counter);
         }
         finally
         {
            ++counter;
         }
         return result;
      }
      
      public function get length() : uint
      {
         return getLength(_value);
      }
      
      public function hasNext() : Boolean
      {
         if(_value != null)
         {
            return getLength(_value) > counter;
         }
         return false;
      }
      
      public function reset() : void
      {
         counter = 0;
      }
   }
}

