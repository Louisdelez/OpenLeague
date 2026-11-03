package org.swizframework.utils
{
   import flash.system.ApplicationDomain;
   import mx.modules.ModuleManager;
   
   public class DomainUtil
   {
      
      public function DomainUtil()
      {
         super();
      }
      
      public static function getDomain(object:Object) : ApplicationDomain
      {
         var domain:ApplicationDomain = getModuleDomain(object);
         if(domain == null)
         {
            domain = ApplicationDomain.currentDomain;
         }
         return domain;
      }
      
      public static function getModuleDomain(object:Object) : ApplicationDomain
      {
         var moduleInfo:Object = null;
         if(object is ModuleTypeUtil.MODULE_TYPE)
         {
            moduleInfo = ModuleManager.getAssociatedFactory(object).info();
            return moduleInfo.currentDomain;
         }
         return null;
      }
   }
}

