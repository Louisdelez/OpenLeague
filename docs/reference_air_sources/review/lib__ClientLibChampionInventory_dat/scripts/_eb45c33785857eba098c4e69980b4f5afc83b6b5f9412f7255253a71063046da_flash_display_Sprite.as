package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _eb45c33785857eba098c4e69980b4f5afc83b6b5f9412f7255253a71063046da_flash_display_Sprite extends Sprite
   {
      
      public function _eb45c33785857eba098c4e69980b4f5afc83b6b5f9412f7255253a71063046da_flash_display_Sprite()
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

