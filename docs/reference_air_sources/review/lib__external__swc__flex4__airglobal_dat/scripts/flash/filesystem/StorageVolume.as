package flash.filesystem
{
   [Version("air2.0")]
   public class StorageVolume
   {
      
      private var _rootDir:File = null;
      
      private var _name:String = null;
      
      private var _isWritable:Boolean = false;
      
      private var _isRemovable:Boolean = false;
      
      private var _fileSystemType:String = null;
      
      private var _drive:String = null;
      
      public function StorageVolume(rootDirPath:File, name:String, writable:Boolean, removable:Boolean, fileSysType:String, drive:String)
      {
         super();
         this._rootDir = rootDirPath;
         this._name = name;
         this._isWritable = writable;
         this._isRemovable = removable;
         this._fileSystemType = fileSysType;
         this._drive = drive;
      }
      
      public function get rootDirectory() : File
      {
         return this._rootDir;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get drive() : String
      {
         return this._drive;
      }
      
      public function get isWritable() : Boolean
      {
         return this._isWritable;
      }
      
      public function get isRemovable() : Boolean
      {
         return this._isRemovable;
      }
      
      public function get fileSystemType() : String
      {
         return this._fileSystemType;
      }
   }
}

