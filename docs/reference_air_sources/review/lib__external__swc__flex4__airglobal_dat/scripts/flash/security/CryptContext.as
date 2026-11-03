package flash.security
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   [API("661")]
   [native(cls="CryptContextClass",instance="CryptContextObject",methods="auto",construct="native")]
   internal class CryptContext extends EventDispatcher
   {
      
      internal static const STATUS_VALID:uint = 0;
      
      internal static const STATUS_INVALID:uint = 1;
      
      internal static const STATUS_UNKNOWN:uint = 2;
      
      internal static const STATUS_TROUBLE:uint = 3;
      
      internal static const REVCHECK_NEVER:uint = 0;
      
      internal static const REVCHECK_BEST_EFFORT:uint = 1;
      
      internal static const REVCHECK_REQUIRED_IF_AVAILABLE:uint = 2;
      
      internal static const REVCHECK_ALWAYSREQUIRED:uint = 3;
      
      internal static const TRUSTFLAG_SIGNING:uint = 1;
      
      internal static const TRUSTFLAG_PLAYLISTSIGNING:uint = 16;
      
      internal static const TRUSTFLAG_CODESIGNING:uint = 256;
      
      public function CryptContext()
      {
         super();
      }
      
      private static native function setSynchronousFlag(param1:URLRequest) : void;
      
      public function VerifySigASync(sig:String, data:String, ignoreCertTime:Boolean) : void
      {
         this.clearErrorLog();
         this.iVerifySigASync(sig,data,ignoreCertTime);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function VerifySigSync(sig:String, data:String, ignoreCertTime:Boolean) : void
      {
         this.clearErrorLog();
         this.iVerifySigSync(sig,data,ignoreCertTime);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function setSignerCert(cert:String) : *
      {
         this.clearErrorLog();
         this.isetSignerCert(cert);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function setSignerCertDN(dn:String) : *
      {
         this.clearErrorLog();
         this.isetSignerCertDN(dn);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function addChainBuildingCertBase64(cert:String, trusted:Boolean) : void
      {
         this.clearErrorLog();
         this.iaddChainBuildingCertBase64(cert,trusted);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function addChainBuildingCertRaw(cert:ByteArray, trusted:Boolean) : void
      {
         this.clearErrorLog();
         this.iaddChainBuildingCertRaw(cert,trusted);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function addTimestampingRootRaw(cert:ByteArray) : void
      {
         this.clearErrorLog();
         this.iaddTimestampingRootRaw(cert);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function addCRLRevEvidenceBase64(crl:String) : void
      {
         this.clearErrorLog();
         this.iaddCRLRevEvidenceBase64(crl);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public function addCRLRevEvidenceRaw(crl:ByteArray) : void
      {
         this.clearErrorLog();
         this.iaddCRLRevEvidenceRaw(crl);
         var errorStr:String = this.getLastError();
         if(errorStr != null)
         {
            this.clearErrorLog();
            throw new Error(errorStr);
         }
      }
      
      public native function verifyTimestamp(param1:String, param2:String, param3:Boolean) : void;
      
      private native function iVerifySigASync(param1:String, param2:String, param3:Boolean) : void;
      
      private native function iVerifySigSync(param1:String, param2:String, param3:Boolean) : void;
      
      private native function isetSignerCert(param1:String) : void;
      
      private native function isetSignerCertDN(param1:String) : void;
      
      private native function iaddChainBuildingCertBase64(param1:String, param2:Boolean) : void;
      
      private native function iaddChainBuildingCertRaw(param1:ByteArray, param2:Boolean) : void;
      
      private native function iaddCRLRevEvidenceBase64(param1:String) : void;
      
      private native function iaddCRLRevEvidenceRaw(param1:ByteArray) : void;
      
      private native function iaddTimestampingRootRaw(param1:ByteArray) : void;
      
      public native function HasValidVerifySession() : Boolean;
      
      public native function getDataTBVStatus() : uint;
      
      public native function getIDStatus() : uint;
      
      public native function getOverallStatus() : uint;
      
      public native function useSystemTrustStore(param1:Boolean) : void;
      
      public native function getUseSystemTrustStore() : Boolean;
      
      public native function setRevCheckSetting(param1:String) : void;
      
      public native function getRevCheckSetting() : String;
      
      public native function setTimestampRevCheckSetting(param1:String) : void;
      
      public native function getTimestampRevCheckSetting() : String;
      
      public native function useCodeSigningValidationRules() : void;
      
      private native function getLastError() : String;
      
      private native function clearErrorLog() : void;
      
      public native function getSignerTrustFlags() : uint;
      
      public function getSignerTrustSettings() : Array
      {
         var trustFlags:uint = 0;
         var trustSettings:Array = new Array();
         if(this.HasValidVerifySession() && this.getOverallStatus() == STATUS_VALID)
         {
            trustFlags = this.getSignerTrustFlags();
            if((trustFlags & TRUSTFLAG_SIGNING) == TRUSTFLAG_SIGNING)
            {
               trustSettings.push(SignerTrustSettings.SIGNING);
            }
            if((trustFlags & TRUSTFLAG_PLAYLISTSIGNING) == TRUSTFLAG_PLAYLISTSIGNING)
            {
               trustSettings.push(SignerTrustSettings.PLAYLIST_SIGNING);
            }
            if((trustFlags & TRUSTFLAG_CODESIGNING) == TRUSTFLAG_CODESIGNING)
            {
               trustSettings.push(SignerTrustSettings.CODE_SIGNING);
            }
         }
         return trustSettings;
      }
      
      public function getSignerExtendedKeyUsages() : Array
      {
         var ekus:Array = new Array();
         this.getSignerExtendedKeyUsagesInternal(ekus);
         return ekus;
      }
      
      private native function getSignerExtendedKeyUsagesInternal(param1:Array) : void;
      
      private function onAsyncDownloadComplete(event:Event) : void
      {
         var results:ByteArray = new ByteArray();
         var urlStream:URLStream = event.target as URLStream;
         urlStream.readBytes(results);
         this.returnDownloadDataToTransportLayer(results);
      }
      
      private function onAsyncDownloadError(event:Event) : void
      {
         this.returnDownloadDataToTransportLayer(null);
      }
      
      private native function returnDownloadDataToTransportLayer(param1:ByteArray) : void;
      
      private function sendDownloadRequestASync(url:String) : void
      {
         var urlRequest:URLRequest = new URLRequest(url);
         var urlStream:URLStream = new URLStream();
         urlStream.addEventListener(Event.COMPLETE,this.onAsyncDownloadComplete);
         urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onAsyncDownloadError);
         urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onAsyncDownloadError);
         urlStream.load(urlRequest);
      }
      
      private function postAndReceiveASync(url:String, header:String, data:ByteArray) : void
      {
         var urlRequest:URLRequest = new URLRequest(url);
         urlRequest.method = URLRequestMethod.POST;
         urlRequest.data = data;
         var rhArray:Array = new Array(new URLRequestHeader("Content-Type",header));
         urlRequest.requestHeaders = rhArray;
         var urlStream:URLStream = new URLStream();
         urlStream.addEventListener(Event.COMPLETE,this.onAsyncDownloadComplete);
         urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onAsyncDownloadError);
         urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onAsyncDownloadError);
         urlStream.load(urlRequest);
      }
      
      private function onSyncDownloadError(event:Event) : void
      {
      }
      
      private function sendDownloadRequestSync(url:String) : ByteArray
      {
         var urlRequest:URLRequest = new URLRequest(url);
         setSynchronousFlag(urlRequest);
         var urlStream:URLStream = new URLStream();
         urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onSyncDownloadError);
         urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSyncDownloadError);
         urlStream.load(urlRequest);
         var results:ByteArray = new ByteArray();
         urlStream.readBytes(results);
         return results;
      }
      
      private function postAndReceiveSync(url:String, header:String, data:ByteArray) : ByteArray
      {
         var urlRequest:URLRequest = new URLRequest(url);
         setSynchronousFlag(urlRequest);
         urlRequest.method = URLRequestMethod.POST;
         urlRequest.data = data;
         var rhArray:Array = new Array(new URLRequestHeader("Content-Type",header));
         urlRequest.requestHeaders = rhArray;
         var urlStream:URLStream = new URLStream();
         urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onSyncDownloadError);
         urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSyncDownloadError);
         urlStream.load(urlRequest);
         var results:ByteArray = new ByteArray();
         urlStream.readBytes(results);
         return results;
      }
      
      public native function get signerCN() : String;
      
      public native function get signerDN() : String;
      
      public native function getPublicKey(param1:String) : ByteArray;
      
      public native function get signerValidEnd() : uint;
      
      public native function get verificationTime() : uint;
      
      public native function getSignerIDSummary(param1:uint) : String;
      
      public native function getIDSummaryFromSigChain(param1:uint) : String;
   }
}

