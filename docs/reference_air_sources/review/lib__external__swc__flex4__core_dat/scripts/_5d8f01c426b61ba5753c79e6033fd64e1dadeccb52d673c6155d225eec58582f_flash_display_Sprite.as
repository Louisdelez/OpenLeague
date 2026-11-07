package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _5d8f01c426b61ba5753c79e6033fd64e1dadeccb52d673c6155d225eec58582f_flash_display_Sprite extends Sprite
   {
      
      public function _5d8f01c426b61ba5753c79e6033fd64e1dadeccb52d673c6155d225eec58582f_flash_display_Sprite()
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

