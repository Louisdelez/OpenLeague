package flash.desktop
{
   import flash.errors.*;
   import flash.filesystem.File;
   
   [native(cls="UpdaterClass",instance="UpdaterObject",methods="auto")]
   public final class Updater
   {
      
      public function Updater()
      {
         super();
      }
      
      [Version("air2.0")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public function update(airFile:File, version:String) : void
      {
         if(this._isADL)
         {
            throw new IllegalOperationError("This method is not supported if the application is launched from ADL.");
         }
         var result:Boolean = Boolean(this._launch("-update \"" + this._thisApplication + "\" \"" + airFile.nativePath + "\" \"" + version + "\""));
         if(!result)
         {
            throw new IllegalOperationError("This method is not supported if Adobe AIR is not installed.");
         }
         NativeApplication.nativeApplication.exit();
      }
      
      private native function _launch(param1:String) : Boolean;
      
      private native function get _isADL() : Boolean;
      
      private native function get _thisApplication() : String;
   }
}

