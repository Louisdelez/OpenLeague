package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _2849ee2c10e427ce40f4514db918d36e305fc450a19da12434ff926fd8d6fb75_flash_display_Sprite extends Sprite
   {
      
      public function _2849ee2c10e427ce40f4514db918d36e305fc450a19da12434ff926fd8d6fb75_flash_display_Sprite()
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

