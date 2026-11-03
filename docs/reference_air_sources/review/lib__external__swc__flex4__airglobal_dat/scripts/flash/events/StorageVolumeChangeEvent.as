package flash.events
{
   import flash.filesystem.File;
   import flash.filesystem.StorageVolume;
   
   [Version("air2.0")]
   public class StorageVolumeChangeEvent extends Event
   {
      
      public static const STORAGE_VOLUME_MOUNT:String = "storageVolumeMount";
      
      public static const STORAGE_VOLUME_UNMOUNT:String = "storageVolumeUnmount";
      
      internal var _rootDirectory:File = null;
      
      internal var _volume:StorageVolume = null;
      
      public function StorageVolumeChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, path:File = null, volume:StorageVolume = null)
      {
         super(type,bubbles,cancelable);
         this._rootDirectory = path;
         this._volume = volume;
      }
      
      override public function clone() : Event
      {
         return new StorageVolumeChangeEvent(type,bubbles,cancelable,this._rootDirectory,this._volume);
      }
      
      override public function toString() : String
      {
         return formatToString("StorageVolumeChangeEvent","type","bubbles","cancelable","rootDirectory","storageVolume");
      }
      
      public function get rootDirectory() : File
      {
         return this._rootDirectory;
      }
      
      public function get storageVolume() : StorageVolume
      {
         return this._volume;
      }
   }
}

