package mx.modules
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Frame(factoryClass="mx.core.FlexModuleFactory")]
   public class ModuleBase extends EventDispatcher implements IModule
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function ModuleBase()
      {
         super();
      }
   }
}

