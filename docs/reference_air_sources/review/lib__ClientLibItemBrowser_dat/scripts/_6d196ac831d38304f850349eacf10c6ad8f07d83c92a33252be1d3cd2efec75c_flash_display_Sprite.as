package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _6d196ac831d38304f850349eacf10c6ad8f07d83c92a33252be1d3cd2efec75c_flash_display_Sprite extends Sprite
   {
      
      public function _6d196ac831d38304f850349eacf10c6ad8f07d83c92a33252be1d3cd2efec75c_flash_display_Sprite()
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

