package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _022b8a8bb94dcc4df9c30f9be950d42865d2131b86f63db0b7ed44680524ce44_flash_display_Sprite extends Sprite
   {
      
      public function _022b8a8bb94dcc4df9c30f9be950d42865d2131b86f63db0b7ed44680524ce44_flash_display_Sprite()
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

