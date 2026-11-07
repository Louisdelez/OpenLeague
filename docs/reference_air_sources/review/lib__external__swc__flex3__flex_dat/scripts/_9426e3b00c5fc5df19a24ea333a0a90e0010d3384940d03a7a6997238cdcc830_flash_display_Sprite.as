package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _9426e3b00c5fc5df19a24ea333a0a90e0010d3384940d03a7a6997238cdcc830_flash_display_Sprite extends Sprite
   {
      
      public function _9426e3b00c5fc5df19a24ea333a0a90e0010d3384940d03a7a6997238cdcc830_flash_display_Sprite()
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

