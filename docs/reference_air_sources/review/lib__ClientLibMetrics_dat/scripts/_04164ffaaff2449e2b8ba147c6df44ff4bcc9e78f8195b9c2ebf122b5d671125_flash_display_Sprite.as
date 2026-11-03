package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _04164ffaaff2449e2b8ba147c6df44ff4bcc9e78f8195b9c2ebf122b5d671125_flash_display_Sprite extends Sprite
   {
      
      public function _04164ffaaff2449e2b8ba147c6df44ff4bcc9e78f8195b9c2ebf122b5d671125_flash_display_Sprite()
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

