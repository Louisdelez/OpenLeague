package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   [ExcludeClass]
   public class _a4137a4a05bb9c53f16a76992e2ab82632ac97e870e7bc45cc947c9513e87261_flash_display_Sprite extends Sprite
   {
      
      public function _a4137a4a05bb9c53f16a76992e2ab82632ac97e870e7bc45cc947c9513e87261_flash_display_Sprite()
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

