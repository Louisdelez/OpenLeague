package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _2b89a1be46d1973dc8ec103eb8917fb785e1ffada5372a3b4b24fbd8be3bc82e_flash_display_Sprite extends Sprite
   {
      
      public function _2b89a1be46d1973dc8ec103eb8917fb785e1ffada5372a3b4b24fbd8be3bc82e_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain(rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain(rest);
      }
   }
}

