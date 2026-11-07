package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _d7a9ab18008edd5a40d1803259ea8dbbdbde3b45d6d91cca366054f68b7c9e5d_flash_display_Sprite extends Sprite
   {
      
      public function _d7a9ab18008edd5a40d1803259ea8dbbdbde3b45d6d91cca366054f68b7c9e5d_flash_display_Sprite()
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

