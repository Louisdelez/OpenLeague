package flash.filesystem
{
   import flash.events.EventDispatcher;
   import flash.system.Security;
   
   [Version("air2.0")]
   [native(cls="StorageVolumeInfoClass",instance="StorageVolumeInfoObject",methods="auto",construct="native")]
   [Event(name="storageVolumeUnmount",type="flash.events.StorageVolumeChangeEvent")]
   [Event(name="storageVolumeMount",type="flash.events.StorageVolumeChangeEvent")]
   public final class StorageVolumeInfo extends EventDispatcher
   {
      
      public function StorageVolumeInfo()
      {
         super();
      }
      
      public static function get storageVolumeInfo() : StorageVolumeInfo
      {
         var sandboxType:String = Security.sandboxType;
         if(sandboxType != "application" && sandboxType != "runtime")
         {
            throw new Error("Only Application content can access the StorageVolumeInfo object.");
         }
         return _getInstance();
      }
      
      private static native function _getInstance() : StorageVolumeInfo;
      
      [Version("air2.0")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public native function getStorageVolumes() : Vector.<StorageVolume>;
   }
}

