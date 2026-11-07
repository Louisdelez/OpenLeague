package com.riotgames.platform.common.utils
{
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.dependencyloader.DependenciesManager;
   import com.riotgames.dependencyloader.DependencyLoader;
   import flash.display.LoaderInfo;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LoaderUtilImagePacks
   {
      
      private static const IMAGE_PACKS_PATH:String = "assets/imagePacks";
      
      private var _imagePacksLoaded:Signal = new OnceSignal();
      
      private var _masterClassMap:Dictionary = new Dictionary();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _imagePacksToLoad:ArrayCollection = new ArrayCollection();
      
      public function LoaderUtilImagePacks()
      {
         super();
      }
      
      public function get imagePacksLoaded() : ISignal
      {
         return this._imagePacksLoaded;
      }
      
      private function checkImagePacksComplete() : void
      {
         if(this._imagePacksToLoad.length == 0)
         {
            this._imagePacksLoaded.dispatch(this._masterClassMap);
         }
      }
      
      public function loadImagePacks() : void
      {
         var _loc2_:File = null;
         var _loc3_:File = null;
         var _loc4_:DependencyLoader = null;
         var _loc1_:File = new File(File.applicationDirectory.resolvePath(IMAGE_PACKS_PATH).nativePath);
         if(!_loc1_.exists || !_loc1_.isDirectory)
         {
            this.logger.fatal("Image packs root does not exist: " + IMAGE_PACKS_PATH);
            throw new Error("LoaderUtilImagePacks could not find image packs root: " + IMAGE_PACKS_PATH);
         }
         for each(_loc2_ in _loc1_.getDirectoryListing())
         {
            if(!_loc2_.isDirectory && _loc2_.extension.toLowerCase() == "swf")
            {
               this._imagePacksToLoad.addItem(_loc2_);
            }
         }
         if(this._imagePacksToLoad.length == 0)
         {
            this.logger.fatal("Image packs could not be found at: " + IMAGE_PACKS_PATH);
            throw new Error("LoaderUtilImagePacks could not find any image packs: " + IMAGE_PACKS_PATH);
         }
         for each(_loc3_ in this._imagePacksToLoad)
         {
            _loc4_ = DependenciesManager.getLoader(new URLRequest(_loc3_.url));
            _loc4_.load(this.onImagePackLoadComplete,this.handleImagePackLoadError);
         }
      }
      
      private function onImagePackLoadComplete(param1:DependencyLoader) : void
      {
         var _loc7_:File = null;
         var _loc2_:LoaderInfo = param1.getLoader().contentLoaderInfo;
         var _loc3_:String = param1.getUrlRequest().url;
         var _loc4_:Array = _loc3_.split("_");
         if(_loc4_ == null || _loc4_.length < 2)
         {
            this.logger.fatal("Could not determine image pack name: " + _loc3_);
            throw new Error("LoaderUtilImagePacks could not determine image pack name: " + _loc3_);
         }
         var _loc5_:String = _loc4_[_loc4_.length - 1];
         _loc5_ = _loc5_.substring(0,_loc5_.indexOf("."));
         this.loadImagePackData(_loc2_.applicationDomain,_loc3_,_loc5_);
         var _loc6_:File = null;
         for each(_loc7_ in this._imagePacksToLoad)
         {
            if(_loc3_ == _loc7_.url)
            {
               _loc6_ = _loc7_;
               break;
            }
         }
         if(_loc6_ == null)
         {
            this.logger.fatal("Image pack loaded but not recognized: " + _loc3_);
            throw new Error("LoaderUtilImagePacks loaded unrecognized image pack: " + _loc3_);
         }
         this._imagePacksToLoad.removeItemAt(this._imagePacksToLoad.getItemIndex(_loc6_));
         this.checkImagePacksComplete();
      }
      
      private function handleImagePackLoadError(param1:DependencyLoader) : void
      {
         this.logger.fatal("Image pack failed to load: " + param1.getUrlRequest().url);
         throw new Error("LoaderUtilImagePacks failed to load image pack: " + param1.getUrlRequest().url);
      }
      
      private function loadImagePackData(param1:ApplicationDomain, param2:String, param3:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc4_:Object = param1.getDefinition("ImagePack_" + param3 + "_Embeds");
         if(_loc4_ == null || _loc4_.classMap == null)
         {
            this.logger.fatal("Image pack loaded but no embedded assets found: " + param2);
            throw new Error("LoaderUtilImagePacks loaded image pack with no embedded assets: " + param2);
         }
         for(_loc5_ in _loc4_.classMap)
         {
            _loc6_ = _loc5_.toUpperCase();
            _loc6_ = _loc6_.replace(/-/g,"_");
            this._masterClassMap[_loc6_] = _loc4_.classMap[_loc5_];
         }
      }
   }
}

