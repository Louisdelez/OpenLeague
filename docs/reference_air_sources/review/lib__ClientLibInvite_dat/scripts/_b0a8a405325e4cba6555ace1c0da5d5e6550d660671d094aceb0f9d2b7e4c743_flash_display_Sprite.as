package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _b0a8a405325e4cba6555ace1c0da5d5e6550d660671d094aceb0f9d2b7e4c743_flash_display_Sprite extends Sprite
   {
      
      public function _b0a8a405325e4cba6555ace1c0da5d5e6550d660671d094aceb0f9d2b7e4c743_flash_display_Sprite()
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

