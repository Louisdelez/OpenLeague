package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _db649f25bffcda3e4e95bbe6b3c5693bdf43aa4030f22c3e11fd97ad10fa615e_flash_display_Sprite extends Sprite
   {
      
      public function _db649f25bffcda3e4e95bbe6b3c5693bdf43aa4030f22c3e11fd97ad10fa615e_flash_display_Sprite()
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

