package com.riotgames.dependencyloader
{
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   
   public interface IDependenciesManager
   {
      
      function getDefaultContext() : LoaderContext;
      
      function getLoader(param1:URLRequest) : DependencyLoader;
      
      function getDependencyLoaderByUrlRequest(param1:URLRequest) : DependencyLoader;
      
      function loadDependencies(param1:Function = null, param2:Function = null) : void;
   }
}

