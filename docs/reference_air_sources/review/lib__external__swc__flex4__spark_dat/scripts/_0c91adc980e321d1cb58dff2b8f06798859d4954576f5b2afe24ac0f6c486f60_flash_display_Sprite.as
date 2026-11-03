package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _0c91adc980e321d1cb58dff2b8f06798859d4954576f5b2afe24ac0f6c486f60_flash_display_Sprite extends Sprite
   {
      
      public function _0c91adc980e321d1cb58dff2b8f06798859d4954576f5b2afe24ac0f6c486f60_flash_display_Sprite()
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

