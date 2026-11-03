package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _e9a752f233536079fc4486d6ac92a1b05a633a5657d5b83ad7fac2246298b191_flash_display_Sprite extends Sprite
   {
      
      public function _e9a752f233536079fc4486d6ac92a1b05a633a5657d5b83ad7fac2246298b191_flash_display_Sprite()
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

