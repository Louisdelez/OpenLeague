package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _83cc79bd8db5c38220632f70693d9af676d60e2d41087c0ec3a02a627b2c5a6a_flash_display_Sprite extends Sprite
   {
      
      public function _83cc79bd8db5c38220632f70693d9af676d60e2d41087c0ec3a02a627b2c5a6a_flash_display_Sprite()
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

