package com.riotgames.platform.provider.loader
{
   import blix.IDestructible;
   import blix.action.BasicAction;
   import com.riotgames.platform.provider.ProviderLookup;
   import flash.utils.Dictionary;
   
   public class ProvidersClassLoader extends BasicAction implements IProvidersClassLoader, IDestructible
   {
      
      protected var _dependencies:Dictionary;
      
      protected var _providers:Array;
      
      public function ProvidersClassLoader(param1:Array, param2:Boolean = false)
      {
         var _loc3_:Class = null;
         super(param2);
         this._providers = param1;
         this._dependencies = new Dictionary();
         for each(_loc3_ in this._providers)
         {
            this._dependencies[_loc3_] = null;
         }
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Class = null;
         var _loc2_:ProviderClassLoaderHandler = null;
         for each(_loc1_ in this._providers)
         {
            _loc2_ = new ProviderClassLoaderHandler(_loc1_,this._dependencies,this.onLoadComplete);
            ProviderLookup.getProvider(_loc1_,_loc2_.handleLoadComplete,err);
         }
      }
      
      public function get dependencies() : Dictionary
      {
         return this._dependencies;
      }
      
      public function get providers() : Array
      {
         return this._providers;
      }
      
      private function onLoadComplete() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._dependencies)
         {
            if(_loc1_ == null)
            {
               return;
            }
         }
         complete();
      }
   }
}

import blix.signals.OnceSignal;
import com.riotgames.platform.provider.IProvider;
import flash.utils.Dictionary;

class ProviderClassLoaderHandler
{
   
   private var _clazz:Class;
   
   private var _targetDictionary:Dictionary;
   
   private var _loadComplete:OnceSignal = new OnceSignal();
   
   public function ProviderClassLoaderHandler(param1:Class, param2:Dictionary, param3:Function)
   {
      super();
      this._clazz = param1;
      this._targetDictionary = param2;
      this._loadComplete.add(param3);
   }
   
   public function handleLoadComplete(param1:IProvider) : void
   {
      this._targetDictionary[this._clazz] = param1;
      this._loadComplete.dispatch();
   }
}
