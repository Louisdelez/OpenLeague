package mx.modules
{
   import mx.core.LayoutContainer;
   
   [Alternative(replacement="spark.modules.Module",since="4.5")]
   [Frame(factoryClass="mx.core.FlexModuleFactory")]
   public class Module extends LayoutContainer implements IModule
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function Module()
      {
         super();
      }
   }
}

