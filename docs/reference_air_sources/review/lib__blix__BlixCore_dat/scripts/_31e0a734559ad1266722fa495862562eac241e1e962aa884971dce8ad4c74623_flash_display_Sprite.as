package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _31e0a734559ad1266722fa495862562eac241e1e962aa884971dce8ad4c74623_flash_display_Sprite extends Sprite
   {
      
      public function _31e0a734559ad1266722fa495862562eac241e1e962aa884971dce8ad4c74623_flash_display_Sprite()
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

