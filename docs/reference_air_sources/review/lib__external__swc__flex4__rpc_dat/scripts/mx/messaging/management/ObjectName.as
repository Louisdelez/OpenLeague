package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.ObjectName")]
   public class ObjectName
   {
      
      public var canonicalName:String;
      
      public var canonicalKeyPropertyListString:String;
      
      public var pattern:Boolean;
      
      public var domainPattern:Boolean;
      
      public var propertyPattern:Boolean;
      
      public var domain:String;
      
      public var keyPropertyList:Object;
      
      public var keyPropertyListString:String;
      
      public function ObjectName()
      {
         super();
      }
      
      public function getKeyProperty(property:String) : Object
      {
         if(this.keyPropertyList != null && this.keyPropertyList.hasOwnProperty(property))
         {
            return this.keyPropertyList[property];
         }
         return null;
      }
      
      public function toString() : String
      {
         if(Boolean(this.canonicalName))
         {
            return this.canonicalName;
         }
         return ObjectUtil.toString(this);
      }
   }
}

