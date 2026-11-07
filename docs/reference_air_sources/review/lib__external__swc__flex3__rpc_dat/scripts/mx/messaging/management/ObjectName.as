package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.ObjectName")]
   public class ObjectName
   {
      
      public var keyPropertyListString:String;
      
      public var domain:String;
      
      public var domainPattern:Boolean;
      
      public var canonicalKeyPropertyListString:String;
      
      public var pattern:Boolean;
      
      public var keyPropertyList:Object;
      
      public var propertyPattern:Boolean;
      
      public var canonicalName:String;
      
      public function ObjectName()
      {
         super();
      }
      
      public function getKeyProperty(property:String) : Object
      {
         if(keyPropertyList != null && keyPropertyList.hasOwnProperty(property))
         {
            return keyPropertyList[property];
         }
         return null;
      }
      
      public function toString() : String
      {
         if(Boolean(canonicalName))
         {
            return canonicalName;
         }
         return ObjectUtil.toString(this);
      }
   }
}

