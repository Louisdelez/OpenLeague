package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _59432214c4e9c28b1f5b3e38c744d50bc157730f21d357e36a7c197f4e316862_flash_display_Sprite extends Sprite
   {
      
      public function _59432214c4e9c28b1f5b3e38c744d50bc157730f21d357e36a7c197f4e316862_flash_display_Sprite()
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

