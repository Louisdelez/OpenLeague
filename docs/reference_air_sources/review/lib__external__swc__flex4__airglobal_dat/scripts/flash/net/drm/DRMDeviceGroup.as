package flash.net.drm
{
   [native(cls="DRMDeviceGroupClass",instance="DRMDeviceGroupObject",methods="auto")]
   [API("675")]
   public final class DRMDeviceGroup
   {
      
      private var m_authMethod:String;
      
      private var m_url:String;
      
      private var m_domain:String;
      
      public function DRMDeviceGroup()
      {
         super();
      }
      
      public function get serverURL() : String
      {
         return this.m_url;
      }
      
      public function get authenticationMethod() : String
      {
         return this.m_authMethod;
      }
      
      public function get domain() : String
      {
         return this.m_domain;
      }
      
      private function setFields(inUrl:String, inAuthMethod:String, inDomain:String) : *
      {
         this.m_url = inUrl;
         this.m_authMethod = inAuthMethod;
         this.m_domain = inDomain;
      }
      
      private native function dummy() : void;
   }
}

