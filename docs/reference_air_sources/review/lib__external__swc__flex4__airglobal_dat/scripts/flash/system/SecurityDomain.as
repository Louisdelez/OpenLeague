package flash.system
{
   [native(cls="SecurityDomainClass",gc="exact",instance="SecurityDomainObject",methods="auto")]
   public class SecurityDomain
   {
      
      public function SecurityDomain()
      {
         super();
      }
      
      public static native function get currentDomain() : SecurityDomain;
   }
}

