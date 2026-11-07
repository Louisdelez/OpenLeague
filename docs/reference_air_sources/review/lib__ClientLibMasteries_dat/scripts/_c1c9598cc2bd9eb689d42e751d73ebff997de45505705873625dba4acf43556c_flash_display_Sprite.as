package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _c1c9598cc2bd9eb689d42e751d73ebff997de45505705873625dba4acf43556c_flash_display_Sprite extends Sprite
   {
      
      public function _c1c9598cc2bd9eb689d42e751d73ebff997de45505705873625dba4acf43556c_flash_display_Sprite()
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

