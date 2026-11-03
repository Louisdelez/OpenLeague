package mx.modules
{
   import flash.events.EventDispatcher;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Frame(factoryClass="mx.core.FlexModuleFactory")]
   public class ModuleBase extends EventDispatcher
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function ModuleBase()
      {
         super();
      }
   }
}

