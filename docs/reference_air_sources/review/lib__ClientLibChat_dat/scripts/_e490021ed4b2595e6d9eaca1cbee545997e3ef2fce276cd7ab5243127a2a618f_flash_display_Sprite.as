package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _e490021ed4b2595e6d9eaca1cbee545997e3ef2fce276cd7ab5243127a2a618f_flash_display_Sprite extends Sprite
   {
      
      public function _e490021ed4b2595e6d9eaca1cbee545997e3ef2fce276cd7ab5243127a2a618f_flash_display_Sprite()
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

