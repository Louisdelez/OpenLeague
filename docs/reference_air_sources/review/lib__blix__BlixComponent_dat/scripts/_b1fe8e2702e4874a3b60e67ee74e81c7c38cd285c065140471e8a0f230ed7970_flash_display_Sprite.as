package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _b1fe8e2702e4874a3b60e67ee74e81c7c38cd285c065140471e8a0f230ed7970_flash_display_Sprite extends Sprite
   {
      
      public function _b1fe8e2702e4874a3b60e67ee74e81c7c38cd285c065140471e8a0f230ed7970_flash_display_Sprite()
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

