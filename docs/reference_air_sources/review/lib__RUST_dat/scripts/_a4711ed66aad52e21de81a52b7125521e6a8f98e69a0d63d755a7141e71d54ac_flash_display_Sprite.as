package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _a4711ed66aad52e21de81a52b7125521e6a8f98e69a0d63d755a7141e71d54ac_flash_display_Sprite extends Sprite
   {
      
      public function _a4711ed66aad52e21de81a52b7125521e6a8f98e69a0d63d755a7141e71d54ac_flash_display_Sprite()
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

