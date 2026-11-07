package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _e9eb19900813b5601b138d68ac3b07b685065381200dfdafd9532ff1f2442605_flash_display_Sprite extends Sprite
   {
      
      public function _e9eb19900813b5601b138d68ac3b07b685065381200dfdafd9532ff1f2442605_flash_display_Sprite()
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

