package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _f56732c9e3f380de7adb0d429ab01c7b436e8fd330706771a5b7f9a5e7129adc_flash_display_Sprite extends Sprite
   {
      
      public function _f56732c9e3f380de7adb0d429ab01c7b436e8fd330706771a5b7f9a5e7129adc_flash_display_Sprite()
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

