package flash.events
{
   import flash.net.drm.*;
   
   [API("667")]
   public class DRMStatusEvent extends Event
   {
      
      public static const DRM_STATUS:String = "drmStatus";
      
      private var m_detail:String;
      
      private var m_voucher:DRMVoucher;
      
      private var m_metadata:DRMContentData;
      
      private var m_isLocal:Boolean;
      
      public function DRMStatusEvent(type:String = "drmStatus", bubbles:Boolean = false, cancelable:Boolean = false, inMetadata:DRMContentData = null, inVoucher:DRMVoucher = null, inLocal:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.m_detail = new String("DRM.voucherObtained");
         this.m_voucher = inVoucher;
         this.m_metadata = inMetadata;
         this.m_isLocal = inLocal;
      }
      
      override public function clone() : Event
      {
         return new DRMStatusEvent(type,bubbles,cancelable,this.m_metadata,this.m_voucher,this.m_isLocal);
      }
      
      override public function toString() : String
      {
         return formatToString("DRMStatusEvent","type","bubbles","cancelable","policies","detail","isAvailableOffline","isAnonymous","voucherEndDate","offlineLeasePeriod");
      }
      
      [API("667")]
      public function get contentData() : DRMContentData
      {
         return this.m_metadata;
      }
      
      [API("667")]
      public function set contentData(value:DRMContentData) : void
      {
         this.m_metadata = value;
      }
      
      [API("667")]
      public function get voucher() : DRMVoucher
      {
         return this.m_voucher;
      }
      
      [API("667")]
      public function set voucher(value:DRMVoucher) : void
      {
         this.m_voucher = value;
      }
      
      [API("667")]
      public function get isLocal() : Boolean
      {
         return this.m_isLocal;
      }
      
      [API("667")]
      public function set isLocal(value:Boolean) : void
      {
         this.m_isLocal = value;
      }
      
      public function get isAvailableOffline() : Boolean
      {
         if(Boolean(this.m_voucher))
         {
            return this.m_voucher.offlineLeaseStartDate != null;
         }
         return false;
      }
      
      public function get isAnonymous() : Boolean
      {
         if(Boolean(this.m_metadata))
         {
            return this.m_metadata.authenticationMethod == "anonymous";
         }
         return false;
      }
      
      public function get voucherEndDate() : Date
      {
         if(Boolean(this.m_voucher))
         {
            return this.m_voucher.voucherEndDate;
         }
         return null;
      }
      
      [API("661")]
      public function get offlineLeasePeriod() : uint
      {
         if(Boolean(this.m_voucher))
         {
            if(this.m_voucher.offlineLeaseStartDate != null)
            {
               if(this.m_voucher.offlineLeaseEndDate != null)
               {
                  return (this.m_voucher.offlineLeaseEndDate.time - this.m_voucher.offlineLeaseStartDate.time) / (1000 * 60 * 60 * 24);
               }
               return uint.MAX_VALUE;
            }
            return 0;
         }
         return 0;
      }
      
      public function get policies() : Object
      {
         if(Boolean(this.m_voucher))
         {
            return this.m_voucher.policies;
         }
         return null;
      }
      
      public function get detail() : String
      {
         return this.m_detail;
      }
   }
}

