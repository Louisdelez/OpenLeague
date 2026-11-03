package com.riotgames.dependencyloader
{
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public class DependenciesManager
   {
      
      private static var _impl:IDependenciesManager;
      
      public function DependenciesManager()
      {
         super();
      }
      
      public static function get impl() : IDependenciesManager
      {
         if(_impl == null)
         {
            _impl = new DependenciesManagerImpl();
         }
         return _impl;
      }
      
      public static function registerImpl(param1:IDependenciesManager) : void
      {
         if(param1 != null && _impl != null)
         {
            throw new Error("The implementation has already been registered.");
         }
         _impl = param1;
      }
      
      public static function getDefaultContext() : LoaderContext
      {
         return impl.getDefaultContext();
      }
      
      public static function getLoader(param1:URLRequest) : DependencyLoader
      {
         return impl.getLoader(param1);
      }
      
      public static function getDependencyLoaderByUrlRequest(param1:URLRequest) : DependencyLoader
      {
         return impl.getDependencyLoaderByUrlRequest(param1);
      }
      
      public static function loadDependencies(param1:Function = null, param2:Function = null) : void
      {
         impl.loadDependencies(param1,param2);
      }
   }
}

