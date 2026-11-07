package flash.net.drm
{
   [API("667")]
   public final class VoucherAccessInfo
   {
      
      private var m_displayName:String;
      
      private var m_authMethod:String;
      
      private var m_domain:String;
      
      private var m_deviceGroup:DRMDeviceGroup;
      
      public function VoucherAccessInfo()
      {
         super();
      }
      
      public function get displayName() : String
      {
         return this.m_displayName;
      }
      
      public function get authenticationMethod() : String
      {
         return this.m_authMethod;
      }
      
      public function get domain() : String
      {
         return this.m_domain;
      }
      
      private function setFields(inDisplayName:String, inAuthMethod:String, inDomain:String) : *
      {
         this.m_displayName = inDisplayName;
         this.m_authMethod = inAuthMethod;
         this.m_domain = inDomain;
      }
      
      public function get deviceGroup() : DRMDeviceGroup
      {
         return this.m_deviceGroup;
      }
      
      private function setDeviceGroup(inDeviceGroup:DRMDeviceGroup) : *
      {
         this.m_deviceGroup = inDeviceGroup;
      }
   }
}

