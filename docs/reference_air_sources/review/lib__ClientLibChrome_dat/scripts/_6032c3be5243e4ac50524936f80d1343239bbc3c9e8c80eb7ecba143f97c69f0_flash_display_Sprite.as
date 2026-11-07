package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _6032c3be5243e4ac50524936f80d1343239bbc3c9e8c80eb7ecba143f97c69f0_flash_display_Sprite extends Sprite
   {
      
      public function _6032c3be5243e4ac50524936f80d1343239bbc3c9e8c80eb7ecba143f97c69f0_flash_display_Sprite()
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

