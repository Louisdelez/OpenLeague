package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _acad732f80b995a9be3d0acf82794654df43e276529cf550c50c69b711c7619a_flash_display_Sprite extends Sprite
   {
      
      public function _acad732f80b995a9be3d0acf82794654df43e276529cf550c50c69b711c7619a_flash_display_Sprite()
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

