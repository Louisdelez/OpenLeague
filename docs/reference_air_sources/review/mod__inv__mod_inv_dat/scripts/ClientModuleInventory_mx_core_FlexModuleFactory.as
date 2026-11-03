package
{
   import flash.system.ApplicationDomain;
   import flash.system.Security;
   import flash.utils.Dictionary;
   import mx.core.FlexModuleFactory;
   import mx.core.FlexVersion;
   import mx.core.IFlexModule;
   import mx.core.IFlexModuleFactory;
   
   [SWF(width="500", height="375", backgroundColor="#869ca7", frameRate="24")]
   public class ClientModuleInventory_mx_core_FlexModuleFactory extends FlexModuleFactory implements IFlexModuleFactory
   {
      
      private var _preloadedRSLs:Dictionary;
      
      public function ClientModuleInventory_mx_core_FlexModuleFactory()
      {
         FlexVersion.compatibilityVersionString = "3.0.0";
         super();
      }
      
      override public function create(... rest) : Object
      {
         if(rest.length > 0 && !(rest[0] is String))
         {
            return super.create.apply(this,rest);
         }
         var _loc2_:String = rest.length == 0 ? "ClientModuleInventory" : String(rest[0]);
         var _loc3_:Class = Class(getDefinitionByName(_loc2_));
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Object = new _loc3_();
         if(_loc4_ is IFlexModule)
         {
            IFlexModule(_loc4_).moduleFactory = this;
         }
         return _loc4_;
      }
      
      override public function allowInsecureDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowInsecureDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowInsecureDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowInsecureDomainInRSL"](rest);
            }
         }
      }
      
      override public function info() : Object
      {
         return {
            "compiledLocales":[],
            "compiledResourceBundleNames":["collections","logging","messaging"],
            "currentDomain":ApplicationDomain.currentDomain,
            "mainClassName":"ClientModuleInventory"
         };
      }
      
      override public function get preloadedRSLs() : Dictionary
      {
         if(this._preloadedRSLs == null)
         {
            this._preloadedRSLs = new Dictionary(true);
         }
         return this._preloadedRSLs;
      }
      
      override public function allowDomain(... rest) : void
      {
         var _loc2_:Object = null;
         Security.allowDomain(rest);
         for(_loc2_ in this._preloadedRSLs)
         {
            if(Boolean(_loc2_.content) && "allowDomainInRSL" in _loc2_.content)
            {
               _loc2_.content["allowDomainInRSL"](rest);
            }
         }
      }
   }
}

