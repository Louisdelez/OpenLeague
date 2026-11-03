package com.riotgames.dependencyloader
{
   import blix.util.string.strTrim;
   import flash.events.ErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   
   public class DependenciesManagerImpl implements IDependenciesManager
   {
      
      public static const MODULE_BLACKLIST:Array = ["fale","rds"];
      
      private var dependencyLoaders:Vector.<DependencyLoader>;
      
      private var context:LoaderContext;
      
      private var DEPENDENCIES_DESCRIPTOR:String = "dependencies.properties";
      
      public function DependenciesManagerImpl()
      {
         super();
      }
      
      public function getDefaultContext() : LoaderContext
      {
         if(this.context == null)
         {
            this.context = new LoaderContext();
            this.context.allowCodeImport = true;
            this.context.applicationDomain = ApplicationDomain.currentDomain;
            if(Security.sandboxType == Security.REMOTE)
            {
               this.context.securityDomain = SecurityDomain.currentDomain;
            }
         }
         return this.context;
      }
      
      public function getLoader(param1:URLRequest) : DependencyLoader
      {
         if(this.dependencyLoaders == null)
         {
            throw new Error("You must first load the dependency tree through loadDependencies.");
         }
         var _loc2_:DependencyLoader = this.getDependencyLoaderByUrlRequest(param1);
         if(_loc2_ == null)
         {
            _loc2_ = new DependencyLoader(param1,new Vector.<DependencyLoader>(),this.getDefaultContext());
            this.dependencyLoaders[this.dependencyLoaders.length] = _loc2_;
         }
         return _loc2_;
      }
      
      public function getDependencyLoaderByUrlRequest(param1:URLRequest) : DependencyLoader
      {
         var _loc2_:DependencyLoader = null;
         for each(_loc2_ in this.dependencyLoaders)
         {
            if(this.compareUrlRequest(param1,_loc2_.getUrlRequest()))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function compareUrlRequest(param1:URLRequest, param2:URLRequest) : Boolean
      {
         if(param1.url != param2.url)
         {
            return false;
         }
         if(param1.method != param2.method)
         {
            return false;
         }
         if(param1.data != null != (param2.data != null))
         {
            return false;
         }
         if(param1.data != null && param1.data.toString() != param2.data.toString())
         {
            return false;
         }
         return true;
      }
      
      public function loadDependencies(param1:Function = null, param2:Function = null) : void
      {
         var dependenciesDescriptions:String = null;
         var successCallback:Function = param1;
         var failCallback:Function = param2;
         try
         {
            dependenciesDescriptions = this.buildDependenciesDescriptionsFromFragments();
            this.dependencyLoaders = this.parseDependencies(dependenciesDescriptions);
            if(successCallback != null)
            {
               successCallback();
            }
         }
         catch(error:Error)
         {
            if(failCallback != null)
            {
               failCallback(new ErrorEvent(ErrorEvent.ERROR,false,false,error.message));
            }
         }
      }
      
      private function buildDependenciesDescriptionsFromFragments() : String
      {
         var _loc1_:File = new File(File.applicationDirectory.resolvePath("mod").nativePath);
         var _loc2_:File = new File(File.applicationDirectory.resolvePath("lib").nativePath);
         var _loc3_:String = "";
         if(Boolean(_loc2_.exists) && Boolean(_loc2_.isDirectory))
         {
            _loc3_ += this.loadDependencyFragments(_loc2_,9);
         }
         _loc3_ += "\n\n";
         if(Boolean(_loc1_.exists) && Boolean(_loc1_.isDirectory))
         {
            _loc3_ += this.loadDependencyFragments(_loc1_,1);
         }
         return _loc3_;
      }
      
      private function loadDependencyFragments(param1:File, param2:uint = 0) : String
      {
         return this.doLoadDependencyFragments(param1,0,param2);
      }
      
      private function doLoadDependencyFragments(param1:File, param2:uint, param3:uint = 0) : String
      {
         var _loc5_:File = null;
         var _loc6_:File = null;
         var _loc7_:FileStream = null;
         var _loc8_:String = null;
         var _loc4_:String = "";
         if(Boolean(param1.exists) && Boolean(param1.isDirectory))
         {
            if(param2 < param3)
            {
               for each(_loc6_ in param1.getDirectoryListing())
               {
                  if(_loc6_.isDirectory)
                  {
                     if(MODULE_BLACKLIST.indexOf(_loc6_.name) == -1)
                     {
                        _loc4_ += this.doLoadDependencyFragments(_loc6_,param2 + 1,param3);
                        _loc4_ = _loc4_ + "\n\n";
                     }
                  }
               }
            }
            _loc5_ = param1.resolvePath(this.DEPENDENCIES_DESCRIPTOR);
            if(_loc5_.exists)
            {
               _loc7_ = new FileStream();
               _loc7_.open(_loc5_,FileMode.READ);
               _loc8_ = _loc7_.readUTFBytes(_loc7_.bytesAvailable);
               _loc4_ += _loc8_;
               _loc7_.close();
            }
         }
         return _loc4_;
      }
      
      public function parseDependencies(param1:String) : Vector.<DependencyLoader>
      {
         var _loc6_:String = null;
         var _loc7_:Vector.<DependencyLoader> = null;
         var _loc8_:DependencyInfo = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc2_:Array = param1.split("\n");
         var _loc3_:Vector.<DependencyInfo> = new Vector.<DependencyInfo>();
         var _loc4_:DependencyInfo = null;
         var _loc5_:uint = 0;
         for each(_loc6_ in _loc2_)
         {
            _loc5_++;
            _loc9_ = strTrim(_loc6_);
            if(_loc9_)
            {
               if(!(_loc9_.charAt(0) == "#" || _loc9_.charAt(0) == "/"))
               {
                  if(_loc6_.charAt(0) != "\t")
                  {
                     if(_loc4_ != null)
                     {
                        _loc3_[_loc3_.length] = _loc4_;
                     }
                     _loc10_ = _loc9_.split(" ");
                     this.spliceEmpties(_loc10_);
                     if(_loc10_.length < 2)
                     {
                        throw new Error("Invalid dependencies description at line #" + _loc5_ + ". Expected line to be formatted: name filename.");
                     }
                     _loc4_ = new DependencyInfo(_loc10_[0],_loc10_[1]);
                  }
                  else
                  {
                     if(_loc4_ == null)
                     {
                        throw new Error("Invalid dependencies description at line #" + _loc5_ + ". Lines with tabs indicate a dependency.");
                     }
                     _loc4_.addDependency(_loc9_);
                  }
               }
            }
         }
         _loc3_[_loc3_.length] = _loc4_;
         _loc7_ = new Vector.<DependencyLoader>();
         for each(_loc8_ in _loc3_)
         {
            _loc7_[_loc7_.length] = this.createDependencyLoader(_loc8_,_loc3_);
         }
         return _loc7_;
      }
      
      private function spliceEmpties(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         while(_loc2_--)
         {
            if(!param1[_loc2_])
            {
               param1.splice(_loc2_,1);
            }
         }
      }
      
      private function createDependencyLoader(param1:DependencyInfo, param2:Vector.<DependencyInfo>) : DependencyLoader
      {
         var _loc3_:Vector.<DependencyLoader> = null;
         var _loc4_:String = null;
         var _loc5_:DependencyInfo = null;
         if(param1.dependencyLoader != null)
         {
            return param1.dependencyLoader;
         }
         if(param1.dependencies.length == 0)
         {
            param1.dependencyLoader = new DependencyLoader(new URLRequest(param1.filename),new Vector.<DependencyLoader>(),this.getDefaultContext());
         }
         else
         {
            _loc3_ = new Vector.<DependencyLoader>();
            for each(_loc4_ in param1.dependencies)
            {
               _loc5_ = this.getDependencyInfoByName(_loc4_,param2);
               if(_loc5_ == null)
               {
                  param1.dependencyLoader = this.createInvalidDependencyLoader(param1,_loc4_);
                  break;
               }
               _loc3_[_loc3_.length] = this.createDependencyLoader(_loc5_,param2);
            }
            if(param1.dependencyLoader == null)
            {
               param1.dependencyLoader = new DependencyLoader(new URLRequest(param1.filename),_loc3_,this.getDefaultContext());
            }
         }
         return param1.dependencyLoader;
      }
      
      private function createInvalidDependencyLoader(param1:DependencyInfo, param2:String) : DependencyLoader
      {
         var _loc3_:DependencyLoader = new DependencyLoader(new URLRequest(param1.filename),new Vector.<DependencyLoader>(),this.getDefaultContext());
         _loc3_.addInvalidDependency(param2);
         return _loc3_;
      }
      
      private function getDependencyInfoByName(param1:String, param2:Vector.<DependencyInfo>) : DependencyInfo
      {
         var _loc3_:DependencyInfo = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

import com.riotgames.dependencyloader.DependencyLoader;

class DependencyInfo
{
   
   public var name:String;
   
   public var filename:String;
   
   public var dependencies:Vector.<String> = new Vector.<String>();
   
   public var dependencyLoader:DependencyLoader;
   
   public function DependencyInfo(param1:String, param2:String)
   {
      super();
      this.name = param1;
      this.filename = param2;
   }
   
   public function addDependency(param1:String) : void
   {
      this.dependencies[this.dependencies.length] = param1;
   }
   
   public function toString() : String
   {
      return "[DependenciesManager name=" + this.name + " filename=" + this.filename + " dependencies=" + this.dependencies + "]";
   }
}
