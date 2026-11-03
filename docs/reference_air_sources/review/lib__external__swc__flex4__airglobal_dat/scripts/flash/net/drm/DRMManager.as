package flash.net.drm
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.ByteArray;
   
   [native(cls="DRMManagerClass",instance="DRMManagerObject",methods="auto",construct="native")]
   [API("667")]
   [Event(name="drmError",type="flash.events.DRMErrorEvent")]
   [Event(name="drmStatus",type="flash.events.DRMStatusEvent")]
   [Event(name="authenticationError",type="flash.events.DRMAuthenticationErrorEvent")]
   [Event(name="authenticationComplete",type="flash.events.DRMAuthenticationCompleteEvent")]
   public class DRMManager extends EventDispatcher
   {
      
      private static var theManager:DRMManager = null;
      
      public function DRMManager()
      {
         super();
      }
      
      public static function getDRMManager() : DRMManager
      {
         checkRemoteSWFInvocation();
         if(theManager == null)
         {
            theManager = createDRMManager();
         }
         return theManager;
      }
      
      private static native function createDRMManager() : DRMManager;
      
      [API("667")]
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      private static function checkRemoteSWFInvocation() : void
      {
         if(isCalledFromRemoteSWF() == true)
         {
            throw new SecurityError();
         }
      }
      
      private static native function isCalledFromRemoteSWF() : Boolean;
      
      public function authenticate(serverURL:String, domain:String, username:String, password:String) : void
      {
         var context:DRMAuthenticationContext = new DRMAuthenticationContext();
         context.addEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE,this.onAuthenticationComplete);
         context.addEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR,this.onAuthenticationError);
         context.authenticate(serverURL,domain,username,password);
      }
      
      public function setAuthenticationToken(serverUrl:String, domain:String, token:ByteArray) : void
      {
         var err:uint = uint(this.setSAMLTokenInner(serverUrl,domain,token));
         if(err != 0)
         {
            this.errorCodeToThrow(err);
         }
      }
      
      public function loadVoucher(contentData:DRMContentData, setting:String) : void
      {
         var context:DRMVoucherStoreContext = null;
         if(contentData == null)
         {
            throw new ArgumentError();
         }
         if(setting == LoadVoucherSetting.FORCE_REFRESH)
         {
            this.downloadVoucher(contentData,false);
         }
         else if(setting == LoadVoucherSetting.LOCAL_ONLY)
         {
            context = new DRMVoucherStoreContext();
            context.addEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreComplete);
            context.addEventListener(DRMErrorEvent.DRM_ERROR,this.onGetVoucherFromStoreError);
            context.getVoucherFromStore(contentData);
         }
         else
         {
            if(setting != LoadVoucherSetting.ALLOW_SERVER)
            {
               throw new ArgumentError();
            }
            context = new DRMVoucherStoreContext();
            context.addEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreWithAllowServerComplete);
            context.addEventListener(DRMErrorEvent.DRM_ERROR,this.onGetVoucherFromStoreWithAllowServerError);
            context.getVoucherFromStore(contentData);
         }
      }
      
      [API("667")]
      public function loadPreviewVoucher(contentData:DRMContentData) : void
      {
         if(contentData == null)
         {
            throw new ArgumentError();
         }
         this.downloadVoucher(contentData,true);
      }
      
      private function downloadVoucher(contentData:DRMContentData, previewVoucher:Boolean = false) : void
      {
         var context:DRMVoucherDownloadContext = new DRMVoucherDownloadContext();
         context.addEventListener(DRMStatusEvent.DRM_STATUS,this.onDownloadVoucherComplete);
         context.addEventListener(DRMErrorEvent.DRM_ERROR,this.onDownloadVoucherError);
         context.download(contentData,previewVoucher);
      }
      
      [API("674")]
      public function storeVoucher(voucher:ByteArray) : void
      {
         var err:uint = uint(this.storeVoucherInner(voucher));
         if(err != 0)
         {
            this.errorCodeToThrow(err);
         }
      }
      
      private native function setSAMLTokenInner(param1:String, param2:String, param3:ByteArray) : uint;
      
      private function onAuthenticationComplete(theEvent:DRMAuthenticationCompleteEvent) : void
      {
         var event:Event = theEvent.clone();
         dispatchEvent(event);
         var context:DRMAuthenticationContext = theEvent.target as DRMAuthenticationContext;
         context.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE,this.onAuthenticationComplete);
         context.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR,this.onAuthenticationError);
      }
      
      private function onAuthenticationError(theEvent:DRMAuthenticationErrorEvent) : void
      {
         var event:Event = theEvent.clone();
         dispatchEvent(event);
         var context:DRMAuthenticationContext = theEvent.target as DRMAuthenticationContext;
         context.removeEventListener(DRMAuthenticationCompleteEvent.AUTHENTICATION_COMPLETE,this.onAuthenticationComplete);
         context.removeEventListener(DRMAuthenticationErrorEvent.AUTHENTICATION_ERROR,this.onAuthenticationError);
      }
      
      private function onGetVoucherFromStoreComplete(theEvent:DRMStatusEvent) : void
      {
         this.issueDRMStatusEvent(theEvent.type,theEvent.contentData,theEvent.voucher,true);
         var context:DRMVoucherStoreContext = theEvent.target as DRMVoucherStoreContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onDownloadVoucherError);
      }
      
      private function onGetVoucherFromStoreError(theEvent:DRMErrorEvent) : void
      {
         this.issueDRMErrorEvent(theEvent.contentData,theEvent.errorID,theEvent.subErrorID);
         var context:DRMVoucherStoreContext = theEvent.target as DRMVoucherStoreContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onDownloadVoucherError);
      }
      
      private function onDownloadVoucherComplete(theEvent:DRMStatusEvent) : void
      {
         this.issueDRMStatusEvent(theEvent.type,theEvent.contentData,theEvent.voucher,false);
         var context:DRMVoucherDownloadContext = theEvent.target as DRMVoucherDownloadContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onDownloadVoucherComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onDownloadVoucherError);
      }
      
      private function onGetVoucherFromStoreWithAllowServerComplete(theEvent:DRMStatusEvent) : void
      {
         if(theEvent.voucher != null)
         {
            this.issueDRMStatusEvent(theEvent.type,theEvent.contentData,theEvent.voucher,true);
         }
         else
         {
            this.downloadVoucher(theEvent.contentData);
         }
         var context:DRMVoucherStoreContext = theEvent.target as DRMVoucherStoreContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreWithAllowServerComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onGetVoucherFromStoreWithAllowServerError);
      }
      
      private function onDownloadVoucherError(theEvent:DRMErrorEvent) : void
      {
         this.issueDRMErrorEvent(theEvent.contentData,theEvent.errorID,theEvent.subErrorID);
         var context:DRMVoucherDownloadContext = theEvent.target as DRMVoucherDownloadContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onDownloadVoucherComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onDownloadVoucherError);
      }
      
      private function onGetVoucherFromStoreWithAllowServerError(theEvent:DRMErrorEvent) : void
      {
         this.downloadVoucher(theEvent.contentData);
         var context:DRMVoucherStoreContext = theEvent.target as DRMVoucherStoreContext;
         context.removeEventListener(DRMStatusEvent.DRM_STATUS,this.onGetVoucherFromStoreWithAllowServerComplete);
         context.removeEventListener(DRMErrorEvent.DRM_ERROR,this.onGetVoucherFromStoreWithAllowServerError);
      }
      
      private native function errorCodeToThrow(param1:uint) : void;
      
      private native function issueDRMStatusEvent(param1:String, param2:DRMContentData, param3:DRMVoucher, param4:Boolean) : void;
      
      private native function issueDRMErrorEvent(param1:DRMContentData, param2:int, param3:int, param4:String = null) : void;
      
      private native function storeVoucherInner(param1:ByteArray) : uint;
      
      [API("663")]
      public function resetDRMVouchers() : void
      {
         NetStream.resetDRMVouchers();
      }
      
      [API("675")]
      public function addToDeviceGroup(deviceGroup:DRMDeviceGroup, forceRefresh:Boolean = false) : void
      {
         var context:DRMAddToDeviceGroupContext = new DRMAddToDeviceGroupContext();
         context.addEventListener(DRMDeviceGroupEvent.ADD_TO_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
         context.addEventListener(DRMDeviceGroupErrorEvent.ADD_TO_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         context.addToDeviceGroup(deviceGroup,forceRefresh);
      }
      
      [API("675")]
      public function removeFromDeviceGroup(deviceGroup:DRMDeviceGroup) : void
      {
         var context:DRMRemoveFromDeviceGroupContext = new DRMRemoveFromDeviceGroupContext();
         context.addEventListener(DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
         context.addEventListener(DRMDeviceGroupErrorEvent.REMOVE_FROM_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         context.removeFromDeviceGroup(deviceGroup);
      }
      
      private function onDeviceGroupOperationComplete(theEvent:DRMDeviceGroupEvent) : void
      {
         var context:DRMRemoveFromDeviceGroupContext = null;
         var context2:DRMAddToDeviceGroupContext = null;
         var event:Event = theEvent.clone();
         dispatchEvent(event);
         if(event.type == DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE)
         {
            context = theEvent.target as DRMRemoveFromDeviceGroupContext;
            context.removeEventListener(DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
            context.removeEventListener(DRMDeviceGroupErrorEvent.REMOVE_FROM_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         }
         else
         {
            context2 = theEvent.target as DRMAddToDeviceGroupContext;
            context2.removeEventListener(DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
            context2.removeEventListener(DRMDeviceGroupErrorEvent.REMOVE_FROM_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         }
      }
      
      private function onDeviceGroupOperationError(theEvent:DRMDeviceGroupErrorEvent) : void
      {
         var context:DRMRemoveFromDeviceGroupContext = null;
         var context2:DRMAddToDeviceGroupContext = null;
         var event:Event = theEvent.clone();
         dispatchEvent(event);
         if(event.type == DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE)
         {
            context = theEvent.target as DRMRemoveFromDeviceGroupContext;
            context.removeEventListener(DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
            context.removeEventListener(DRMDeviceGroupErrorEvent.REMOVE_FROM_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         }
         else
         {
            context2 = theEvent.target as DRMAddToDeviceGroupContext;
            context2.removeEventListener(DRMDeviceGroupEvent.REMOVE_FROM_DEVICE_GROUP_COMPLETE,this.onDeviceGroupOperationComplete);
            context2.removeEventListener(DRMDeviceGroupErrorEvent.REMOVE_FROM_DEVICE_GROUP_ERROR,this.onDeviceGroupOperationError);
         }
      }
   }
}

