package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _709a3360346efb529a6eee092cea096985e31198dff79557ad98cf3a6a3c57a7_flash_display_Sprite extends Sprite
   {
      
      public function _709a3360346efb529a6eee092cea096985e31198dff79557ad98cf3a6a3c57a7_flash_display_Sprite()
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

