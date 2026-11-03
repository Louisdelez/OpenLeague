package flash.data
{
   import flash.errors.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="EncryptedLocalStoreClass",instance="EncryptedLocalStoreObject",methods="auto",construct="native")]
   public class EncryptedLocalStore
   {
      
      private static const ENCRYPTEDLOCALSTORE_DATABASE_ACCESS_ERROR:* = 1;
      
      private static const ENCRYPTEDLOCALSTORE_INTERNAL_ERROR:* = 2;
      
      private static const ENCRYPTEDLOCALSTORE_OUTOFMEMORY_ERROR:* = 3;
      
      private static const ENCRYPTEDLOCALSTORE_PUBLISHERIDERROR_SIGINVALID:* = 4;
      
      private static const ENCRYPTEDLOCALSTORE_PUBLISHERIDERROR_PASSEDIN_PUBID:* = 5;
      
      private static const ENCRYPTEDLOCALSTORE_APPHASH_COMPUTATION_ERROR:* = 6;
      
      private static const ENCRYPTEDLOCALSTORE_APPHASH_CHECK_ERROR:* = 7;
      
      private static const ENCRYPTEDLOCALSTORE_NOT_SUPPORTED_ERROR:* = 8;
      
      private static const ENCRYPTEDLOCALSTORE_VERSION_MISMATCH:* = 9;
      
      public function EncryptedLocalStore()
      {
         super();
      }
      
      public static function setItem(name:String, data:ByteArray, stronglyBound:Boolean = false) : void
      {
         checkName(name);
         if(data == null)
         {
            Error.throwError(ArgumentError,2007,"data");
         }
         var errorCode:uint = uint(setItemNative(name,data,stronglyBound));
         processErrorCode(errorCode);
      }
      
      public static function getItem(name:String) : ByteArray
      {
         checkName(name);
         var data:ByteArray = new ByteArray();
         var errorCode:uint = uint(getItemNative(name,data));
         processErrorCode(errorCode);
         if(data.length > 0)
         {
            return data;
         }
         return null;
      }
      
      public static function removeItem(name:String) : void
      {
         checkName(name);
         var errorCode:uint = uint(removeItemNative(name));
         processErrorCode(errorCode);
      }
      
      public static function reset() : void
      {
         var errorCode:uint = uint(resetNative());
         processErrorCode(errorCode);
      }
      
      [Version("air2.0")]
      public static native function get isSupported() : Boolean;
      
      private static native function setItemNative(param1:String, param2:ByteArray, param3:Boolean) : uint;
      
      private static native function getItemNative(param1:String, param2:ByteArray) : uint;
      
      private static native function removeItemNative(param1:String) : uint;
      
      private static native function resetNative() : uint;
      
      private static function processErrorCode(errorCode:uint) : void
      {
         if(errorCode == ENCRYPTEDLOCALSTORE_OUTOFMEMORY_ERROR)
         {
            throw new MemoryError("EncryptedLocalStore is out of memory");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_PUBLISHERIDERROR_SIGINVALID)
         {
            throw new IllegalOperationError();
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_PUBLISHERIDERROR_PASSEDIN_PUBID)
         {
            throw new Error("EncryptedLocalStore may not use publisher IDs passed in from ADL");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_DATABASE_ACCESS_ERROR)
         {
            throw new IOError("EncryptedLocalStore database access error");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_INTERNAL_ERROR)
         {
            throw new IOError("EncryptedLocalStore internal error");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_NOT_SUPPORTED_ERROR)
         {
            throw new IOError("EncryptedLocalStore is not supported on the current platform");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_VERSION_MISMATCH)
         {
            throw new IOError("EncryptedLocalStore version mismatch");
         }
         if(errorCode != 0)
         {
            throw new Error("general internal error");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_APPHASH_COMPUTATION_ERROR)
         {
            throw new IllegalOperationError("An error was encountered while computing the application\'s digest.");
         }
         if(errorCode == ENCRYPTEDLOCALSTORE_APPHASH_CHECK_ERROR)
         {
            throw new IllegalOperationError("The EncryptedLocalStore item belongs to an app with a different digest.");
         }
      }
      
      private static function checkName(name:String) : void
      {
         if(name == null)
         {
            Error.throwError(ArgumentError,2007,"name");
         }
         else if(name == "")
         {
            Error.throwError(ArgumentError,2085,"name");
         }
      }
   }
}

