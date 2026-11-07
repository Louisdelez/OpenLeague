package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _9c466369f6cff92e4898e85c9c9ad97e7ea84e9abc9659b94ba6012f6a75c4f9_flash_display_Sprite extends Sprite
   {
      
      public function _9c466369f6cff92e4898e85c9c9ad97e7ea84e9abc9659b94ba6012f6a75c4f9_flash_display_Sprite()
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

