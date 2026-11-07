package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _78041093926cfc31165d8fd0e1a915fb3f0f9191a45e6fad557cfcc2680159c9_flash_display_Sprite extends Sprite
   {
      
      public function _78041093926cfc31165d8fd0e1a915fb3f0f9191a45e6fad557cfcc2680159c9_flash_display_Sprite()
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

