package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _b0faf4f2088a1317685b2b87112cf983139b5f5c5ec29e0adbe1431d15c4c096_flash_display_Sprite extends Sprite
   {
      
      public function _b0faf4f2088a1317685b2b87112cf983139b5f5c5ec29e0adbe1431d15c4c096_flash_display_Sprite()
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

