package
{
   import flash.display.Sprite;
   import flash.system.*;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _a9c0debc912f9416b4b0a6c72f761a0bfc3964b01f608851c9110edf255d92af_flash_display_Sprite extends Sprite
   {
      
      public function _a9c0debc912f9416b4b0a6c72f761a0bfc3964b01f608851c9110edf255d92af_flash_display_Sprite()
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

