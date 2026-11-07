package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _963679d20949c057e332f950319aa235f81057a1f0baaeb3a1c00e3215eabf97_flash_display_Sprite extends Sprite
   {
      
      public function _963679d20949c057e332f950319aa235f81057a1f0baaeb3a1c00e3215eabf97_flash_display_Sprite()
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

