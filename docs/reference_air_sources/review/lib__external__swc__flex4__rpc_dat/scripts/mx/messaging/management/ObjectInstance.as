package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.ObjectInstance")]
   public class ObjectInstance
   {
      
      public var objectName:ObjectName;
      
      public var className:String;
      
      public function ObjectInstance()
      {
         super();
      }
      
      public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}

