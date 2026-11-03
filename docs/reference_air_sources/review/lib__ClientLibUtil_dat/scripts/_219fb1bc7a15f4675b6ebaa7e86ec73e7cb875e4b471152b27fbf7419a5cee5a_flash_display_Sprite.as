package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _219fb1bc7a15f4675b6ebaa7e86ec73e7cb875e4b471152b27fbf7419a5cee5a_flash_display_Sprite extends Sprite
   {
      
      public function _219fb1bc7a15f4675b6ebaa7e86ec73e7cb875e4b471152b27fbf7419a5cee5a_flash_display_Sprite()
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

