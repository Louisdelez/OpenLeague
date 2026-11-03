package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _1a64bbe873258ad493e38f4a309bf83ec1fe8665acaf256c167b3746ea869350_flash_display_Sprite extends Sprite
   {
      
      public function _1a64bbe873258ad493e38f4a309bf83ec1fe8665acaf256c167b3746ea869350_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}

