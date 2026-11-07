package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _10978193b1fbaccafc33d723971c5379d8760d86ffca6a5b934e765ceab21a8a_flash_display_Sprite extends Sprite
   {
      
      public function _10978193b1fbaccafc33d723971c5379d8760d86ffca6a5b934e765ceab21a8a_flash_display_Sprite()
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

