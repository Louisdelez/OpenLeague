package mx.messaging.management
{
   [RemoteClass(alias="flex.management.jmx.MBeanAttributeInfo")]
   public class MBeanAttributeInfo extends MBeanFeatureInfo
   {
      
      public var type:String;
      
      public var readable:Boolean;
      
      public var writable:Boolean;
      
      public var isIs:Boolean;
      
      public function MBeanAttributeInfo()
      {
         super();
      }
   }
}

