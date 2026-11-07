package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _51b436ddc523a06a92b03a513eccbc153ac1af5b5cbfe6ddf9cd7e49c285b005_flash_display_Sprite extends Sprite
   {
      
      public function _51b436ddc523a06a92b03a513eccbc153ac1af5b5cbfe6ddf9cd7e49c285b005_flash_display_Sprite()
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

