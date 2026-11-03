package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.IProvider;
   
   [GenerateProxy]
   public interface IMainScreenProvider extends IProvider
   {
      
      function registerMainScreenFactory(param1:String, param2:Function) : void;
   }
}

