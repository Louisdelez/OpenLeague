package flash.security
{
   import flash.utils.*;
   
   [API("661")]
   [native(cls="AVMPlusDigestClass",instance="AVMPlusDigestObject",methods="auto",construct="native")]
   internal class AVMPlusDigest
   {
      
      internal static const DIGESTMETHOD_SHA256:uint = 1;
      
      public function AVMPlusDigest()
      {
         super();
      }
      
      public function Init(algorithm:uint) : void
      {
         if(algorithm != DIGESTMETHOD_SHA256)
         {
            throw new Error("Unrecognized digest method");
         }
         this.initInternal(algorithm);
      }
      
      public function Update(data:IDataInput) : uint
      {
         this.clearErrorLog();
         var retval:uint = uint(this.iUpdate(data as ByteArray));
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
         return retval;
      }
      
      public function UpdateWithString(data:String) : uint
      {
         this.clearErrorLog();
         var retval:uint = uint(this.iUpdateWithString(data));
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
         return retval;
      }
      
      public function FinishDigest(inDigestToCompare:String) : uint
      {
         this.clearErrorLog();
         var retval:uint = uint(this.iFinishDigest(inDigestToCompare));
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
         return retval;
      }
      
      private native function initInternal(param1:uint) : void;
      
      private native function iUpdate(param1:ByteArray) : uint;
      
      private native function iUpdateWithString(param1:String) : uint;
      
      private native function iFinishDigest(param1:String) : uint;
      
      private native function getLastError() : String;
      
      private native function clearErrorLog() : void;
   }
}

