package flash.external
{
   import flash.errors.*;
   import flash.events.*;
   import flash.filesystem.*;
   
   [API("669")]
   [native(cls="ExtensionContextClass",instance="ExtensionContextObject",methods="auto")]
   public final class ExtensionContext extends EventDispatcher
   {
      
      public function ExtensionContext()
      {
         super();
      }
      
      public static function createExtensionContext(extensionID:String, contextType:String) : ExtensionContext
      {
         if(extensionID == null)
         {
            Error.throwError(ArgumentError,2004,"extensionID");
         }
         return _createExtensionContext(extensionID,contextType);
      }
      
      private static native function _createExtensionContext(param1:String, param2:String) : ExtensionContext;
      
      public static function getExtensionDirectory(extensionID:String) : File
      {
         return new File(_getExtensionDirectory(extensionID));
      }
      
      private static native function _getExtensionDirectory(param1:String) : String;
      
      public function call(functionName:String, ... args) : Object
      {
         return this._call(functionName,args);
      }
      
      private native function _call(param1:String, param2:Array) : Object;
      
      public function get actionScriptData() : Object
      {
         if(this._disposed())
         {
            Error.throwError(IllegalOperationError,3501);
         }
         return this.getActionScriptData();
      }
      
      public function set actionScriptData(object:Object) : void
      {
         if(this._disposed())
         {
            Error.throwError(IllegalOperationError,3501);
         }
         this.setActionScriptData(object);
      }
      
      public native function dispose() : void;
      
      internal native function _disposed() : Boolean;
      
      internal native function getActionScriptData() : Object;
      
      internal native function setActionScriptData(param1:Object) : void;
   }
}

