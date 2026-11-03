package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _2bbd90f87d0c2988e50177760cbb5da55460e57a815842aebf9c406059086f10_flash_display_Sprite extends Sprite
   {
      
      public function _2bbd90f87d0c2988e50177760cbb5da55460e57a815842aebf9c406059086f10_flash_display_Sprite()
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

