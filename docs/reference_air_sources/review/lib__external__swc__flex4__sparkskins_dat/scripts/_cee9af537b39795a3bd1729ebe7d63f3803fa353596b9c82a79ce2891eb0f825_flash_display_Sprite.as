package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _cee9af537b39795a3bd1729ebe7d63f3803fa353596b9c82a79ce2891eb0f825_flash_display_Sprite extends Sprite
   {
      
      public function _cee9af537b39795a3bd1729ebe7d63f3803fa353596b9c82a79ce2891eb0f825_flash_display_Sprite()
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

