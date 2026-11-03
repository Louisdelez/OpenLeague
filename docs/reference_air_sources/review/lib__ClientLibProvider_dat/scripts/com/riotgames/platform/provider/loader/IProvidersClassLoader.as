package com.riotgames.platform.provider.loader
{
   import blix.IDestructible;
   import blix.action.IAction;
   import flash.utils.Dictionary;
   
   public interface IProvidersClassLoader extends IAction, IDestructible
   {
      
      function get dependencies() : Dictionary;
      
      function get providers() : Array;
   }
}

