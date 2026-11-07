package mx.modules
{
   import mx.core.LayoutContainer;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Frame(factoryClass="mx.core.FlexModuleFactory")]
   public class Module extends LayoutContainer
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Module()
      {
         super();
      }
   }
}

