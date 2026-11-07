package mx.messaging.management
{
   import mx.utils.ObjectUtil;
   
   [RemoteClass(alias="flex.management.jmx.MBeanFeatureInfo")]
   public class MBeanFeatureInfo
   {
      
      public var name:String;
      
      public var description:String;
      
      public function MBeanFeatureInfo()
      {
         super();
      }
      
      public function toString() : String
      {
         return ObjectUtil.toString(this);
      }
   }
}

