package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _23c4658e11608eacb5ff4c617bdb0a1a6c92ce1ee7e8bc0fa7ff601e62e19671_flash_display_Sprite extends Sprite
   {
      
      public function _23c4658e11608eacb5ff4c617bdb0a1a6c92ce1ee7e8bc0fa7ff601e62e19671_flash_display_Sprite()
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

