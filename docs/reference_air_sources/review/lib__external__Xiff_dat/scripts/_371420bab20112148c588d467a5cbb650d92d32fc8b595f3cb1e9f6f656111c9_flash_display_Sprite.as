package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _371420bab20112148c588d467a5cbb650d92d32fc8b595f3cb1e9f6f656111c9_flash_display_Sprite extends Sprite
   {
      
      public function _371420bab20112148c588d467a5cbb650d92d32fc8b595f3cb1e9f6f656111c9_flash_display_Sprite()
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

