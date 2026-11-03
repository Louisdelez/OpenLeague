package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _f7d90be4f5e1b72b26b5630381b0fce8677615252c6996477ecffd5ae613cf28_flash_display_Sprite extends Sprite
   {
      
      public function _f7d90be4f5e1b72b26b5630381b0fce8677615252c6996477ecffd5ae613cf28_flash_display_Sprite()
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

