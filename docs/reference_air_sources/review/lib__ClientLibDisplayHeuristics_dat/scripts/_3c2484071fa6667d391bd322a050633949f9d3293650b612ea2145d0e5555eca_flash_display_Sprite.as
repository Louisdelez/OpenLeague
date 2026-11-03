package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   [ExcludeClass]
   public class _3c2484071fa6667d391bd322a050633949f9d3293650b612ea2145d0e5555eca_flash_display_Sprite extends Sprite
   {
      
      public function _3c2484071fa6667d391bd322a050633949f9d3293650b612ea2145d0e5555eca_flash_display_Sprite()
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

