package flash.desktop
{
   import flash.filesystem.File;
   
   [Version("air2.0")]
   public class NativeProcessStartupInfo
   {
      
      private var _executable:File = null;
      
      private var _workingDirectory:File = null;
      
      private var _args:Vector.<String> = new Vector.<String>();
      
      public function NativeProcessStartupInfo()
      {
         super();
      }
      
      public function get executable() : File
      {
         return this._executable;
      }
      
      public function set executable(value:File) : void
      {
         if(value == null || !NativeProcess.isValidExecutable(value))
         {
            Error.throwError(ArgumentError,3214);
         }
         this._executable = value;
      }
      
      public function get workingDirectory() : File
      {
         return this._workingDirectory;
      }
      
      public function set workingDirectory(value:File) : void
      {
         if(value != null && (!value.exists || !value.isDirectory))
         {
            Error.throwError(ArgumentError,3215);
         }
         this._workingDirectory = value;
      }
      
      public function get arguments() : Vector.<String>
      {
         return this._args;
      }
      
      public function set arguments(value:Vector.<String>) : void
      {
         this._args = value;
      }
   }
}

