package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _0884d370e7fb572134f384caa02353e7c3e7d860891baf3324e4e1d451ca84bd_flash_display_Sprite extends Sprite
   {
      
      public function _0884d370e7fb572134f384caa02353e7c3e7d860891baf3324e4e1d451ca84bd_flash_display_Sprite()
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

