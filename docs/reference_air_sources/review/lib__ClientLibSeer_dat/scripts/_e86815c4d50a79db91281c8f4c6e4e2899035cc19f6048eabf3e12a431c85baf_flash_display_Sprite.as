package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _e86815c4d50a79db91281c8f4c6e4e2899035cc19f6048eabf3e12a431c85baf_flash_display_Sprite extends Sprite
   {
      
      public function _e86815c4d50a79db91281c8f4c6e4e2899035cc19f6048eabf3e12a431c85baf_flash_display_Sprite()
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

