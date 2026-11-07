package spark.modules
{
   import mx.modules.IModule;
   import spark.components.SkinnableContainer;
   
   [DiscouragedForProfile("mobileDevice")]
   [Frame(factoryClass="mx.core.FlexModuleFactory")]
   public class Module extends SkinnableContainer implements IModule
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      public function Module()
      {
         super();
      }
   }
}

